# Scripts

These scripts are used in the build to add metadata to the build artifacts, when stamping is enabled.

`get_release_version` is a script that generates the release version of the current commit.
In our setup, it is the date+commit hash of the current commit.

`get_workspace_status` is used when running Bazel with `--config=release`. It generates a file that contains stable properties that ends up in `bazel-out/stable-status.txt`. 
Changes to the ``stable-status.txt`` file will trigger a rebuild of all targets that are configured to listen to `stamping`.

Read more about [stamping here from Aspect docs](https://docs.aspect.build/rulesets/aspect_bazel_lib/docs/stamping/)

See example usage in the [Spring Boot app macro](../tools/generic_spring_boot_app.bzl)
