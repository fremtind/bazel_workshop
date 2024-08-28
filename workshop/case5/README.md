# Case 5: OpenAPI specs and multi-language builds

In this case, we will use the OpenAPI specs to generate library code in multiple languages, which we in turn will use in our workshop.

## Additional things to try

### What happens when you rename the `hello` property in `HelloWorldResponse`?
Try running `bazel test --build_tests_only //workshop/...` after removing the property

## Gotchas with this approach
While this works as expected, if you only use pnpm for frontend-builds (not Bazel), you have to manually rebuild the OpenAPI target in Bazel to get updates to the package. 
