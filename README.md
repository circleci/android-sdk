# android-sdk
Docker image for building Android projects

This is a base image for building and testing Android images. It contains the latest Android SDK and a non-root user named `android` with a password of `android`

The emulator must be called with `$ANDROID_HOME/tools/emulator` due to strange path issues that will throw errors, or use older option sets.

## Changes

## 1.2.x

* Using Ubuntu 16.04 for base

## 1.1.x

* $ANDROID_SDK_ROOT => $ANDROID_HOME
* User `android` now has a password of `android` and can use `sudo`
