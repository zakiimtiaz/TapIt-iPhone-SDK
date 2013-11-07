/**
 * TapitSdkPlugin.js
 *  
 * Phonegap TapitSdkPlugin Instance plugin
 * Copyright (c) 
 *
 */

// handle plugin intialization
var TapitSdkInitialize = {
intializeAd: function(types, success, fail) {
    PhoneGap.exec(success, fail, "TapitSdkHandler", "initalizePlugin", types);
}
};

// handle plugin show Ads banner
var TapitSdkShowBannerAd = {
callShowBannerAd: function(types, success, fail) {
    PhoneGap.exec(success, fail, "TapitSdkHandler", "showBannerAd", types);
}
};

// handle plugin close Ads banner
var TapitSdkHideBannerAd = {
callHideBannerAd: function(types, success, fail) {
    PhoneGap.exec(success, fail, "TapitSdkHandler", "hideBannerAd", types);
}
};

// handle plugin cause finger touch to wrap
var TapitSDKShowInterstitialAd = {
callShowInterstitialAd: function(types, success, fail) {
    PhoneGap.exec(success, fail, "TapitSdkHandler", "showInterstitialAd", types);
}
};

// handle plugin where they can start new bird
var TapitSdkPShowAlertAd = {
callShowAlertAdAsAlert: function(types, success, fail) {
    PhoneGap.exec(success, fail, "TapitSdkHandler", "showAlertAdAsAlert", types);
}
};

// handle plugin to show our working plugin api
var TapitSdkPShowPromptAd = {
callShowAlertAdAsPrompt: function(types, success, fail) {
    PhoneGap.exec(success, fail, "TapitSdkHandler", "showAlertAdAsPrompt", types);
}
};
