load("//tools:spring_boot_app.bzl", "spring_boot_app")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_files", "strip_prefix")
load("@rules_pkg//:pkg.bzl", "pkg_tar")
load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load("//tools:stamp_tags.bzl", "stamp_tags")
load("//tools:container_image.bzl", "stamped_container_image")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@contrib_rules_jvm//java:defs.bzl", "java_test_suite", "junit5_deps")
load("//tools:kotlin_test_suite.bzl", "kotlin_test_suite")

def generic_spring_boot_app(name, package, java_library, test_srcs, test_deps = [], resources = None, test_resources = None, dupeclass_ignore = None, spring_profiles_active = ["dev"]):
    spring_boot_app(
        name = "app",
        java_library = java_library,
        package = package,
        dupeclass_ignore = dupeclass_ignore,
        spring_profiles_active = spring_profiles_active,
    )

    java_test_srcs = []
    kotlin_test_srcs = []
    if (test_srcs):
        java_test_srcs = [src for src in test_srcs if src.endswith(".java")]
        kotlin_test_srcs = [src for src in test_srcs if src.endswith(".kt")]

    if (java_test_srcs):
        java_test_suite(
            name = "java-junit5-tests",
            srcs = java_test_srcs,
            test_suffixes = ["Test.java", "IT.java"],
            package_prefixes = [".com."],
            resources = test_resources,
            runner = "junit5",
            deps = junit5_deps() + [
                java_library,
            ] + test_deps,
            jvm_flags = [
                "--add-opens=java.base/java.lang=ALL-UNNAMED",
            ],
            size = "small",
        )

    if (kotlin_test_srcs):
        kotlin_test_suite(
            name = "kotlin-junit5-tests",
            srcs = kotlin_test_srcs,
            test_suffixes = ["Test.kt", "IT.kt"],
            package_prefixes = [".com."],
            resources = test_resources,
            deps = junit5_deps() + [
                java_library,
            ] + test_deps,
            jvm_flags = [
                "--add-opens=java.base/java.lang=ALL-UNNAMED",
            ],
        )

    # This target is used to read the app.version from the workspace status file (bazel-out/stable-status.txt)
    stamp_tags(
        name = "stamp_substitutions",
        remote_tags = [
            """ "app.version=" + ($stamp[0]."STABLE_app.version" // "dev")""",
        ],
    )

    # Generate app.yml file which supports replacing the app.version variable
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

    # Expand the template and stamp the app.version variable if the build is run with --stamp (or --config=release)
    # if --stamp is not set, replace the variable with "dev"
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
            ":app.jar",  # produced by springboot rule
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
    )
