package com.apadmi.flutter_security_suite

import SecuritySuiteApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterSecuritySuitePlugin: FlutterPlugin {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val securityApi = ServiceLocator.getSecuritySuite(flutterPluginBinding.applicationContext)
    SecuritySuiteApi.setUp(flutterPluginBinding.binaryMessenger, securityApi)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    // Intentionally blank.
  }
}
