//
//  SecurityToolkitImpl.swift
//  Pods
//
//  Created by Tom Handcock on 24/06/2025.
//  Re-factored by Tom Handcock on 08/07/2025.
//

class SecurityToolkitImpl: SecurityToolkitApi {
    
    let debuggerChecker: DebuggerChecker
    let jailbreakChecker: JailbreakChecker
    let reverseEngineerChecker: ReverseEngineerChecker
    let simulatorChecker: SimulatorChecker
    
    init(debuggerChecker: DebuggerChecker, jailbreakChecker: JailbreakChecker, reverseEngineerChecker: ReverseEngineerChecker, simulatorChecker: SimulatorChecker) {
        self.debuggerChecker = debuggerChecker
        self.jailbreakChecker = jailbreakChecker
        self.reverseEngineerChecker = reverseEngineerChecker
        self.simulatorChecker = simulatorChecker
    }
    
    func isRooted() throws -> Bool {
        return jailbreakChecker.isJailBroken()
    }
    
    func isDebugged() throws -> Bool {
        return debuggerChecker.isDebugged()
    }
    
    func isReverseEngineered() throws -> Bool {
        return reverseEngineerChecker.isReverseEngineered()
    }
    
    func isLikelyEmulator() throws -> Bool {
        return simulatorChecker.isLikelySimulator()
    }
}
