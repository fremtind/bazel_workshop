load("@npm//examples/case7:vite/package_json.bzl", vite_bin = "bin")
load("@aspect_rules_js//js:defs.bzl", "js_run_devserver")

def vite_build(name, srcs, config, out_dir, **kwargs):
    vite_bin.vite(
        name = name,
        srcs = srcs,
        args = [
            "build",
            "--config",
            config,
        ],
        chdir = native.package_name(),
        out_dirs = [out_dir],
        **kwargs
    )

def vite_dev_server(name, srcs, config, out_dir):
    vite_bin.vite_binary(name = "vite_dev")
    js_run_devserver(
        name = name,
        data = srcs,
        args = [
            "dev",
            "--config",
            config,
        ],
        chdir = native.package_name(),
        tool = ":vite_dev",
    )
