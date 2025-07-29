buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.10.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://kotlin.bintray.com/kotlinx") }
    }
    
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.12.0")
            force("androidx.core:core-ktx:1.12.0")
            force("androidx.collection:collection:1.2.0")
            force("androidx.collection:collection-ktx:1.2.0")
            force("androidx.annotation:annotation:1.7.0")
            force("androidx.annotation:annotation-experimental:1.3.0")
            force("androidx.lifecycle:lifecycle-runtime:2.6.2")
            force("androidx.lifecycle:lifecycle-common:2.6.2")
            force("androidx.lifecycle:lifecycle-common-java8:2.6.2")
            force("androidx.concurrent:concurrent-futures:1.1.0")
            force("androidx.concurrent:concurrent-futures-ktx:1.1.0")
            force("androidx.tracing:tracing:1.1.0")
            force("androidx.tracing:tracing-ktx:1.1.0")
            
            // Force all Kotlin dependencies to use the same version
            eachDependency {
                if (requested.group == "org.jetbrains.kotlin") {
                    useVersion("1.9.10")
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(layout.buildDirectory)
}
