#! /bin/bash

# WARNING - This script doesn't really work, it's still in the exeperimental phase... You probably shouldn't run me!

# for this script to work, you need to install "Command Line Tools (OS X Mountain Lion) for Xcode - August 2012" from here: https://developer.apple.com/downloads/index.action?name=Xcode#

# You may have to update these paths...
CURR_XCODE_PATH=`xcode-select -print-path`
XCODE_44_PATH='/Applications/Xcode.app/Contents/Developer'

TAPIT_PATH='~/git/TapIt-iPhone-SDK'
TAPIT_PROJECT='${TAPIT_PATH}/TapIt-iOS-Sample.xcodeproj/'

xcodebuild -target TapIt -project $TAPIT_PROJECT

# switch to older xcode instance to build armv6 slice
sudo xcode-select --switch $XCODE_44_PATH

#TODO get this line working...
# for now, you have to compile "TapIt-armv6 > iPhone 5.0 Simulator" from the 4.4 UI
xcodebuild -target TapIt-armv6 -project $TAPIT_PROJECT

# back to current xcode version to lipo
sudo xcode-select --switch $CURR_XCODE_PATH

CUR_LIB='${TAPIT_PATH}/Build/Products/Release-universal/libTapIt.a'
ARMV6_LIB='${TAPIT_PATH}/Build/Products/Release-iphoneos/libTapIt_armv6.a'

lipo -create CUR_LIB ARMV6_LIB -output libTapit.a
