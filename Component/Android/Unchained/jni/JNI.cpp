#include <jni.h>
#include <android/log.h>

#include <Unchained/Unchained.h>
#include <assert.h>

#define UNCHAINED_RESOURCES     "com/studio/artaban/Unchained/Resources"


//
jclass resClass = NULL;
jobject resObject = NULL;

jbyte* camBuffer = NULL;
jsize camBufferLen = 0;

//////
JavaVM* javaVM = NULL;

jint JNI_OnLoad(JavaVM* pVM, void* reserved) {

    javaVM = pVM;
    return JNI_VERSION_1_6;
}

#ifdef __cplusplus
extern "C" {
#endif
    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_init(JNIEnv* env, jobject obj, jobject view, jfloat xDpi, jfloat yDpi);
    JNIEXPORT jstring Java_com_studio_artaban_Unchained_Core_key(JNIEnv* env, jobject obj);
    JNIEXPORT jboolean Java_com_studio_artaban_Unchained_Core_ready(JNIEnv* env, jobject obj);
    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_permission(JNIEnv* env, jobject obj, jshort allowed);
    JNIEXPORT jshort Java_com_studio_artaban_Unchained_Core_reset(JNIEnv* env, jobject obj, jstring url);
    // Core

    JNIEXPORT jshort Java_com_studio_artaban_Unchained_Core_start(JNIEnv* env, jobject obj, jstring url, jstring version);
    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_pause(JNIEnv* env, jobject obj, jboolean finishing,
            jboolean lockScreen);
    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_stop(JNIEnv* env, jobject obj);
    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_destroy(JNIEnv* env, jobject obj);
    // Activity

    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_accel(JNIEnv* env, jobject obj, jfloat x,
            jfloat y, jfloat z);
    // Sensor

    JNIEXPORT void Java_com_studio_artaban_Unchained_Core_camera(JNIEnv* env, jobject obj, jbyteArray data);
    // Camera

#ifdef __cplusplus
};
#endif

JNIEXPORT void Java_com_studio_artaban_Unchained_Core_init(JNIEnv* env, jobject obj, jobject res, jfloat xDpi, jfloat yDpi) {

    resClass = static_cast<jclass>(env->NewGlobalRef(env->FindClass(UNCHAINED_RESOURCES)));
    if (!resClass)
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "Failed to find resources class: %s", UNCHAINED_RESOURCES);

    resObject = env->NewGlobalRef(res);
    if (!resObject)
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "Failed to get resources object");

    PlatformData platformData;
    platformData.jvm = javaVM;
    platformData.cls = resClass;
    platformData.res = resObject;
    platformData.xDpi = static_cast<float>(xDpi);
    platformData.yDpi = static_cast<float>(yDpi);

    unchainedInit(&platformData);
}
JNIEXPORT jstring Java_com_studio_artaban_Unchained_Core_key(JNIEnv* env, jobject obj) {
    return env->NewStringUTF(unchainedKey());
}
JNIEXPORT jboolean Java_com_studio_artaban_Unchained_Core_ready(JNIEnv* env, jobject obj) {
    return static_cast<short>(unchainedReady());
}
JNIEXPORT void Java_com_studio_artaban_Unchained_Core_permission(JNIEnv* env, jobject obj, jshort allowed) {
    unchainedPermission(static_cast<short>(allowed));
}
JNIEXPORT jshort Java_com_studio_artaban_Unchained_Core_reset(JNIEnv* env, jobject obj, jstring url) {

    if (!url) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "reset: Empty URL address (null)");
        return static_cast<short>(ERR_ID_EMPTY_URL);
    }
    const char* lpURL = env->GetStringUTFChars(url, 0);
    std::string strURL(lpURL);
    if (!strURL.length()) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "reset: Empty URL address");
        return static_cast<short>(ERR_ID_EMPTY_URL);
    }
    env->ReleaseStringUTFChars(url, lpURL);
    return static_cast<jshort>(unchainedReset(strURL));
}

JNIEXPORT jshort Java_com_studio_artaban_Unchained_Core_start(JNIEnv* env, jobject obj, jstring url, jstring version) {

    if (!url) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "start: Empty URL address (null)");
        return static_cast<short>(ERR_ID_EMPTY_URL);
    }
    const char* lpTmp = env->GetStringUTFChars(url, 0);
    std::string strURL(lpTmp);
    if (!strURL.length()) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "start: Empty URL address");
        return static_cast<short>(ERR_ID_EMPTY_URL);
    }
    env->ReleaseStringUTFChars(url, lpTmp);
    if (!version) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "start: Empty JS Unchained version (null)");
        return static_cast<short>(ERR_ID_EMPTY_VERSION);
    }
    lpTmp = env->GetStringUTFChars(version, 0);
    std::string strVersion(lpTmp);
    if (!strVersion.length()) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "start: Empty JS Unchained version");
        return static_cast<short>(ERR_ID_EMPTY_VERSION);
    }
    env->ReleaseStringUTFChars(version, lpTmp);
    return static_cast<jshort>(unchainedStart(strURL, strVersion));
}
JNIEXPORT void Java_com_studio_artaban_Unchained_Core_pause(JNIEnv* env, jobject obj, jboolean finishing,
        jboolean lockScreen) {

    if ((!static_cast<bool>(finishing)) && (camBuffer)) {

        delete [] camBuffer;
        camBuffer = NULL;
    }
    unchainedPause(static_cast<bool>(finishing), static_cast<bool>(lockScreen));
}
JNIEXPORT void Java_com_studio_artaban_Unchained_Core_stop(JNIEnv* env, jobject obj) { unchainedStop(); }
JNIEXPORT void Java_com_studio_artaban_Unchained_Core_destroy(JNIEnv* env, jobject obj) {

    unchainedDestroy();
    if (camBuffer)
        delete [] camBuffer;

    if (resClass) env->DeleteGlobalRef(resClass);
    if (resObject) env->DeleteGlobalRef(resObject);
}

JNIEXPORT void Java_com_studio_artaban_Unchained_Core_accel(JNIEnv* env, jobject obj, jfloat x, jfloat y, jfloat z) {
    unchainedAccel(static_cast<float>(x), static_cast<float>(y), static_cast<float>(z));
}

JNIEXPORT void Java_com_studio_artaban_Unchained_Core_camera(JNIEnv* env, jobject obj, jbyteArray data) {

    if (!data) {
        __android_log_print(ANDROID_LOG_ERROR, "JNI", "Camera: NULL buffer");
        return;
    }
    jsize len = env->GetArrayLength(data);
    if (!camBuffer) {

        try {
            __android_log_print(ANDROID_LOG_INFO, "JNI", "Camera (len:%d)", len);
            camBufferLen = len;
            camBuffer = new jbyte[len];
        }
        catch (const std::bad_alloc &e) {
            __android_log_print(ANDROID_LOG_ERROR, "JNI", "loadCamera: %s", e.what());
            return;
        }
    }
    assert(camBufferLen == len);
    env->GetByteArrayRegion(data, 0, len, camBuffer);
    unchainedCamera(reinterpret_cast<const unsigned char*>(camBuffer));
}
