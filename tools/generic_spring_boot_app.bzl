load("//tools:spring_boot_app.bzl", "spring_boot_app")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_files", "strip_prefix")
load("@rules_pkg//:pkg.bzl", "pkg_tar")
load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load("//tools:stamp_tags.bzl", "stamp_tags")
load("//tools:container_image.bzl", "stamped_container_image")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@contrib_rules_jvm//java:defs.bzl", "java_test_suite", "junit5_deps")

def generic_spring_boot_app(name, package, srcs, test_srcs, deps = [], test_deps = [], resources = None, test_resources = None, dupeclass_ignore = None, spring_profiles_active = ["dev"]):
    java_library_name = "{}_app_libs".format(name)
    native.java_library(
        name = java_library_name,
        srcs = srcs,
        resources = resources,
        deps = deps,
        visibility = ["//visibility:public"],
    )

    spring_boot_app(
        name = name,
        java_library = ":{}".format(java_library_name),
        package = package,
        dupeclass_ignore = dupeclass_ignore,
        spring_profiles_active = spring_profiles_active,
    )

    java_test_suite(
        name = "junit5-tests",
        srcs = test_srcs,
        test_suffixes = ["Test.java", "IT.java"],
        package_prefixes = [".no."],
        resources = test_srcs,
        runner = "junit5",
        deps = junit5_deps() + [
            ":{}".format(java_library_name),
        ] + test_deps,
        jvm_flags = [
            "--add-opens=java.base/java.lang=ALL-UNNAMED",
        ],
        size = "small",
    )

    stamp_tags(
        name = "stamp_substitutions",
        remote_tags = [
            """ "app.version=" + ($stamp[0]."STABLE_app.version" // "dev")""",
        ],
    )

    write_file(
        name = "generate_app_yml",
        out = "app.yml.tmpl",
        content = [
            """
app:
  version: ${app.version}
""",
        ],
    )

    expand_template(
        name = "app_yml",
        template = "generate_app_yml",
        out = "app.yml",
        substitutions = {
            "app.version": "dev",
        },
        stamp_substitutions = {
            "app.version": "{{STABLE_app.version}}",
        },
    )

    pkg_files(
        name = "pkg_app",
        srcs = [
            ":{}.jar".format(name),  # produced by springboot rule
        ],
        prefix = "/opt/app",
        strip_prefix = strip_prefix.from_pkg(),
    )

    pkg_files(
        name = "pkg_app_yml",
        srcs = [
            ":app_yml",
        ],
        prefix = "/opt/app",
    )

    pkg_tar(
        name = "tar",
        srcs = [
            ":pkg_app",
            ":pkg_app_yml",
        ],
        include_runfiles = True,
        strip_prefix = ".",
        tags = ["manual", "no-cache"],
    )

    stamped_container_image(
        name = name,
        base_image = "@eclipse_temurin_21",
        image_layers = [
            ":tar",
        ],
        entrypoint = [
            "java",
            "-jar",
            "/opt/app/app.jar",
            "--spring.config.additional-location=/opt/app/app.yml",
            "server",
        ],
        container_test_configs = ["//apps/team-smart-utvikling/build-tools/shifter2:backend_test"],
    )