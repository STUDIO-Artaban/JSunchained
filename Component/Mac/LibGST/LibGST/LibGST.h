//
//  libGST.h
//  libGST
//
//  Created by Pascal Viguié on 25/02/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include <boost/thread.hpp>
#include "defLibGST.h"

//! Project version number for libGST.
FOUNDATION_EXPORT double libGSTVersionNumber;

//! Project version string for libGST.
FOUNDATION_EXPORT const unsigned char libGSTVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <libGST/PublicHeader.h>
void lib_gst_init();
bool lib_gst_convert(LIBGST_CONVERT_INFO* info);
