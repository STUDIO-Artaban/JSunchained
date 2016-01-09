//
//  libGST.h
//  libGST
//
//  Created by Pascal Viguié on 07/02/2015.
//  Copyright (c) 2015 Pascal Viguié. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <boost/thread.hpp>
#include "defLibGST.h"

//! Project version number for libGST.
FOUNDATION_EXPORT double libGSTVersionNumber;

//! Project version string for libGST.
FOUNDATION_EXPORT const unsigned char libGSTVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <libGST/PublicHeader.h>
void lib_gst_init();
bool lib_gst_launch(const char* pipeline);
bool lib_gst_convert(LIBGST_CONVERT_INFO* info);
