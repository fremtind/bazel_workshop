load("@npm//:openapi-typescript-codegen/package_json.bzl", openapi_bin = "bin")
load("@aspect_rules_js//npm:defs.bzl", "npm_package")
load("@openapi_tools_generator_bazel//:defs.bzl", "openapi_generator")

def openapi_spring(
        name,
        src,
        visibility,
        package_name,
        config_subpackage = True,
        models_subpackage = True,
        boolean_getter_prefix = "get",
        remove_enum_prefix = True,
        use_tags = True,
        extra_deps = []):
    native.java_library(
        name = name,
        srcs = [":{}.srcjar".format(name)],
        visibility = visibility,
        deps = [
            "@maven//:com_fasterxml_jackson_core_jackson_annotations",
            "@maven//:com_fasterxml_jackson_core_jackson_core",
            "@maven//:com_fasterxml_jackson_core_jackson_databind",
            "@maven//:com_google_code_findbugs_jsr305",
            "@maven//:com_google_code_gson_gson",
            #            "@maven//:com_squareup_okhttp3_logging_interceptor",
            #            "@maven//:com_squareup_okhttp3_okhttp",
            "@maven//:io_gsonfire_gson_fire",
            "@maven//:io_swagger_core_v3_swagger_annotations",
            "@maven//:jakarta_annotation_jakarta_annotation_api",
            "@maven//:jakarta_servlet_jakarta_servlet_api",
            "@maven//:jakarta_validation_jakarta_validation_api",
            #            "@maven//:org_apache_commons_commons_lang3",
            "@maven//:org_openapitools_jackson_databind_nullable",
            "@maven//:org_springframework_spring_context",
            "@maven//:org_springframework_spring_web",
            "@maven//:org_threeten_threetenbp",
        ] + extra_deps,
    )

    model_package = models_subpackage and "{}.models" or "{}"
    config_package = config_subpackage and "{}.config" or "{}"

    openapi_generator(
        name = "{}_build_spring".format(name),
        additional_properties = {
            "useTags": use_tags and "true" or "false",
            "packageName": package_name,
            "apiPackage": package_name,
            "modelPackage": model_package.format(package_name),
            "configPackage": config_package.format(package_name),
            "booleanGetterPrefix": boolean_getter_prefix,
            "interfaceOnly": "true",
            "unhandledException": "true",
            "serializableModel": "true",
            "openApiNullable": "false",
            "useSpringBoot3": "true",
            "removeEnumValuePrefix": remove_enum_prefix and "true" or "false",
        },
        generator = "spring",
        spec = src,
    )

    # genrules cannot output unknown files or whole directories, so this is a way to zip up the result as a single .srcjar instead
    native.genrule(
        name = "{}_build_spring_srcs".format(name),
        srcs = ["{}_build_spring".format(name)],
        outs = ["{}.srcjar".format(name)],
        cmd = "org_src=\"$(location :{src})/src/main/java\"".format(src = "{}_build_spring".format(name)) + """
    files=$$(find -L $$org_src -type f)
    zipper_args=()
    for f in $${files[@]}; do
      path_in_zip="$${f/$$org_src}"
      zipper_args+=("$$path_in_zip=$$f")
    done
    $(location @bazel_tools//tools/zip:zipper) c $@ $${zipper_args[@]}
    """,
        tools = ["@bazel_tools//tools/zip:zipper"],
    )

def openapi_typescript(name, src, exportFetch = False):
    npm_package(
        name = name,
        srcs = ["{}_typescript_types".format(name)],
        package = name,
        root_paths = [
            native.package_name(),
        ],
        visibility = ["//visibility:public"],
    )
    openapi_bin.openapi(
        name = "{}_typescript_types".format(name),
        srcs = [src],
        args = [
            "-i " + src,
            "-o ./types",
            "--exportServices {}".format(str(exportFetch).lower()),
            "--exportCore {}".format(str(exportFetch).lower()),
            "--exportModels true",
            "--exportSchemas true",
            "--useUnionTypes",
        ],
        chdir = native.package_name(),
        out_dirs = ["types"],
    )
