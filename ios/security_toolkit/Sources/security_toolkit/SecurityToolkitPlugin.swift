import Flutter
import UIKit

public class SecurityToolkitPlugin: NSObject, FlutterPlugin {
    
    let securityToolkit: SecurityToolkitApi
    
    override init() {
        self.securityToolkit = ServiceLocator.getSecurityToolkitApi()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = SecurityToolkitPlugin()
        let securityToolkit = plugin.securityToolkit
        SecurityToolkitApiSetup.setUp(binaryMessenger: registrar.messenger(), api: securityToolkit)
        registrar.publish(plugin)
    }
}
