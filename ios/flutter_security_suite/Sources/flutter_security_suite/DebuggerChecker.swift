//
//  DebuggerChecker.swift
//  Pods
//
//  Created by Tom Handcock on 24/06/2025.
//

class DebuggerChecker {
    func isDebugged() -> Bool {
        var kinfo = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let sysctlRet = sysctl(&mib, UInt32(mib.count), &kinfo, &size, nil, 0)

        return (kinfo.kp_proc.p_flag & P_TRACED) != 0
    }
}
