// 1. 필요한 Java 클래스를 import 합니다.
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") version "4.3.15"
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 2. key.properties 파일을 로드하는 코드를 android 블록 밖으로 이동하여 가독성을 높입니다.
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}

android {
    namespace = "shop.meong.meongtamjeong"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // flutter.ndkVersion 대신 특정 버전 명시

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "shop.meong.meongtamjeong"
        minSdk = 23 // flutter.minSdkVersion 대신 특정 버전 명시
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 3. signingConfigs에 debug와 release 설정을 모두 포함합니다.
    signingConfigs {
        getByName("debug") {
            // 안드로이드 기본 debug.keystore를 명시적으로 사용
            storeFile = file(System.getProperty("user.home") + "/.android/debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
        create("release") {
            if (keyPropertiesFile.exists()) {
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            // release 빌드 시 release 서명을 사용하도록 설정
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            // debug 빌드 시 debug 서명을 사용하도록 설정 (명시적으로 추가)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}