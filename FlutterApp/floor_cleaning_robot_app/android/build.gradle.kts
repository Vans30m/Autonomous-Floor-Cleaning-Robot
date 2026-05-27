allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
subprojects {
    project.buildscript.configurations.configureEach {}
    plugins.withId("com.android.library") {
        val android = extensions.getByName("android") as com.android.build.gradle.BaseExtension
        if (android.namespace.isNullOrEmpty()) {
            val manifest = project.file("src/main/AndroidManifest.xml")
            if (manifest.exists()) {
                val pkg = Regex("package=\"([^\"]+)\"").find(manifest.readText())?.groupValues?.get(1)
                if (pkg != null) {
                    android.namespace = pkg
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
