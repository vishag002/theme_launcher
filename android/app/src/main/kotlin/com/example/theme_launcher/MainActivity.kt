package com.example.theme_launcher

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import io.flutter.embedding.engine.plugins.FlutterPlugin

class MainActivity : FlutterActivity() {
    private val LAUNCHER_CHANNEL = "com.example.theme_launcher/launcher"
    private val INFO_CHANNEL = "com.example.theme_launcher.app/info"
    private val DEFAULT_LAUNCHER_CHANNEL = "com.example.theme_launcher/default_launcher"
    private val NOTIFICATION_PANEL_CHANNEL = "com.example.theme_launcher/notification_panel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Configure the channels for communication between Flutter and Android
        setupLauncherChannel(flutterEngine)
        setupInfoChannel(flutterEngine)
        setupDefaultLauncherChannel(flutterEngine)
        setupNotificationPanelChannel(flutterEngine)
    }

    private fun setupLauncherChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LAUNCHER_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> result.success(getInstalledApps())
                "launchApp" -> launchApp(call.argument<String>("packageName"), result)
                "closeApp" -> closeApp(call.argument<String>("packageName"), result)
                "uninstallApp" -> uninstallApp(call.argument<String>("packageName"), result)
                else -> result.notImplemented()
            }
        }
    }

    private fun setupInfoChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INFO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openAppInfo") {
                openAppInfo(call.argument<String>("packageName"), result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setupDefaultLauncherChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEFAULT_LAUNCHER_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isDefaultLauncher") {
                val packageName = call.argument<String>("packageName")
                result.success(packageName?.let { isDefaultLauncher(it) } ?: run {
                    result.error("INVALID_ARGUMENT", "Package name is required", null)
                })
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setupNotificationPanelChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_PANEL_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openNotificationPanel") {
                openNotificationPanel()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getInstalledApps(): List<Map<String, String>> {
        val pm = packageManager
        val apps = pm.getInstalledApplications(PackageManager.GET_META_DATA)
        return apps.filter { pm.getLaunchIntentForPackage(it.packageName) != null }
            .map { app ->
                val appName = pm.getApplicationLabel(app).toString()
                val appIconBase64 = getAppIconBase64(app.packageName)
                mapOf(
                    "packageName" to app.packageName,
                    "appName" to appName,
                    "appIcon" to appIconBase64
                )
            }
    }

    private fun getAppIconBase64(packageName: String): String {
        return try {
            val drawable = packageManager.getApplicationIcon(packageName)
            if (drawable is BitmapDrawable) {
                val bitmap = drawable.bitmap
                val outputStream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT)
            } else {
                Log.w("LauncherApp", "Unsupported drawable type: ${drawable::class.java.simpleName}")
                ""
            }
        } catch (e: Exception) {
            Log.e("LauncherApp", "Failed to get app icon: ${e.message}")
            ""
        }
    }

    private fun launchApp(packageName: String?, result: MethodChannel.Result) {
        if (packageName != null) {
            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                startActivity(launchIntent)
                result.success(null)
            } else {
                result.error("ERROR", "Could not launch app: $packageName", null)
            }
        } else {
            result.error("INVALID_ARGUMENT", "Package name is required", null)
        }
    }

    private fun closeApp(packageName: String?, result: MethodChannel.Result) {
        if (packageName != null) {
            val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            am.killBackgroundProcesses(packageName)
            result.success(null)
        } else {
            result.error("INVALID_ARGUMENT", "Package name is required", null)
        }
    }

    private fun uninstallApp(packageName: String?, result: MethodChannel.Result) {
        if (packageName != null) {
            val intent = Intent(Intent.ACTION_DELETE).apply {
                data = Uri.parse("package:$packageName")
            }
            startActivity(intent)
            result.success(null)
        } else {
            result.error("INVALID_ARGUMENT", "Package name is required", null)
        }
    }

    private fun openAppInfo(packageName: String?, result: MethodChannel.Result) {
        if (packageName != null) {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            startActivity(intent)
            result.success(null)
        } else {
            result.error("INVALID_ARGUMENT", "Package name is required", null)
        }
    }

    private fun isDefaultLauncher(packageName: String): Boolean {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
        }
        val resolveInfo = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
        return resolveInfo?.activityInfo?.packageName == packageName
    }

    private fun openNotificationPanel() {
        try {
            val statusBarService = getSystemService(Context.STATUS_BAR_SERVICE)
            val statusBarManager = Class.forName("android.app.StatusBarManager")
            val method = statusBarManager.getMethod("expandNotificationsPanel")
            method.invoke(statusBarService)
        } catch (e: Exception) {
            Log.e("LauncherApp", "Failed to open notification panel: ${e.message}")
        }
    }

    override fun onPause() {
        super.onPause()
        if (isFinishing) {
            Log.d("LauncherApp", "MainActivity is finishing, bringing launcher to foreground.")
            bringLauncherToForeground()
        }
    }

    private fun bringLauncherToForeground() {
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED)
        }
        startActivity(intent)
    }
}
