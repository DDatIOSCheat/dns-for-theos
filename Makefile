ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1
TARGET = iphone:clang:latest:12.1


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NextDNS
NextDNS_FILES = DNS.xm
include $(THEOS_MAKE_PATH)/tweak.mk
