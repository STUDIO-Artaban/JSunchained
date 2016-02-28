//
//  defLibGST.h
//  libGST
//
//  Created by Pascal Viguié on 24/02/2016.
//
//

#ifndef libGST_defLibGST_h
#define libGST_defLibGST_h

typedef struct {

    unsigned char* abgr;
    char** dest;
    
    boost::mutex* mutex;
    unsigned int* len; // Converted format buffer length
    int max; // Max 'dest' buffer length
    
    short width;
    short height;
    
} LIBGST_CONVERT_INFO;

#endif
