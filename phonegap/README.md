Tapit SDK Plugin for PhoneGap

Using this plugin requires iOS PhoneGap


1. Add below frame work to your project
- SystemConfiguration.framework
- QuartzCore.framework
- CoreTelephony.framework
- CoreLocation.framework

2. Follow steps below to configure Tapit Plugin

- add the -obj-C flag to 'Other Linker Flags' in 'Build Settngs'

- copy TapItSdk and Lib folder to your project

- add Plugin entry in Cordova.plist file under 'Plugins' tag
	TapitSkdHandler as key-value pair

- add TapitSdkHandler.m and TapitSdkHandler.h file to project under 'Plugins' folder

- add TapitSdkPlugin.js file to project under 'Js' folder

- add entry for the external hosts reachability in Cordova.plist file
	with value *

3. import Tapit plugin into index.html
	<script type="text/javascript" src="js/plugins/TapitSdkPlugin.js"></script>

4. Intialize TapitSdkPlugin with call to plugin initialize in onDeviceReady()

	TapitSdkInitialize.intializeAd([""],success,fail);

5. you can use below code to add buttons to call plugin functions
	<button id="btnId1" onclick="showBannerAdBtn()">Show Banner Ad</button>
    <button id="btnId2" onclick="hideBannerAdBtn()">Hide Banner Ad</button><br>
    <button id="btnId3" onclick="showInterstitialAdBtn()">Show Interstitial Ad</button><br>
    <button id="btnId4" onclick="showAlertAdAsAlertBtn()">Show Alert Ad as Alert</button>
    <button id="btnId5" onclick="showAlertAdAsPromptBtn()">Show Alert Ad as Prompt</button><br>

6. you can use below code to call plugin functions
- here '7527' is the zoned to be used with plugin
  
            // show Banner Ad
            function showBannerAdBtn()
            {
                TapitSdkShowBannerAd.callShowBannerAd(["7527"],success,fail);
            }
            // hide Banner Ad
            function hideBannerAdBtn()
            {
                TapitSdkHideBannerAd.callHideBannerAd([""],success,fail);
            }
            // show Interstiatial Ad
            function showInterstitialAdBtn()
            {
                TapitSDKShowInterstitialAd.callShowInterstitialAd(["7527"],success,fail);
            }
            // show Alert Ad as Alert
            function showAlertAdAsAlertBtn()
            {
                TapitSdkPShowAlertAd.callShowAlertAdAsAlert(["7527"],success,fail);
            }
            // show Alert Ad as Prompt
            function showAlertAdAsPromptBtn()
            {
                TapitSdkPShowPromptAd.callShowAlertAdAsPrompt(["7527"],success,fail);
            }
            
            function success(obj){
                alert("Success: "+obj);
            }
            
            function fail(errors){
                alert("Error: "+errors);
            }





