//
//  libGST.cpp
//  libGST
//
//  Created by Pascal Viguié on 02/02/2015.
//
//

#include <stdio.h>
#include "gst_osx_init.h"

#include <gst/gst.h>
#include <gst/app/gstappsrc.h>
#include <gst/app/gstappsink.h>

#include <boost/thread.hpp>
#include "defLibGST.h"


void updateFrame(GstBuffer* jpeg, LIBGST_CONVERT_INFO* info) {

    info->mutex->lock();
    if (!*info->dest) {

        *info->dest = new char[info->max];
        std::memset(*info->dest, 0, info->max);
    }
    *info->len = gst_buffer_extract(jpeg, 0, *info->dest, gst_buffer_get_size(jpeg));
    info->mutex->unlock();
}

typedef struct {

    LIBGST_CONVERT_INFO* info;
    GMainLoop* loop;
    
} userData;
void eos(GstAppSink* sink, gpointer data) { g_main_loop_quit(static_cast<userData*>(data)->loop); }
GstFlowReturn newPreroll(GstAppSink *appsink, gpointer data) {

    GstSample* sample = gst_app_sink_pull_preroll(appsink);
    updateFrame(gst_sample_get_buffer(sample), static_cast<userData*>(data)->info);
    gst_sample_unref(sample);

    return GST_FLOW_CUSTOM_SUCCESS;
}
GstFlowReturn newSample(GstAppSink *appsink, gpointer data) { return GST_FLOW_CUSTOM_SUCCESS; }

//////
void lib_gst_init() { gst_osx_init(); }
bool lib_gst_convert(LIBGST_CONVERT_INFO* info) {

    GstElement *pipeline, *appsrc, *conv, *jpegenc, *appsink;
    GMainLoop* loop = g_main_loop_new(NULL, false);
    
    pipeline = gst_pipeline_new("pipeline");
    appsrc = gst_element_factory_make("appsrc", "source");
    conv = gst_element_factory_make("videoconvert", "conv");
    jpegenc = gst_element_factory_make("jpegenc", "enc");
    appsink = gst_element_factory_make("appsink", "sink");

    assert(pipeline);
    assert(appsrc);
    assert(conv);
    assert(jpegenc);
    assert(appsink);

    g_object_set(G_OBJECT(appsrc), "caps",
                 gst_caps_new_simple("video/x-raw",
                                     "format", G_TYPE_STRING, "BGRA",
                                     "width", G_TYPE_INT, info->width,
                                     "height", G_TYPE_INT, info->height,
                                     "framerate", GST_TYPE_FRACTION, 1, 1,
                                     NULL),
                 NULL);
    gst_bin_add_many(GST_BIN(pipeline), appsrc, conv, jpegenc, appsink, NULL);
    gst_element_link_many(appsrc, conv, jpegenc, appsink, NULL);

    int abgrLen = (info->width * info->height) << 2;
    GstBuffer* raw = gst_buffer_new_wrapped_full(GST_MEMORY_FLAG_READONLY, info->abgr,
                abgrLen, 0, abgrLen, info->abgr, NULL);
    gst_app_src_push_buffer(GST_APP_SRC(appsrc), raw);
    gst_app_src_end_of_stream(GST_APP_SRC(appsrc));

    GstAppSinkCallbacks callbacks = { eos, newPreroll, newSample };
    userData param  = { info, loop };
    gst_app_sink_set_callbacks(GST_APP_SINK(appsink), &callbacks, &param, NULL);

    gst_element_set_state(pipeline, GST_STATE_PLAYING);
    g_main_loop_run(loop);

    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(GST_OBJECT(pipeline));
    g_main_loop_unref(loop);
    return true;
}
