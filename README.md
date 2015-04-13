# com.phonegap.adobe-creative-sdk-foundation

PhoneGap Plugin for the Adobe Creative SDK Foundation

## Pre-Installation

1. Download the [`Adobe Creative SDK`](https://creativesdk.adobe.com/downloads.html), and unzip the file.
2. Copy the file `AdobeCreativeSDKFoundation.framework` into the `src/ios` folder of the plugin

## Installation (locally)

    cordova plugin add /path/to/plugin-folder
    
## Post-Installation

1. Locate the `PGAdobeCreativeSDKFoundation.m file` in your project
2. Edit the `ADOBE_CSDK_CLIENT_ID` value at the top of the file with your app's client id.
2. Edit the `ADOBE_CSDK_CLIENT_SECRET` value at the top of the file with your app's client secret.

You can obtain your app's client id and secret from registering your app at https://creativesdk.adobe.com/
    
## Usage

See [docs](www/adobe-creative-sdk-foundation.js)

```
function generalFailure(errorMessage) {
    console.log(errorMessage);
};

function downloadSuccess(obj) {
    if (obj.metadata) {
        console.log("Metadata for file (" + obj.href + "): "  + JSON.stringify(obj.metadata));
    } else if (obj.fractionCompleted) {
        console.log("Progress for file (" + obj.href + "): "  + obj.fractionCompleted);
    } else if (obj.result) {
        console.log("Result for file (" + obj.href + ") (" + (obj.cached? "cached" : "not cached") + "): "  + obj.result);
        // Add this tag to your page: <img src="" id="cloud-image" />
        document.getElementById("cloud-image").src = obj.result;
    }
};

function metadataSuccess(metadata) {
    console.log("Got metadata: " + JSON.stringify(metadata));
    
    // cascade into downloadFiles call
    AdobeCreativeSDKFoundation.downloadFiles(downloadSuccess, generalFailure);
};

function loginSuccess(adobeAuthUserProfile) {
    console.log("Logged in.");
    console.log("adobeID: " + adobeAuthUserProfile.adobeID + "\n" +
                "displayName: " + adobeAuthUserProfile.displayName + "\n" +
                "firstName: " + adobeAuthUserProfile.firstName + "\n" +
                "lastName: " + adobeAuthUserProfile.lastName + "\n" +
                "email: " + adobeAuthUserProfile.email + "\n"
                );
    
    // cascade into getFileMetadata call
    AdobeCreativeSDKFoundation.getFileMetadata(metadataSuccess, generalFailure);
};


AdobeCreativeSDKFoundation.login(loginSuccess, generalFailure);
// AdobeCreativeSDKFoundation.logout(function() {}, function(errorMessage) {});
```
