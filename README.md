# Security Toolkit

> [!IMPORTANT]
> Whilst this plugin is open-source, and you are free to use according to the license, this is
> primarily a convenience for internal Apadmi projects. Our priorities responding to issues 
> raised by others reflects this so please use your own discretion when opting 
> to depend on this plugin.

A Flutter plugin that performs static runtime checks on Android and iOS apps to indicate an
insecure environment.

## Features

| Feature                            | Android | iOS |
|------------------------------------|---------|-----|
| Emulator/Simulator detection       | ✅       | ✅   |
| Debugging detection                | ✅       | ✅   |
| Root/jailbreak detection           | ✅       | ✅   |
| Reverse engineer attempt detection |         | ✅   |

## Getting started

Usage of this plugin has the following requirements:

* Minimum Android SDK: 23
* Minimum iOS version: 12.0

## Usage

A single class, `SecurityToolkit`, is exposed which has a number of static methods to perform the
checks listed above. That said, most of the time you'll simply want to use
`SecurityToolkit.checkSecureEnvironment()` for a single, comprehensive check.

## Considerations

This plugin uses static checks at runtime against environment variables and the file system to
detect tooling which _may_ imply an insecure environment. These checks are best thought of as a
'simple defense' as they can easily be bypassed by tooling that allows for memory injection such
as Frida and AndBug.

Conversely, these checks may result in false-positives for legitimate users of your app.

If you are working on a sensitive app or otherwise higher security requirements than standard, it
is highly recommended you research other solutions for runtime security such as the
[Google Play Intergity API](https://developer.android.com/google/play/integrity/overview), [Apple App Attestion API](https://developer.apple.com/documentation/devicecheck/establishing-your-app-s-integrity),
or premium offerings.