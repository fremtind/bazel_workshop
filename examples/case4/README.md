# Case 4: My first Java test

This case is a simple example of how to run Java tests with JUnit.

This is also the first case where we need external dependencies for Java.

See the [MODULE.bazel](../../MODULE.bazel) file for the dependencies.

After changing dependencies, run `REPIN=1 bazel run @maven//:pin` to update lockfile
