load("@rules_oci//oci:defs.bzl", "oci_image", "oci_push", "oci_tarball")

#load("@rules_pkg//pkg:mappings.bzl", "pkg_files", "strip_prefix")
#load("@container_structure_test//:defs.bzl", "container_structure_test")
load("//tools:stamp_tags.bzl", "stamp_tags")
load("@aspect_bazel_lib//lib:jq.bzl", "jq")

def stamped_container_image(name, base_image, image_layers, cmd = None, entrypoint = None, workdir = None, container_test_configs = []):
    stamp_tags(
        name = "app_image_labels",
        remote_tags = [
            """ "app.version=" + ($stamp[0]."STABLE_app.version" // "dev")""",
            """ "app.branch=" + ($stamp[0]."STABLE_git.branch" // "dev")""",
            """ "app.author=" + ($stamp[0]."STABLE_git.commit.user.email" // "dev")""",
        ],
        tags = ["manual"],
    )

    oci_image(
        name = "app_image",
        base = base_image,
        entrypoint = entrypoint,
        cmd = cmd,
        labels = ":app_image_labels",
        tars = image_layers,
        tags = ["container", "no-cache"],
        workdir = workdir,
    )

    stamp_tags(
        name = "repo_tags",
        remote_tags = [
            """ "{}:" + ($stamp[0]."STABLE_app.version" // "dev")""".format(name),
        ],
        tags = ["manual"],
    )

    # Run a local container with:
    # $ bazel run :tarball
    # $ docker run --rm bazel/example:latest
    oci_tarball(
        name = "tarball",
        image = ":app_image",
        repo_tags = ":repo_tags",
        tags = ["manual", "no-cache"],
    )
