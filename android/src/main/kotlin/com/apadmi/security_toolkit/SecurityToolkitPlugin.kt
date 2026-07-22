package com.apadmi.security_toolkit

import SecurityToolkitApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SecurityToolkitPlugin: FlutterPlugin {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val securityApi = ServiceLocator.getSecurityToolkit(flutterPluginBinding.applicationContext)
    SecurityToolkitApi.setUp(flutterPluginBinding.binaryMessenger, securityApi)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    // Intentionally blank.
  }
}
