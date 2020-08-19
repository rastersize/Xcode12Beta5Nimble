#!/usr/bin/env bash

set -euo pipefail

# Configure dependendencies built using Carthage to our liking.
# 1. Create a temporary xcconfig file
xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
# 2. Delete the xcconfig file on exit
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT
# Xcode 12 Beta 3 and 4 duplicate arm64 slices (one for iphoneos and one for iphonesimulator)
# workaround. As a “fat” archive can’t have multiple slices for the same architecture.
# See https://github.com/Carthage/Carthage/issues/3019 for more info
#    IMPORTANT: This might very well break building/running in the simulator on an arm64 Mac (DTK).
#               Since the simulator on those Macs probably need the iphonesimulator arm64 slice.
#               The proper fix for this issue is likely to switch to XCFrameworks (not yet
#               supported in Carthage as of July 28th, 2020).
# Xcode 12 beta 3
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_12A8169g = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
# Xcode 12 beta 4
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_12A8179i = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
# Xcode 12 beta 5
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_12A8189h = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig
# End Xcode 12 beta 3 and 4 workaround.
# General optimization 
# Only build code for our oldest deployment target and allow the OS to enable newer features.
echo 'IPHONEOS_DEPLOYMENT_TARGET = 12.0' >> $xcconfig
# Only build 64 bit slices since our apps only support 64 bit devices (same as iOS 12+).
echo 'VALID_ARCHS = arm64 arm64e x86_64' >> $xcconfig
# 4. Publish the xcconfig file so Xcode picks it up.
export XCODE_XCCONFIG_FILE="$xcconfig"

# Invoke Carthage
carthage "$@"
