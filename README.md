# Fremtind Bazel workshop

## Getting started
- Install Bazelisk: https://bazel.build/install/bazelisk
- Clone this repository
- Run `bazel build //workshop/case1:hello` to see if everything is working
- Check out the workshop cases below 

## Overview
This repo contains simple examples to get you started with Bazel.

It also contains a CI workflow that shows how to build and test all changed targets, and how you can use Bazel to build containers in multiple languages with the same CI setup.

### Workshop
 - [Case 1: Hello World in Bazel](workshop/case1/README.md)
   - Introduction to simple genrule targets and target dependencies
 - [Case 2: Simple Java application](workshop/case2/README.md)
   - Building a simple Java application using native rules_java with tests
 - [Case 3: OpenApi specs](workshop/case3/README.md)
   - Generate Java and TypeScript from OpenApi specs
   - Consume the generated code in a Spring Boot application and a React frontend
 - [Case 4: Spring Boot in Bazel](workshop/case4/README.md)
   - Introducing rules_spring
   - Building a Spring Boot application with tests
   - Creating a Docker image
 - [Case 5: Vite + React frontend in Bazel](workshop/case5/README.md)
   - Introducing rules_js
   - Bulding a Vite + React frontend application with tests
   - Creating a Docker image
 - [Case 6: Bazel CI](workshop/case6/README.md)
   - Explains the CI workflow in this repository
   - Show how to use tags and queries to select targets

### Workshop
Intro: 15min

Om oss
Hva er Bazel
Hvorfor Bazel og monorepo
Kjapt om Bazel (build, test, query)
Hvordan 3. parts dependencies håndteres

Cases:
15min per case
60min

pause: 10min

Outtro: 10min
Veien videre
Mer om bazel_workshop repoet og hva man kan finne av eksempel
Kontakt oss


 - Case 1: Hello World in Bazel
   - Change the text in the `hello` target, see which targets gets rebuilt
   - Run tests
   - Bazel queries
 - Case 2: Simple Java application
   - Create a second Java library
   - Run tests
   - Make commented out test pass
   - Lag en macro for å bygge caset
 - Case 3: Spring Boot in Bazel
   - Docker eksempel
     - Eksempel på docker build + docker run
     - multi-arch
   - Nye regelsett
   - Eksterne dependencies
   - wget test mot et endepunkt
 - Case 4: Vite + React frontend in Bazel
   - Docker eksempel
 - Case 5: OpenApi specs
   - Generate code from OpenApi specs
 - Case 6: Bazel CI / teams
   - Build changed targets
   - Stamping?
   - query changed oci_image

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
- [Bazel on Slack](https://bazelbuild.slack.com)
- [Aspect dev docs](https://docs.aspect.build/) contains a lot of good examples and explanations
