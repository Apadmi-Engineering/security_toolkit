//
//  JailbreakChecker.swift
//  Pods
//
//  Created by Tom Handcock on 24/06/2025.
//
//  Based on checks described in https://github.com/securing/IOSSecuritySuite/tree/1.9.11
class JailbreakChecker {
    
    let simulatorChecker: SimulatorChecker
    
    init(simulatorChecker: SimulatorChecker) {
        self.simulatorChecker = simulatorChecker
    }
    
    private enum JailbreakCheckResult {
        case passed
        case failed(String)
    }
    
    func isJailBroken() -> Bool {
        if case .failed(let message) = checkURLSchemes() {
            return true
        }

        if case .failed = checkExistenceOfSuspiciousFiles() {
            return true
        }

        if case .failed = checkSuspiciousFilesCanBeOpened() {
            return true
        }

        if case .failed = checkRestrictedDirectoriesWriteable() {
            return true
        }

        if case .failed = checkFork() {
            return true
        }

        if case .failed = checkSymbolicLinks() {
            return true
        }

        if case .failed = checkSuspiciousObjCClasses() {
            return true
        }

        return false
    }
    
    private func checkURLSchemes() -> JailbreakCheckResult {
        for urlScheme in [
            "undecimus://",
            "sileo://",
            "zbra://",
            "filza://"
        ] {
            if let url = URL(string: urlScheme) {
                if UIApplication.shared.canOpenURL(url) {
                    return .failed("\(url) scheme detected")
                }
            }
        }
        return .passed
    }
    
