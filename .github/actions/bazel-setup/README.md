# bazel-setup

Action to make it easy to set up Bazel the same between workflows.

Automatically sets up remote caching through [NativeLink](https://app.nativelink.com/).
This is a free service that speeds up your builds by caching build artifacts.

For production use, you should consider which service to use for yourself.
We do not use NativeLink at Fremtind, and this is not an endorsement of the service.
