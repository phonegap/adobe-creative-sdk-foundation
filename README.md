# com.phonegap.adobe-creative-sdk

PhoneGap Plugin for the Adobe Creative SDK

## Pre-Installation

Unzip **src/ios/AdobeCreateFramework.zip** into the same directory, Github has a 100MB file limit so it couldn't be checked in as is.

## Installation (locally)

    cordova plugin add /path/to/plugin-folder

## Installation (Plugin Registry)

    cordova plugin add com.phonegap.adobe-creative-sdk


## Build Settings

If you need to run this in a 32-bit iPhone Simulator, you need to add this in your "Build Settings -> Other Linker Flags"
        
		-stdlib=libc++
