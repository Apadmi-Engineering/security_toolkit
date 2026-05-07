package com.apadmi.flutter_security_suite

import SecuritySuiteApi
import android.content.Context
import android.content.pm.ApplicationInfo
import com.scottyab.rootbeer.RootBeer

class SecuritySuiteImpl(
    private val context: Context,
    private val emulatorChecker: EmulatorChecker,
    private val rootBeer: RootBeer,
): SecuritySuiteApi {
    override fun isRooted(): Boolean = rootBeer.isRooted

    override fun isDebugged(): Boolean = BuildConfig.DEBUG || context.applicationContext.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0

    override fun isLikelyEmulator(): Boolean = emulatorChecker.isLikelyEmulator()

    override fun isReverseEngineered(): Boolean = false
}