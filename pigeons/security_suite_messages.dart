import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: "flutter_security_suite",
    dartOut: "lib/src/engine/api/security_suite_api.g.dart",
    dartOptions: DartOptions(),
    kotlinOut:
        "android/src/main/kotlin/com/apadmi/flutter_security_suite/SecuritySuiteApi.g.kt",
    kotlinOptions: KotlinOptions(errorClassName: "FlutterSecuritySuiteError"),
    swiftOut: "ios/flutter_security_suite/Sources/flutter_security_suite/SecuritySuiteApi.g.swift",
    swiftOptions: SwiftOptions(errorClassName: "SecuritySuiteError"),
  ),
)
@HostApi()
abstract class SecuritySuiteApi {
  bool isRooted();

  bool isDebugged();

  bool isLikelyEmulator();

  bool isReverseEngineered();
}
