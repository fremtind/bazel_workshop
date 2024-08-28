# Case 6: CI tooling

## Steps to run CI with Bazel
To be able to run an effective CI pipeline with Bazel, there is a couple of things you want to know how to do.

1. Get a list of targets that have changed
1. Build and test only changed targets
1. Cache dependencies and build artifacts between builds
1. Find specific changed targets that should have additional steps (e.g. changed Docker images)


## An example implementation
In this workshop, we will use GitHub Actions to run our CI pipeline.  
To actually run the above steps, we use the following techniques:

1. We use [bazel-diff by Tinder](https://github.com/Tinder/bazel-diff) to get a list of affected Bazel targets between commits (with some filtering, see [.github/actions/bazel-changed-targets/filter_targets.sh](../../.github/actions/bazel-changed-targets/filter_targets.sh))
2. We use target selection in Bazel to only build and test the changed targets (see [.github/workflows/CI.yaml](../../.github/workflows/CI.yaml) for full implementation):  
```
# This is handled through xargs in case the list of targets is too long for the CLI to handle
echo '${{ steps.changed_targets.outputs.changed_targets }}' | xargs bazel build \
          --build_tag_filters=-container,-manual,-resource_intensive
```
3. In this workshop, we use [NativeLink](https://app.nativelink.com/) as a remote cache service to cache build artifacts. This way targets which are changed in the PR but not between builds will be cached and reused.
4. Bazel has a rich query model, and we can use this to find specific targets.  
To find all targets of kind `oci_image` in the workspace, you can run the following command:
```shell
bazel query "kind(oci_image, //...)"
```
This can be combined with the list of changed targets to find only the changed Docker images.
```shell
$CHANGED_TARGETS="//examples/case6:app_image //teams/team-1/java-app:app_image"
bazel query "kind(oci_image, set($CHANGED_TARGETS))"
```

## Additional tools
### tags
Bazel targets can be tagged, which works between target types.
Both the following examples will be tagged with `lib`:
```starlark
java_library(
    name = "example",
    srcs = glob(["src/main/java/**/*.java"]),
    tags = ["lib"],
)

npm_package(
    name = "pkg",
    srcs = glob(["*.js"]),
    package = "example",
    tags = ["lib"],
)
```
You can then query for all targets with the tag `lib`:
```shell
bazel query "attr(tags, lib, //...)"
```
Same as above, you can combine this with the list of changed targets to find only the affected libs:
```shell
bazel query "attr(tags, lib, set($CHANGED_TARGETS))"
```

## Additional things to try
### Run bazel-diff locally
You can run bazel-diff locally to see what targets have changed between two commits.
The script accepts two arguments, the commit hashes to compare.
It defaults the second argument to HEAD if not provided.
`./workshop/case6/bazel-diff.sh [oldest_commit_sha] [newest_commit_sha]`

Example:
```shell
./workshop/case6/bazel-diff.sh 234fb81c60890b5e771e151e162bcfef5b9b2a42 6b79fe920a6028ba74581d8888926d84523e2bdd
```
