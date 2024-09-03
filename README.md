# Fremtind Bazel workshop

## Getting started
- Install Bazelisk: https://bazel.build/install/bazelisk
- Clone this repository
- Ensure you have a JDK 21 installed, any should work but Zulu is recommended (See troubleshooting if you have issues)
- Run `bazel build //workshop/case1:hello` to see if everything is working
- Check out the workshop cases below 

## Troubleshooting
- For Mac, openjdk installed through homebrew is missing some libs - try with Zulu JDK `brew install --cask zulu@21`
- If Bazel picks up the wrong JDK, you can set the JAVA_HOME environment variable to the correct path and run `echo "startup --server_javabase=\"$JAVA_HOME\"" >> $HOME/.bazelrc` to explicitly tell Bazel to use the correct JDK

## Overview
This repo contains simple examples to get you started with Bazel.

It also contains a CI workflow that shows how to build and test all changed targets, and how you can use Bazel to build containers in multiple languages with the same CI setup.

### Workshop
 - Case 1: [Hello World in Bazel](workshop/case1/README.md)
 - Case 2: [Simple Java application](workshop/case2/README.md)
 - Case 3: [Generate code from OpenApi specifications](workshop/case3/README.md)
 - Case 4: [Spring Boot in Bazel](workshop/case4/README.md)
 - Case 5: [Vite + React frontend in Bazel](workshop/case5/README.md)
 - Case 6: [Bazel in CI / multiple teams](workshop/case6/README.md)

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

### Teams
Contains larger applications with multiple languages and toolsets.
Also used as an example how you can structure your monorepo to leverage Team isolation, and thereby also make it possible to use [git sparse-checkout](https://github.blog/2020-01-17-bring-your-monorepo-down-to-size-with-sparse-checkout/) to keep only files relevant to you visible. 


## Other resources
- [Bazel documentation](https://bazel.build/start) official documentation
- [Bazel Examples](https://github.com/aspect-build/bazel-examples) from Aspect Dev
- [Bazel on Slack](https://bazelbuild.slack.com) (You can find us here if you want to chat about anything Bazel related!)
- [Aspect dev docs](https://docs.aspect.build/) contains a lot of good examples and explanations

## Windows 
Add to .bazelrc
startup --output_user_root=C:/tmp
