# Fremtind Bazel workshop

## Getting started
- Install Bazelisk: https://bazel.build/install/bazelisk
- Install Bazel plugin for your favorite IDE:
  - Intellij: https://plugins.jetbrains.com/plugin/8609-bazel-for-intellij
  - VSCode: https://marketplace.visualstudio.com/items?itemName=BazelBuild.vscode-bazel
- Clone this repository
- Run `bazel build //examples/case1:hello` to see if everything is working
- Check out the example cases below 

## Overview
This repo contains simple examples to get you started with Bazel.

It also contains a CI workflow that shows how to build and test all changed targets, and how you can use Bazel to build containers in multiple languages with the same CI setup.

### Bazel concepts
- Build graph
- Tagging
- Stamping
- Rules
- Macros
- Visibility

### Workshop
 - Case 1: Hello World in Bazel
   - Change the text in the `hello` target, see which targets gets rebuilt
   - Run tests
   - Bazel queries
 - Case 2: Simple Java application
   - Create a second Java library
   - Run tests
 - Case 3: Spring Boot in Bazel
 - Case 4: Docker in Bazel
 - Case 5: Vite + React frontend in Bazel

### Remote caching
This workshop works with a free online remote cache to speed up builds, called [NativeLink](https://app.nativelink.com/).
Register for a free account, and the configuration from the service to `.aspect/bazelrc/user.bazelrc` which will not be checked in to the repository.

Example:
```
build --remote_cache=grpcs://cas-<github-user>.build-faster.nativelink.net
build --remote_header=x-nativelink-api-key=<api-key>
build --bes_backend=grpcs://bes-<github-user>.build-faster.nativelink.net
build --bes_header=x-nativelink-api-key=<api-key>
build --remote_timeout=600
```

This is in use by the CI workflow for this repository as well, and will speed up your builds significantly.

### Examples
- [Case 1: Hello World in Bazel](examples/case1/README.md)
- [Case 2: Shell scripts](examples/case2/README.md)
- [Case 3: My first Java executable](examples/case3/README.md)
- [Case 4: My first Java test](examples/case4/README.md)
- [Case 5: My first Spring Boot app](examples/case5/README.md)
- [Case 6: My first docker image](examples/case6/README.md)
- [Case 7: My first frontend application](examples/case7/README.md)

### Teams
Contains larger applications with multiple languages and toolsets.
Also used as an example how you can structure your monorepo to leverage Team isolation, and thereby also make it possible to use [git sparse-checkout](https://github.blog/2020-01-17-bring-your-monorepo-down-to-size-with-sparse-checkout/) to keep only files relevant to you visible. 


## Other resources
- [Bazel documentation](https://bazel.build/start)
- Aspect
- Bazel Examples
- Slack community
