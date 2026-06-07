# Hive
-keep class * extends com.google.flatbuffers.Table { *; }
-keep class io.hive.** { *; }
-keepclassmembers class * {
    @io.hive.** *;
}
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
