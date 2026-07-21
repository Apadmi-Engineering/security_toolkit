package com.apadmi.security_toolkit

import android.os.Build
import android.view.inputmethod.InputMethodManager

class EmulatorChecker(
    private val inputMethodManager: InputMethodManager
) {
    /* Utilities */
    private fun manufacturerIs(predicate: String, ignoreCase: Boolean = false) =
        Build.MANUFACTURER.equals(predicate, ignoreCase = ignoreCase)

    private fun manufacturerContains(predicate: String) = Build.MANUFACTURER.contains(predicate)

    private fun brandIs(predicate: String) = Build.BRAND == predicate

    private fun brandPrefixIs(predicate: String) = Build.BRAND.startsWith(predicate)

    private fun fingerprintPrefixIs(predicate: String) = Build.FINGERPRINT.startsWith(predicate)

    private fun fingerprintSuffixIs(predicate: String) = Build.FINGERPRINT.endsWith(predicate)

    private fun productPrefixIs(predicate: String) = Build.PRODUCT.startsWith(predicate)

    private fun productIs(predicate: String, ignoreCase: Boolean = false) =
        Build.PRODUCT.equals(predicate, ignoreCase = ignoreCase)

    private fun modelIs(predicate: String) = Build.MODEL == predicate

    private fun modelPrefixIs(predicate: String) = Build.MODEL.startsWith(predicate)

    private fun modelContains(predicate: String) = Build.MODEL.contains(predicate)

    private fun boardIs(predicate: String) = Build.BOARD == predicate

    private fun hostPrefixIs(predicate: String) = Build.HOST.startsWith(predicate)

    private fun devicePrefixIs(predicate: String) = Build.DEVICE.startsWith(predicate)

    private fun deviceIs(predicate: String) = Build.DEVICE == predicate

    private fun hardwareIs(predicate: String, ignoreCase: Boolean = false) =
        Build.HARDWARE.equals(predicate, ignoreCase = ignoreCase)

    private fun keyboardContains(predicate: String): Boolean {
        val inputList =
            inputMethodManager.enabledInputMethodList.takeIf { it.isNotEmpty() } ?: return false
        val inputNames = inputList.map { it.packageName.lowercase() }
        val inputIds = inputList.map { it.id.lowercase() }
        val searchString = predicate.lowercase()
        return inputNames.any { it.contains(searchString) } || inputIds.any {
            it.contains(
                searchString
            )
        }
    }

    private fun allOf(vararg predicates: Boolean): Boolean = predicates.all { it }

    private fun anyOf(vararg predicates: Boolean): Boolean = predicates.any { it }

    /* Specific emulator detection */
    private fun isAndroidSdkEmulator(): Boolean = allOf(
        manufacturerIs("Google"),
        brandIs("google"),
        anyOf(
            allOf(
                fingerprintPrefixIs("google/sdk_gphone_"),
                fingerprintSuffixIs(":user/release-keys"),
                productPrefixIs("sdk_gphone_"),
                modelPrefixIs("sdk_gphone_")
            ),
            allOf(
                fingerprintPrefixIs("google/sdk_gphone64_"),
                anyOf(
                    fingerprintSuffixIs(":userdebug/dev-keys"),
                    fingerprintSuffixIs(":user/release-keys")
                ),
                productPrefixIs("sdk_gphone64_"),
                modelPrefixIs("sdk_gphone64_")
            ),
            hardwareIs("goldfish"),
            allOf(
                modelIs("HPE device"),
                fingerprintPrefixIs("google/kiwi_"),
                fingerprintSuffixIs(":user/release-keys"),
                boardIs("kiwi"),
                productPrefixIs("kiwi_")
            )
        )
    )

    private fun isAndy(): Boolean = anyOf(
        brandIs("AndyOS"),
        deviceIs("AndyWin"),
        hardwareIs("andy"),
        manufacturerIs("Andy OS Inc"),
        modelIs("AndyWin"),
        productIs("AndyWin")
    )

    private fun isBlissOs(): Boolean = anyOf(
        hostPrefixIs("bliss-host"),
        deviceIs("bliss_x86_64"),
        manufacturerIs("Bliss"),
        modelIs("Bliss-Device"),
        productIs("bliss_x86_64")
    )

    private fun isBluestacks(): Boolean = anyOf(
        boardIs("bst_x86"),
        brandIs("BlueStacks"),
        manufacturerIs("BlueStacks"),
        allOf(
            boardIs("QC_Reference_Phone"),
            !manufacturerIs("Xiaomi", ignoreCase = true)
        )
    )

    private fun isGeneric(): Boolean = anyOf(
        deviceIs("generic"),
        fingerprintPrefixIs("generic"),
        fingerprintPrefixIs("unknown"),
        modelContains("google_sdk"),
        modelContains("Emulator"),
        modelContains("Android SDK built for x86"),
        hardwareIs("ranchu"),
        hostPrefixIs("Build"),
        productIs("sdk"),
        productIs("sdk_google"),
        productIs("google_sdk"),
        productIs("sdk_x86"),
        productIs("simulator")
    )

    private fun isGenymotion(): Boolean = anyOf(
        brandPrefixIs("generic"),
        manufacturerContains("Genymotion"),
        productIs("vbox86p"),
        hardwareIs("vbox86")
    )

    private fun isLdPlayer(): Boolean = anyOf(
        modelIs("LDPlayer"),
    )

    private fun isMemuPlayer(): Boolean = anyOf(
        keyboardContains("memuime")
    )

    private fun isMuMuPlayer(): Boolean = anyOf(
        boardIs("mumu_x86"),
        brandIs("mumu"),
        hostPrefixIs("mumu-build"),
        deviceIs("mumu_x86"),
        hardwareIs("mumu"),
        manufacturerIs("NetEase"),
        modelIs("MuMu"),
        productIs("mumu_x86")
    )

    private fun isMsiAppPlayer(): Boolean = anyOf(
        allOf(
            brandPrefixIs("generic"),
            devicePrefixIs("generic")
        ),
        productIs("google_sdk")
    )

    private fun isNox(): Boolean = anyOf(
        hardwareIs("nox", ignoreCase = true),
        productIs("nox", ignoreCase = true),
        boardIs("nox")
    )

    private fun isWaydroid(): Boolean = anyOf(
        hostPrefixIs("waydroid"),
        deviceIs("raven"),
        hardwareIs("raven")
    )

    private fun isVisualStudio(): Boolean = anyOf(
        manufacturerContains("VS Emulator")
    )

    /* Public API */
    fun isLikelyEmulator(): Boolean = anyOf(
        isAndroidSdkEmulator(),
        isAndy(),
        isBlissOs(),
        isBluestacks(),
        isGeneric(),
        isGenymotion(),
        isLdPlayer(),
        isMemuPlayer(),
        isMemuPlayer(),
        isMuMuPlayer(),
        isMsiAppPlayer(),
        isNox(),
        isWaydroid(),
        isVisualStudio(),
    )
}