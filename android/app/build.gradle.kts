import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.rideapp.mobile"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs += listOf(
            "-Xjvm-default=all",
            "-opt-in=kotlin.RequiresOptIn",
            "-Xmetadata-version=1.9.0"
        )
    }

    defaultConfig {
        applicationId = "com.rideapp.mobile"
        minSdk = 24
        targetSdk = 35
        versionCode = 3
        versionName = "1.0.1"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            val storeFilePath = keystoreProperties["storeFile"]
            storeFile = if (storeFilePath != null) file(storeFilePath.toString()) else null
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    
    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false  // Temporarily disable R8
            isShrinkResources = false  // Disable resource shrinking
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    lint {
        disable += "InvalidPackage"
        checkReleaseBuilds = false
    }
    
    // Handle webview plugin configuration
    packaging {
        jniLibs {
            pickFirsts.add("**/libc++_shared.so")
            pickFirsts.add("**/libjsc.so")
        }
        resources {
            pickFirsts.add("**/META-INF/play-core-common.version")
            excludes.add("META-INF/DEPENDENCIES")
            excludes.add("META-INF/LICENSE")
            excludes.add("META-INF/LICENSE.txt")
            excludes.add("META-INF/license.txt")
            excludes.add("META-INF/NOTICE")
            excludes.add("META-INF/NOTICE.txt")
            excludes.add("META-INF/notice.txt")
            excludes.add("META-INF/ASL2.0")
            excludes.add("META-INF/*.kotlin_module")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
    implementation(platform("com.google.firebase:firebase-bom:32.7.1"))
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.20")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.20")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("androidx.window:window:1.1.0")
    implementation("androidx.window:window-java:1.1.0")
    
    // Force specific versions to avoid SDK 35 requirements
    constraints {
        implementation("androidx.core:core:1.12.0")
        implementation("androidx.core:core-ktx:1.12.0")
        implementation("androidx.lifecycle:lifecycle-runtime:2.6.2")
        implementation("androidx.lifecycle:lifecycle-common:2.6.2")
        implementation("androidx.concurrent:concurrent-futures:1.1.0")
        implementation("androidx.tracing:tracing:1.1.0")
    }
}

configurations.all {
    resolutionStrategy {
        // Force all Kotlin dependencies to use the same version
        eachDependency { details: DependencyResolveDetails ->
            if (details.requested.group == "org.jetbrains.kotlin") {
                details.useVersion("1.8.20")
            }
        }
        // Force Firebase dependencies to use compatible Kotlin version
        force("org.jetbrains.kotlin:kotlin-stdlib:1.8.20")
        force("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.20")
        force("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.20")
    }
}
