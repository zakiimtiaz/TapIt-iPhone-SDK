Get the code:
=================
You can compile the TapIt! SDK directly into your app.  Clone this repository(see intructions below), then copy the ```/Lib``` and ```/TapItSDK``` folders into your Xcode project.

This project includes Reachability as a git submodule.  **Make sure you pull down the submodule when cloning:**
````
git clone --recursive https://github.com/tapit/TapIt-iPhone-SDK.git
````
-- or for older versions of git --
````
git clone https://github.com/tapit/TapIt-iPhone-SDK.git
git submodule init
git submodule update
````




libTapIt.a Build Instructions
=============================
Building your own static library is as easy as selecting a build target and hitting build. There are two targets to choose from:

* TapIt - builds the libTapIt.a static library, including Video Ad support and AdMob adaptors
* TapIt_without_extras - builds basic TapIt static library, excluding Video Ad support and AdMob adaptors