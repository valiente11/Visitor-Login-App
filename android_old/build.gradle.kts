// android/build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Android Gradle Plugin sürümünü projenize uyarlayabilirsiniz
        classpath("com.android.tools.build:gradle:8.3.0")
        // Eğer Google Services plugin kullanıyorsanız ekleyin, yoksa bu satırı atlayın
        // classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
