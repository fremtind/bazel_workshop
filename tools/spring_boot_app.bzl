load("@rules_spring//springboot:springboot.bzl", "springboot")

def spring_boot_app(name, package, java_library = None, dupeclass_ignore = None, spring_profiles_active = []):
    if (java_library == None):
        fail("java_library is required")

    bazelrun_jvm_flags = None
    if len(spring_profiles_active) > 0:
        bazelrun_jvm_flags = "-Dspring.profiles.active=" + ",".join(spring_profiles_active)
    springboot(
        name = name,
        boot_app_class = package + ".Main",
        dupeclassescheck_enable = True,
        dupeclassescheck_ignorelist = dupeclass_ignore,
        java_library = java_library,
        tags = ["app"],
        bazelrun_jvm_flags = bazelrun_jvm_flags,
        bazelrun_script = "@rules_spring//springboot:default_bazelrun_script.sh",
        include_git_properties_file = False,
        boot_launcher_class = "org.springframework.boot.loader.launch.JarLauncher",
    )
