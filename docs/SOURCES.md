# Sources

The emulator detection and jailbreak detection on iOS are essentially 
comprised of checking for suspicious patterns in build constants and the 
existence of files in certain paths. These checks are always evolving as new 
emulators/jailbreaks become available.

The following is a list of sources that were used for these suspicions checks:

# Android root detection

* https://github.com/scottyab/rootbeer

# Android emulator detection

* https://www.cryptomathic.com/blog/securing-mobile-banking-apps-in-2025-stay-ahead-of-emulator-attacks
* https://koreascience.or.kr/article/JAKO201533678768383.pdf
* https://github.com/AndroidDeveloperLB/CommonUtils/blob/main/library/src/main/java/com/lb/common_utils/SystemUtils.kt
* https://github.com/react-native-device-info/react-native-device-info
* https://github.com/xamarin/Essentials

# iOS jailbreak detection

* https://github.com/securing/IOSSecuritySuite/tree/1.9.11