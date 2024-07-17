# CI workflow

Simple CI workflow, showing how to build and test all changed targets, and how to create a JSON matrix of changed containers and libs for further processing.

Shows rudimentary usage of bazel disk and repository caching, for better incremental build performance.

Using [Bazel Remote Caching](https://bazel.build/remote/caching) is recommended for better performance, but hard to set up for public repositories.
