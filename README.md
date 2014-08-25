# com.phonegap.adobe-creative-sdk-foundation

PhoneGap Plugin for the Adobe Creative SDK Foundation

## Pre-Installation

1. Download the Adobe Creative SDK, and unzip the file.
2. Copy the file "AdobeCreativeSDKFoundation.framework" into the src/ios folder

## Installation (locally)

    cordova plugin add /path/to/plugin-folder

## Installation (Plugin Registry)

    cordova plugin add com.phonegap.adobe-creative-sdk-foundation
    
    
## Usage

function loginSuccess(adobeAuthUserProfile) {
    console.log("Logged in.");
    console.log(
        "adobeID: " + adobeAuthUserProfile.adobeID + "\n"
        "displayName: " + adobeAuthUserProfile.displayName + "\n"
        "firstName: " + adobeAuthUserProfile.firstName + "\n"
        "lastName: " + adobeAuthUserProfile.lastName + "\n"
        "email: " + adobeAuthUserProfile.email + "\n"
    );
};

function loginFailure(errorMessage) {
    console.log(errorMessage);
};

AdobeCreativeSDKFoundation.login(loginSuccess, loginFailure);    
// AdobeCreativeSDKFoundation.logout(function() {}, function(errorMessage) {});    
