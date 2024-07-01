# Bazelrc settings from aspect-build

Bazel has a lot of options that affects the build, and navigating them can be hard. Aspect-build provides a set of default settings that are recommended for most projects. These settings are stored in the `.aspect/bazelrc` directory.

Read more at https://docs.aspect.build/guides/bazelrc/


## Updating
To update the rc files, run
`bazel run //.aspect/bazelrc:update_aspect_bazelrc_presets`
