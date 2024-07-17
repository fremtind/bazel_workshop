# bazel-setup

Action to make it easy to set up Bazel the same between workflows.

Automatically sets up disk-cache and repository-cache to speed up builds.

For a production setup, you should consider setting up a [remote cache service](https://bazel.build/remote/caching).
