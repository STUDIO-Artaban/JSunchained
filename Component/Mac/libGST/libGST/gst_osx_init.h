#ifndef __GST_IOS_INIT_H__
#define __GST_IOS_INIT_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_G_IO_MODULE_DECLARE(name) \
extern void G_PASTE(g_io_module_, G_PASTE(name, _load_static)) (void)

#define GST_G_IO_MODULE_LOAD(name) \
G_PASTE(g_io_module_, G_PASTE(name, _load_static)) ()

#define GST_IOS_PLUGIN_COREELEMENTS
#define GST_IOS_PLUGIN_VIDEOCONVERT
#define GST_IOS_PLUGIN_APP
#define GST_IOS_PLUGIN_JPEG

void gst_osx_init();

G_END_DECLS

#endif
