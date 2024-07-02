load("@rules_kotlin//kotlin:jvm.bzl", "kt_jvm_library", "kt_jvm_test")
load("@contrib_rules_jvm//java:defs.bzl", "create_jvm_test_suite", "junit5_deps")
load("@rules_jvm_external//:defs.bzl", "DEFAULT_REPOSITORY_NAME", "artifact")

## Adapted from java_test_suite in contrib_rules_jvm
def get_package_name(prefixes):
    pkg = native.package_name().replace("/", ".")

    for prefix in prefixes:
        idx = pkg.find(prefix)
        if idx != -1:
            return pkg[idx + 1:] + "."

    return ""

def kotlin_junit5_test(
        name,
        test_class = None,
        runtime_deps = [],
        package_prefixes = [".com."],
        jvm_flags = [],
        include_tags = [],
        exclude_tags = [],
        include_engines = [],
        exclude_engines = [],
        size = "small",
        **kwargs):
    if test_class:
        clazz = test_class
    else:
        clazz = get_package_name(package_prefixes) + name

    if include_tags:
        jvm_flags = jvm_flags + ["-DJUNIT5_INCLUDE_TAGS=" + ",".join(include_tags)]

    if exclude_tags:
        jvm_flags = jvm_flags + ["-DJUNIT5_EXCLUDE_TAGS=" + ",".join(exclude_tags)]

    if include_engines:
        jvm_flags = jvm_flags + ["-DJUNIT5_INCLUDE_ENGINES=%s" % ",".join(include_engines)]

    if exclude_engines:
        jvm_flags = jvm_flags + ["-DJUNIT5_EXCLUDE_ENGINES=%s" % ",".join(exclude_engines)]

    security_manager_flag_seen = False
    for flag in jvm_flags:
        if flag.startswith("-Djava.security.manager="):
            security_manager_flag_seen = True
    if not security_manager_flag_seen:
        jvm_flags = jvm_flags + ["-Djava.security.manager=allow"]

    kt_jvm_test(
        name = name,
        main_class = "com.github.bazel_contrib.contrib_rules_jvm.junit5.JUnit5Runner",
        test_class = clazz,
        runtime_deps = runtime_deps + [
            "@contrib_rules_jvm//java/src/com/github/bazel_contrib/contrib_rules_jvm/junit5",
        ],
        jvm_flags = jvm_flags,
        size = "small",
        **kwargs
    )

def _define_kotlin_junit5_test(name, **kwargs):
    kotlin_junit5_test(
        name = name,
        include_engines = kwargs.pop("include_engines", None),
        exclude_engines = kwargs.pop("exclude_engines", None),
        **kwargs
    )
    return name

def _define_kotlin_library(name, **kwargs):
    kt_jvm_library(
        name = name,
        **kwargs
    )
    return name

def kotlin_test_suite(name, srcs, resources, deps, test_suffixes = ["Test.kt", "IT.kt"], package_prefixes = [".com."], jvm_flags = []):
    create_jvm_test_suite(
        name = name,
        srcs = srcs,
        test_suffixes = test_suffixes,
        package = "com.example",
        package_prefixes = package_prefixes,
        resources = resources,
        runner = "junit5",
        deps = deps,
        define_library = _define_kotlin_library,
        define_test = _define_kotlin_junit5_test,
        jvm_flags = jvm_flags,
        size = "small",
    )
