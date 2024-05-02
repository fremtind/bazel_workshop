# Case 4 - Java tests

This case is a simple example of how to run Java tests with JUnit.

This is also the first case where we need external dependencies for Java.

See the [MODULE.bazel](../../MODULE.bazel) file for the dependencies.

After changing dependencies, run `bazel run @unpinned_rules_jvm_external~~maven~maven//:pin` to update lockfile
