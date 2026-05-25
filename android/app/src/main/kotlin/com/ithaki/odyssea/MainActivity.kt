package com.ithaki.odyssea

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  private val channelName = "ithaki/config"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
      .setMethodCallHandler { call, result ->
        when (call.method) {
          "googleServerClientId" -> result.success(readOptionalStringResource("google_server_client_id"))
          else -> result.notImplemented()
        }
      }
  }

  private fun readOptionalStringResource(resourceName: String): String? {
    val resourceId = resources.getIdentifier(resourceName, "string", packageName)
    if (resourceId == 0) return null

    val value = getString(resourceId).trim()
    return if (value.isEmpty()) null else value
  }
}
