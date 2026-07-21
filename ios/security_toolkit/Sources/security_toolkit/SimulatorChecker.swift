//
//  SimulatorChecker.swift
//  Pods
//
//  Created by Tom Handcock on 24/06/2025.
//
import Foundation

class SimulatorChecker {
    
    static private let simulatorNameKey = "SIMULATOR_DEVICE_NAME"
    
    func isLikelySimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return ProcessInfo.processInfo.environment[SimulatorChecker.simulatorNameKey] != nil
#endif
    }
}
