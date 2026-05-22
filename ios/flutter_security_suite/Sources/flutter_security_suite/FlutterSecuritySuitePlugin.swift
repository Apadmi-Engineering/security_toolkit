import Flutter
import UIKit

public class FlutterSecuritySuitePlugin: NSObject, FlutterPlugin {
    
    let securitySuite: SecuritySuiteApi
    
    override init() {
        self.securitySuite = ServiceLocator.getSecuritySuiteApi()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = FlutterSecuritySuitePlugin()
        let securitySuite = plugin.securitySuite
        SecuritySuiteApiSetup.setUp(binaryMessenger: registrar.messenger(), api: securitySuite)
        registrar.publish(plugin)
    }
}
