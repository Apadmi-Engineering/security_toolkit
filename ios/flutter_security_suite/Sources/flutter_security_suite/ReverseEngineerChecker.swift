//
//  ReverseEngineerChecker.swift
//  Pods
//
//  Created by Tom Handcock on 24/06/2025.
//

class ReverseEngineerChecker {
    
    private enum ReverseEngineerCheckResult {
        case passed
        case failed(String)
    }
    
    func isReverseEngineered() -> Bool {
        if case .failed = checkOpenedPorts() {
            return true
        }

        if case .failed = checkPSelectFlag() {
            return true
        }

        return false
    }
    
    private func checkOpenedPorts() -> ReverseEngineerCheckResult {
        let ports = [
            27042, // default Frida
            4444, // default Needle
            22, // OpenSSH
            44 // checkra1n
        ]

        for port in ports where canOpenLocalConnection(port: port) {
            return .failed("Port \(port) is open")
        }

        return .passed
    }
    
    // EXPERIMENTAL
    private func checkPSelectFlag() -> ReverseEngineerCheckResult {
        var kinfo = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let sysctlRet = sysctl(&mib, UInt32(mib.count), &kinfo, &size, nil, 0)

        if (kinfo.kp_proc.p_flag & P_SELECT) != 0 {
            return .failed("Suspicious PFlag value")
        }

        return .passed
    }
    
    private func canOpenLocalConnection(port: Int) -> Bool {
        func swapBytesIfNeeded(port: in_port_t) -> in_port_t {
            let littleEndian = Int(OSHostByteOrder()) == OSLittleEndian
            return littleEndian ? _OSSwapInt16(port) : port
        }

        var serverAddress = sockaddr_in()
        serverAddress.sin_family = sa_family_t(AF_INET)
        serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1")
        serverAddress.sin_port = swapBytesIfNeeded(port: in_port_t(port))
        let sock = socket(AF_INET, SOCK_STREAM, 0)

        let result = withUnsafePointer(to: &serverAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
            }
        }

        defer {
            close(sock)
        }

        if result != -1 {
            return true // Port is opened
        }

        return false
    }
}
