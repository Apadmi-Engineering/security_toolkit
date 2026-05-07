//
//  ServiceLocator.swift
//  Pods
//
//  Created by Tom Handcock on 24/06/2025.
//

class ServiceLocator {
    
    static let debuggerChecker: DebuggerChecker = DebuggerChecker()
    
    static let jailbreakChecker: JailbreakChecker = JailbreakChecker(simulatorChecker: simulatorChecker)
    
    static let reverseEngineerChecker: ReverseEngineerChecker = ReverseEngineerChecker()
    
    static let simulatorChecker: SimulatorChecker = SimulatorChecker()
    
    static func getSecuritySuiteApi() -> SecuritySuiteApi {
        return SecuritySuiteImpl(
            debuggerChecker: debuggerChecker,
            jailbreakChecker: jailbreakChecker,
            reverseEngineerChecker: reverseEngineerChecker,
            simulatorChecker: simulatorChecker
        )
    }
}
