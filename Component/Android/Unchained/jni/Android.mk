LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LS_CPP = $(subst $(1)/,,$(wildcard $(1)/$(2)/*.cpp))

LOCAL_MODULE         := Unchained
LOCAL_C_INCLUDES     := $(LOCAL_PATH)
LOCAL_SRC_FILES      := JNI.cpp                                                   \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained)                    \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Core)               \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Tools)              \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Storage)            \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Sensors)            \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Features)           \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Features/Internet)  \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Features/Bluetooth) \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Features/Camera)    \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Bluetooth)          \
                        $(call LS_CPP,$(LOCAL_PATH),Unchained/Camera)
LOCAL_CFLAGS           := -fPIC -fexceptions -Wmultichar -ffunction-sections -fdata-sections -std=c++98 -std=gnu++98 -fno-rtti
LOCAL_STATIC_LIBRARIES := boost_system boost_thread boost_filesystem
LOCAL_SHARED_LIBRARIES := gstreamer_android
LOCAL_LDLIBS           := -llog -landroid
LOCAL_LDFLAGS          := -shared -Wl -gc-sections

include $(BUILD_SHARED_LIBRARY)

$(call import-module, boost_1_53_0)

GSTREAMER_SDK_ROOT        := $(GSTREAMER_SDK_ROOT_ANDROID)
GSTREAMER_NDK_BUILD_PATH  := $(GSTREAMER_SDK_ROOT)/share/gst-android/ndk-build
GSTREAMER_PLUGINS         := coreelements videoconvert jpeg app
GSTREAMER_EXTRA_DEPS      := gstreamer-video-1.0

include $(GSTREAMER_NDK_BUILD_PATH)/gstreamer-1.0.mk
