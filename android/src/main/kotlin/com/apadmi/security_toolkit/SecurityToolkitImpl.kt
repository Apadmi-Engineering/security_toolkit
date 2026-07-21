package com.apadmi.security_toolkit

import SecurityToolkitApi
import android.content.Context
import android.content.pm.ApplicationInfo
import com.scottyab.rootbeer.RootBeer

class SecurityToolkitImpl(
    private val context: Context,
    private val emulatorChecker: EmulatorChecker,
    private val rootBeer: RootBeer,
): SecurityToolkitApi {
    override fun isRooted(): Boolean = rootBeer.isRooted

    override fun isDebugged(): Boolean = BuildConfig.DEBUG || context.applicationContext.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0

    override fun isLikelyEmulator(): Boolean = emulatorChecker.isLikelyEmulator()

    // Intentional - Not implemented on Android
    override fun isReverseEngineered(): Boolean = false
}