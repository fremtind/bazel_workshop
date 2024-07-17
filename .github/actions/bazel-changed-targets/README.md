# bazel-changed-targets

Action to get the list of changed targets in a Bazel monorepo.
It also filters out targets which are not necessary to act upon in themselves,
like changed `.git/**` files (which always change between commits) or `//external` targets as changes there propagate to the targets we care about anyway.

It also creates a JSON matrix of changed containers and libs to make it easier to use them in a CI workflow strategy, see [CI.yaml publish or lib jobs](../../workflows/CI.yaml).

We use [bazel-diff by Tinder](https://github.com/Tinder/bazel-diff) to get the list of changed targets between two commits.
