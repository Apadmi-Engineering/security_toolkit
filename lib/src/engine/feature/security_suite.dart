import 'package:flutter/foundation.dart';
import 'package:flutter_security_suite/src/engine/api/security_suite_api.g.dart';
import 'package:flutter_security_suite/src/engine/feature/security_suite_models.dart';

abstract class SecuritySuite {
  static final _api = SecuritySuiteApi();

  /// Answers [true] if the app is running on a rooted or jail-broken device.
  static Future<bool> isRooted() => _api.isRooted();

  /// Answers [true] if this is a debuggable binary
  static Future<bool> isDebugged() async {
    if (kDebugMode || kProfileMode) {
      return true;
    }
    final nativeResult = await _api.isDebugged();
    return nativeResult;
  }

  /// Answers [true] if the app is running on an emulator or other virtual
  /// device.
  static Future<bool> isLikelyEmulator() => _api.isLikelyEmulator();

  /// Performs checks to determine if tools are being used to actively reverse
  /// engineer the app. Only available on iOS, Android will always return
  /// [false].
  static Future<bool> isReverseEngineered() => _api.isReverseEngineered();

  /// Performs all available security checks and answers with the results.
  static Future<SecurityCheckResult> checkSecureEnvironment() async {
    final [
      rootResult,
      debugResult,
      reverseEngineerResult,
      emulatorResult,
    ] = await Future.wait({
      isRooted(),
      isDebugged(),
      isReverseEngineered(),
      isLikelyEmulator(),
    });
    return SecurityCheckResult({
      if (rootResult) SecurityViolation.rooted,
      if (debugResult) SecurityViolation.debugged,
      if (reverseEngineerResult) SecurityViolation.reverseEngineered,
      if (emulatorResult) SecurityViolation.emulator,
    });
  }
}
