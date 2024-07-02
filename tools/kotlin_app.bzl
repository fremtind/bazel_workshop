load("//build-tools:spring_boot_app.bzl", "spring_boot_app")
load("//build-tools/shifter2:shifter_build_2.bzl", "default_run_sh", "default_run_sh_entrypoint", "shifter_2_build_steps")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_files", "strip_prefix")
load("//build-tools:app_info.bzl", "team_name")
load("//build-tools/expand_template:expand_template.bzl", "expand_template")
load("//build-tools:stamp_tags.bzl", "stamp_tags")
load("@bazel_sonarqube//:defs.bzl", "sonarqube")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

def generic_spring_boot_app(name, package, srcs, test_srcs, deps = [], test_deps = [], resources = None, test_resources = None, dupeclass_ignore = None, spring_profiles_active = ["dev"]):
    java_library_name = "{}_app_libs".format(name)
    java_library(
        name = java_library_name,
        srcs = srcs,
        resources = resources,
        deps = deps,
        visibility = ["//visibility:public"],
    )

    spring_boot_app(
        name = name,
        java_library_name = ":{}".format(java_library_name),
        package = package,
        dupeclass_ignore = dupeclass_ignore,
        spring_profiles_active = spring_profiles_active,
    )

    java_test_suite(
        name = "junit5-tests",
        srcs = native.glob(["src/test/**/*.java"]),
        test_suffixes = ["Test.java", "IT.java"],
        package_prefixes = [".no."],
        resources = native.glob(["src/test/resources/**/*"]),
        runner = "junit5",
        deps = junit5_deps() + [
            ":app_libs",
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
        substitution_file = ":stamp_substitutions",
    )

    pkg_files(
        name = "pkg_app",
        srcs = [
            ":app.jar",
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

    shifter_2_build_steps(
        name = name,
        image_name = name,
        base_image = "@eclipse_temurin_21",
        pkg_srcs = [
            ":pkg_app",
            ":pkg_app_yml",
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
