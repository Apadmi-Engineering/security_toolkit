import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: "security_toolkit",
    dartOut: "lib/src/engine/api/security_toolkit_api.g.dart",
    dartOptions: DartOptions(),
    kotlinOut:
        "android/src/main/kotlin/com/apadmi/security_toolkit/SecurityToolkitApi.g.kt",
    kotlinOptions: KotlinOptions(errorClassName: "SecurityToolkitError"),
    swiftOut: "ios/security_toolkit/Sources/security_toolkit/SecurityToolkitApi.g.swift",
    swiftOptions: SwiftOptions(errorClassName: "SecurityToolkitError"),
  ),
)
@HostApi()
abstract class SecurityToolkitApi {
  bool isRooted();

  bool isDebugged();

  bool isLikelyEmulator();

  bool isReverseEngineered();
}