    private func checkExistenceOfSuspiciousFiles() -> JailbreakCheckResult {
        var paths = [
            "/var/mobile/Library/Preferences/ABPattern", // A-Bypass
            "/usr/lib/ABDYLD.dylib", // A-Bypass,
            "/usr/lib/ABSubLoader.dylib", // A-Bypass
            "/usr/sbin/frida-server", // frida
            "/etc/apt/sources.list.d/electra.list", // electra
            "/etc/apt/sources.list.d/sileo.sources", // electra
            "/.bootstrapped_electra", // electra
            "/usr/lib/libjailbreak.dylib", // electra
            "/jb/lzma", // electra
            "/.cydia_no_stash", // unc0ver
            "/.installed_unc0ver", // unc0ver
            "/jb/offsets.plist", // unc0ver
            "/usr/share/jailbreak/injectme.plist", // unc0ver
            "/etc/apt/undecimus/undecimus.list", // unc0ver
            "/var/lib/dpkg/info/mobilesubstrate.md5sums", // unc0ver
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/jb/jailbreakd.plist", // unc0ver
            "/jb/amfid_payload.dylib", // unc0ver
            "/jb/libjailbreak.dylib", // unc0ver
            "/usr/libexec/cydia/firmware.sh",
            "/var/lib/cydia",
            "/etc/apt",
            "/private/var/lib/apt",
            "/private/var/Users/",
            "/var/log/apt",
            "/Applications/Cydia.app",
            "/private/var/stash",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/cache/apt/",
            "/private/var/log/syslog",
            "/private/var/tmp/cydia.log",
            "/Applications/Icy.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/blackra1n.app",
            "/Applications/SBSettings.app",
            "/Applications/FakeCarrier.app",
            "/Applications/WinterBoard.app",
            "/Applications/IntelliScreen.app",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/Library/MobileSubstrate/CydiaSubstrate.dylib",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/Applications/Sileo.app",
            "/var/binpack",
            "/Library/PreferenceBundles/LibertyPref.bundle",
            "/Library/PreferenceBundles/ShadowPreferences.bundle",
            "/Library/PreferenceBundles/ABypassPrefs.bundle",
            "/Library/PreferenceBundles/FlyJBPrefs.bundle",
            "/Library/PreferenceBundles/Cephei.bundle",
            "/Library/PreferenceBundles/SubstitutePrefs.bundle",
            "/Library/PreferenceBundles/libhbangprefs.bundle",
            "/usr/lib/libhooker.dylib",
            "/usr/lib/libsubstitute.dylib",
            "/usr/lib/substrate",
            "/usr/lib/TweakInject",
            "/var/binpack/Applications/loader.app", // checkra1n
            "/Applications/FlyJB.app", // Fly JB X
            "/Applications/Zebra.app", // Zebra
            "/Library/BawAppie/ABypass", // ABypass
            "/Library/MobileSubstrate/DynamicLibraries/SSLKillSwitch2.plist", // SSL Killswitch
            "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.plist", // PreferenceLoader
            "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.dylib", // PreferenceLoader
            "/Library/MobileSubstrate/DynamicLibraries", // DynamicLibraries directory in general
            "/var/mobile/Library/Preferences/me.jjolano.shadow.plist"
        ]

        // These files can give false positive in the emulator
        if !simulatorChecker.isLikelySimulator() {
            paths += [
                "/bin/bash",
                "/usr/sbin/sshd",
                "/usr/libexec/ssh-keysign",
                "/bin/sh",
                "/etc/ssh/sshd_config",
                "/usr/libexec/sftp-server",
                "/usr/bin/ssh"
            ]
        }

        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return .failed("Suspicious file detected: \(path)")
            } else if let result = checkExistenceOfSuspiciousFilesViaStat(path: path) {
                return result
            } else if let result = checkExistenceOfSuspiciousFilesViaFOpen(
                path: path,
                mode: .readable
            ) {
                return result
            } else if let result = checkExistenceOfSuspiciousFilesViaAccess(
                path: path,
                mode: .readable
            ) {
                return result
            }
        }

        return .passed
    }

    private func checkSuspiciousFilesCanBeOpened() -> JailbreakCheckResult {
        var paths = [
            "/.installed_unc0ver",
            "/.bootstrapped_electra",
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/etc/apt",
            "/var/log/apt"
        ]

        // These files can give false positive in the emulator
        if !simulatorChecker.isLikelySimulator() {
            paths += [
                "/bin/bash",
                "/usr/sbin/sshd",
                "/usr/bin/ssh"
            ]
        }

        for path in paths {
            if FileManager.default.isReadableFile(atPath: path) {
                return .failed("Suspicious file can be opened: \(path)")
            } else if let result = checkExistenceOfSuspiciousFilesViaFOpen(
                path: path,
                mode: .writable
            ) {
                return result
            } else if let result = checkExistenceOfSuspiciousFilesViaAccess(
                path: path,
                mode: .writable
            ) {
                return result
            }
        }

        return .passed
    }

    private func checkRestrictedDirectoriesWriteable() -> JailbreakCheckResult {
        let paths = [
            "/",
            "/root/",
            "/private/",
            "/jb/"
        ]

        if checkRestrictedPathIsReadonlyViaStatvfs(path: "/") == false {
            return .failed("Restricted path '/' is not Read-Only")
        } else if checkRestrictedPathIsReadonlyViaStatfs(path: "/") == false {
            return .failed("Restricted path '/' is not Read-Only")
        } else if checkRestrictedPathIsReadonlyViaGetfsstat(name: "/") == false {
            return .failed("Restricted path '/' is not Read-Only")
        }

        for path in paths {
            do {
                let pathWithSomeRandom = path + UUID().uuidString
                try "AmIJailbroken?".write(
                    toFile: pathWithSomeRandom,
                    atomically: true,
                    encoding: String.Encoding.utf8
                )
                // clean if succesfully written
                try FileManager.default.removeItem(atPath: pathWithSomeRandom)
                return .failed("Wrote to restricted path: \(path)")
            } catch { /* write failed - test passed */ }
        }

        return .passed
    }

    private func checkFork() -> JailbreakCheckResult {
        guard !simulatorChecker.isLikelySimulator() else { return .passed }

        let pointerToFork = UnsafeMutableRawPointer(bitPattern: -2)
        let forkPtr = dlsym(pointerToFork, "fork")
        typealias ForkType = @convention(c) () -> pid_t
        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
        let forkResult = fork()

        if forkResult >= 0 {
            if forkResult > 0 {
                kill(forkResult, SIGTERM)
            }
            return .failed("Fork was able to create a new process (sandbox violation)")
        }

        return .passed
    }

    private func checkSymbolicLinks() -> JailbreakCheckResult {
        let paths = [
            "/var/lib/undecimus/apt", // unc0ver
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/arm-apple-darwin9",
            "/usr/include",
            "/usr/libexec",
            "/usr/share"
        ]

        for path in paths {
            do {
                let result = try FileManager.default.destinationOfSymbolicLink(atPath: path)
                if !result.isEmpty {
                    return .failed("Non standard symbolic link detected: \(path) points to \(result)")
                }
            } catch {}
        }

        return .passed
    }
    
    private func checkSuspiciousObjCClasses() -> JailbreakCheckResult {
        if let shadowRulesetClass = objc_getClass("ShadowRuleset") as? NSObject.Type {
            let selector = Selector(("internalDictionary"))
            if class_getInstanceMethod(shadowRulesetClass, selector) != nil {
                return .failed("Shadow anti-anti-jailbreak detector detected :-)")
            }
        }
        return .passed
    }
    
    enum FileMode {
        case readable
        case writable
    }
    
    private func checkExistenceOfSuspiciousFilesViaStat(path: String) -> JailbreakCheckResult? {
        var statbuf = stat()
        let resultCode = stat((path as NSString).fileSystemRepresentation, &statbuf)

        if resultCode == 0 {
            return .failed("Suspicious file detected: \(path)")
        } else {
            return nil
        }
    }

    private func checkExistenceOfSuspiciousFilesViaFOpen(path: String,
                                                 mode: FileMode) -> JailbreakCheckResult? {
        // the 'a' or 'w' modes, create the file if it does not exist.
        let mode: String = FileMode.writable == mode ? "r+" : "r"

        if let filePointer: UnsafeMutablePointer<FILE> = fopen(path, mode) {
            fclose(filePointer)
            return .failed("Suspicious file detected: \(path)")
        } else {
            return nil
        }
    }

    private func checkExistenceOfSuspiciousFilesViaAccess(
        path: String,
        mode: FileMode
    ) -> JailbreakCheckResult? {
        let resultCode = access(
            (path as NSString).fileSystemRepresentation,
            FileMode.writable == mode ? W_OK : R_OK
        )

        if resultCode == 0 {
            return .failed("Suspicious file detected: \(path)")
        } else {
            return nil
        }
    }

    private func checkRestrictedPathIsReadonlyViaStatvfs(
        path: String,
        encoding: String.Encoding = .utf8
    ) -> Bool? {
        guard let path: [CChar] = path.cString(using: encoding) else {
            assertionFailure("Failed to create a cString with path=\(path) encoding=\(encoding)")
            return nil
        }

        var statBuffer = statvfs()
        let resultCode: Int32 = statvfs(path, &statBuffer)

        if resultCode == 0 {
            return Int32(statBuffer.f_flag) & ST_RDONLY != 0
        } else {
            return nil
        }
    }

    private func checkRestrictedPathIsReadonlyViaStatfs(
        path: String,
        encoding: String.Encoding = .utf8
    ) -> Bool? {
        getMountedVolumeInfoViaStatfs(path: path, encoding: encoding)?.isReadOnly
    }

    private func checkRestrictedPathIsReadonlyViaGetfsstat(name: String) -> Bool? {
        getMountedVolumesViaGetfsstat(withName: name)?.isReadOnly
    }

    private struct MountedVolumeInfo {
        let fileSystemName: String
        let directoryName: String
        let isRoot: Bool
        let isReadOnly: Bool
    }

    private func getMountedVolumeInfoViaStatfs(path: String,
                                               encoding: String.Encoding = .utf8) -> MountedVolumeInfo? {
        guard let path: [CChar] = path.cString(using: encoding) else {
            assertionFailure("Failed to create a cString with path=\(path) encoding=\(encoding)")
            return nil
        }

        var statBuffer = statfs()
        /**
         Upon successful completion, the value 0 is returned; otherwise the
         value -1 is returned and the global variable errno is set to indicate
         the error.
         */
        let resultCode: Int32 = statfs(path, &statBuffer)

        if resultCode == 0 {
            let mntFromName: String = withUnsafePointer(to: statBuffer.f_mntfromname) { ptr -> String in
                String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
            }
            let mntOnName: String = withUnsafePointer(to: statBuffer.f_mntonname) { ptr -> String in
                String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
            }

            return MountedVolumeInfo(fileSystemName: mntFromName,
                                     directoryName: mntOnName,
                                     isRoot: (Int32(statBuffer.f_flags) & MNT_ROOTFS) != 0,
                                     isReadOnly: (Int32(statBuffer.f_flags) & MNT_RDONLY) != 0)
        } else {
            return nil
        }
    }

    private func getMountedVolumesViaGetfsstat() -> [MountedVolumeInfo]? {
        // If buf is NULL, getfsstat() returns just the number of mounted file systems.
        let count: Int32 = getfsstat(nil, 0, MNT_NOWAIT)

        guard count >= 0 else {
            assertionFailure("getfsstat() failed to return the number of mounted file systems.")
            return nil
        }

        var statBuffer: [statfs] = .init(repeating: statfs(), count: Int(count))
        let size: Int = MemoryLayout<statfs>.size * statBuffer.count
        /**
         Upon successful completion, the number of statfs structures is
         returned. Otherwise, -1 is returned and the global variable errno is
         set to indicate the error.
         */
        let resultCode: Int32 = getfsstat(&statBuffer, Int32(size), MNT_NOWAIT)

        if resultCode > -1 {
            if count != resultCode {
                assertionFailure("Unexpected a resultCode=\(resultCode), was expecting=\(count).")
            }

            var result: [MountedVolumeInfo] = []

            for entry: statfs in statBuffer {
                let mntFromName: String = withUnsafePointer(to: entry.f_mntfromname) { ptr -> String in
                    String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
                }
                let mntOnName: String = withUnsafePointer(to: entry.f_mntonname) { ptr -> String in
                    String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
                }

                let info = MountedVolumeInfo(fileSystemName: mntFromName,
                                             directoryName: mntOnName,
                                             isRoot: (Int32(entry.f_flags) & MNT_ROOTFS) != 0,
                                             isReadOnly: (Int32(entry.f_flags) & MNT_RDONLY) != 0)
                result.append(info)
            }

            if count != result.count {
                assertionFailure("Unexpected filesystems count=\(result.count), was expecting=\(count).")
            }

            return result
        } else {
            assertionFailure(
                "getfsstat() failed. resultCode=\(resultCode), expected count=\(count) filesystems."
            )
            return nil
        }
    }

    private func getMountedVolumesViaGetfsstat(withName name: String) -> MountedVolumeInfo? {
        if let list = getMountedVolumesViaGetfsstat() {
            if list.count == 0 {
                assertionFailure("Expected to a non-empty list of mounted volumes.")
            } else {
                return list.first(where: { $0.directoryName == name || $0.fileSystemName == name })
            }
        } else {
            assertionFailure("Expected a non-nil list of mounted volumes.")
        }
        return nil
    }
}
