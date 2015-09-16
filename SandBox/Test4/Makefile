GCC=/Applications/Xcode.app/Contents/Developer/usr/bin/gcc
SDK=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.4.sdk
ARCH=armv7

SandBox : SandBox.c SandBox.entitlements
	$(GCC) -arch $(ARCH) -isysroot $(SDK) SandBox.c -o SandBox
	export CODESIGN_ALLOCATE=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate 
	codesign -fs "iPhone Developer: shuqin zhang (9HZPSEVE3Z)" --entitlements SandBox.entitlements SandBox