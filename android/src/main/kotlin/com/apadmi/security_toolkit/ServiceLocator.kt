package com.apadmi.security_toolkit

import SecurityToolkitApi
import android.content.Context
import android.view.inputmethod.InputMethodManager
import com.scottyab.rootbeer.RootBeer

object ServiceLocator {
    private fun getRootBeer(context: Context) = RootBeer(context)

    private fun getEmulatorChecker(context: Context): EmulatorChecker = EmulatorChecker(
        getInputMethodManager(context)
    )

    private fun getInputMethodManager(context: Context): InputMethodManager =
        context.getSystemService(InputMethodManager::class.java)

    fun getSecurityToolkit(context: Context): SecurityToolkitApi =
        SecurityToolkitImpl(context, getEmulatorChecker(context), getRootBeer(context))
}