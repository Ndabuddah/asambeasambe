pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

            resolutionStrategy {
            eachPlugin {
                if (requested.id.id.startsWith("org.jetbrains.kotlin")) {
                    useVersion("1.9.10")
                }
                if (requested.id.id.startsWith("com.android")) {
                    useVersion("8.10.1")
                }
            }
        }

    plugins {
        id("org.gradle.toolchains.foojay-resolver-convention") version("0.5.0")
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.10.1" apply false
    id("com.google.gms.google-services") version "4.4.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.10" apply false
}

include(":app")

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        google()
        mavenCentral()
    }
    
    versionCatalogs {
        create("libs") {
            version("kotlin", "1.9.10")
            version("agp", "8.10.1")
            version("firebase-bom", "32.7.1")
            version("androidx-core", "1.12.0")
        }
    }
}

gradle.rootProject {
    project.extra["embeddedKotlinVersion"] = "1.9.10"
}
