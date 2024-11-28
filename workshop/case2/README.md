# Case 2: Hello, Java!

## About the case

This case uses the native java_binary and java_library rules. 
The java_library rule compiles and links sources into a .jar file 
The java_binary rule builds a jar file, plus a wrapper shell script.
See bazel-bin/workshop/case2/hello.runfiles/_main/workshop/case2/hello for the wrapper script.

This is also the first example that uses external depencencies from Maven, for example
`@maven//:org_assertj_assertj_core` which is a dependency for the `greeter-test` test-target.

All dependencies are resolved using the `MODULE.bazel` and the `maven_install.json` lockfile.
This generates the `@maven//` namespace and the Starlark-targets for the dependencies.

## Things to try out
### Build the lib
`bazel build //workshop/case2:greeter-lib` - builds the greeter-lib target and outputs the location for the resulting jar file.

### Run the binary
`bazel run //workshop/case2:hello` - runs the hello target, which depends on the greeter-lib target and outputs the result.

## Additional things to try out

### Get hello_world_from_greeter_test.sh to work

### Make your own library and consume it in the hello target

### Query Bazel for the dependency graph of the hello target:
`bazel query "deps(//workshop/case2:greeter-test)"`

interne deps
`bazel query "deps(//workshop/case2:greeter-test) intersect //..."`

maven deps 
`bazel query "deps(//workshop/case2:greeter-test) intersect @maven//..."`

