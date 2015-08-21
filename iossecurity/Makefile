include theos/makefiles/common.mk

TWEAK_NAME = iossecurity
iossecurity_FILES = Tweak.xm

iossecurity_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
