# Case 3: OpenAPI specs and multi-language builds

In this case, we will use the OpenAPI specs to generate library code in multiple languages, which we in turn will use in our workshop.

## Things to try

### Figure out which cases depends on the `openapi_spring` target
In the previous case there is an example of querying reverse dependencies - can you figure out which case depends on the `openapi_spring` target?

### Can you locate the generated code in the `bazel-bin` directory?

### What happens if you try to change the visibility of the `openapi_spring` target to for example `//teams:__subpackages__`?
Visibility of a target is a key feature in Bazel to control who can depend on a target. Try changing the visibility of the `openapi_spring` target and then run `bazel build //workshop/...` to rebuild all workshop cases

## Additional things to try

### What happens when you rename the `hello` property in `HelloWorldResponse`?
Try running `bazel test --build_tests_only //workshop/...` after removing the property

## Gotchas with this approach
While this works as expected, if you only use pnpm for frontend-builds (not Bazel), you have to manually rebuild the OpenAPI target in Bazel to get updates to the package. 
