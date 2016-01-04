//
//  UIMobappView.m
//  MobappJS
//
//  Created by Pascal Viguié on 02/07/2015.
//  Copyright (c) 2015 Pascal Viguié. All rights reserved.
//

#import "UView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#include "Unchained.h"
#import <sys/utsname.h>

#define JS_UNCHAINED_URL            "http://code.jsunchained.com/"
#define JS_UNCHAINED_FILE           JS_UNCHAINED_URL "unchained"
#define DEFAULT_VERSION             "1.0.0"


NSString* deviceName() {
    
    struct utsname systemInfo;
    if (uname(&systemInfo) < 0)
        return nil;
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

//////
@interface UView()

-(void)initWithVersion:(NSString*)version;
-(void)load:(NSURLRequest*)request firstTime:(BOOL)start;
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
    navigationType:(UIWebViewNavigationType)navigationType;
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response;
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data;
-(NSCachedURLResponse*)connection:(NSURLConnection*)connection
                willCacheResponse:(NSCachedURLResponse*)cachedResponse;
-(void)connectionDidFinishLoading:(NSURLConnection*)connection;
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error;

@end //

@implementation UView

-(id)init {

    if (self = [super init])
        [self initWithVersion:nil];
    return self;
}
-(id)initWithCoder:(NSCoder*)aDecoder {

    if (self = [super initWithCoder:aDecoder])
        [self initWithVersion:nil];
    return self;
}
-(id)initWithFrame:(CGRect)rect {

    if (self = [super initWithFrame:rect])
        [self initWithVersion:nil];
    return self;
}
-(id)initWithFrame:(CGRect)rect andVersion:(NSString*)version {

    if (self = [super initWithFrame:rect])
        [self initWithVersion:version];
    return self;
}

-(void)initWithVersion:(NSString *)version {

    replyHTML = nil;
    connHTTP = nil;
    baseURL = nil;
    loading = FALSE;

    if (version != nil)
        Version = [[NSString alloc] initWithString:version];
    
    NSDictionary* deviceDpi = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [[NSNumber alloc] initWithShort:163], @"iPod1,1", // on iPod Touch
                               [[NSNumber alloc] initWithShort:163], @"iPod2,1", // on iPod Touch Second Generation
                               [[NSNumber alloc] initWithShort:163], @"iPod3,1", // on iPod Touch Third Generation
                               [[NSNumber alloc] initWithShort:326], @"iPod4,1", // on iPod Touch Fourth Generation
                               [[NSNumber alloc] initWithShort:326], @"iPod5,1", // on iPod Touch Fifth Generation
                               [[NSNumber alloc] initWithShort:163], @"iPhone1,1", // on 1st Generation iPhone
                               [[NSNumber alloc] initWithShort:163], @"iPhone1,2", // on 1st Generation iPhone 3G
                               [[NSNumber alloc] initWithShort:163], @"iPhone2,1", // on 1st Generation iPhone 3GS
                               [[NSNumber alloc] initWithShort:132], @"iPad1,1", // on iPad
                               [[NSNumber alloc] initWithShort:132], @"iPad2,1", // on iPad 2
                               [[NSNumber alloc] initWithShort:132], @"iPad2,2", // on iPad 2 3G
                               [[NSNumber alloc] initWithShort:132], @"iPad2,3", // on iPad 2 3G
                               [[NSNumber alloc] initWithShort:132], @"iPad2,4", // on iPad 2 16GB
                               [[NSNumber alloc] initWithShort:264], @"iPad3,1", // on 3rd Generation iPad
                               [[NSNumber alloc] initWithShort:264], @"iPad3,2", // on 3rd Generation iPad
                               [[NSNumber alloc] initWithShort:264], @"iPad3,3", // on 3rd Generation iPad
                               [[NSNumber alloc] initWithShort:326], @"iPhone3,1", // on iPhone 4
                               [[NSNumber alloc] initWithShort:326], @"iPhone3,2", // on iPhone 4
                               [[NSNumber alloc] initWithShort:326], @"iPhone3,3", // on iPhone 4
                               [[NSNumber alloc] initWithShort:326], @"iPhone4,1", // on iPhone 4S
                               [[NSNumber alloc] initWithShort:326], @"iPhone5,1", // on iPhone 5 (model A1428, AT&T/Canada)
                               [[NSNumber alloc] initWithShort:326], @"iPhone5,2", // on iPhone 5 (model A1429, everything else)
                               [[NSNumber alloc] initWithShort:264], @"iPad3,4", // on 4th Generation iPad (iPad 4)
                               [[NSNumber alloc] initWithShort:264], @"iPad3,5", // on 4th Generation iPad (iPad 4)
                               [[NSNumber alloc] initWithShort:264], @"iPad3,6", // on 4th Generation iPad (iPad 4)
                               [[NSNumber alloc] initWithShort:163], @"iPad2,5", // on iPad Mini 1G
                               [[NSNumber alloc] initWithShort:163], @"iPad2,6", // on iPad Mini 1G
                               [[NSNumber alloc] initWithShort:163], @"iPad2,7", // on iPad Mini 1G
                               [[NSNumber alloc] initWithShort:326], @"iPhone5,3", // on iPhone 5c (model A1456, A1532 | GSM)
                               [[NSNumber alloc] initWithShort:326], @"iPhone5,4", // on iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
                               [[NSNumber alloc] initWithShort:326], @"iPhone6,1", // on iPhone 5s (model A1433, A1533 | GSM)
                               [[NSNumber alloc] initWithShort:326], @"iPhone6,2", // on iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
                               [[NSNumber alloc] initWithShort:264], @"iPad4,1", // on 5th Generation iPad (iPad Air) - Wifi
                               [[NSNumber alloc] initWithShort:264], @"iPad4,2", // on 5th Generation iPad (iPad Air) - Cellular
                               [[NSNumber alloc] initWithShort:264], @"iPad4,3", // on 5th Generation iPad (iPad Air) - Cellular
                               [[NSNumber alloc] initWithShort:326], @"iPad4,4", // on 2nd Generation iPad Mini - Wifi
                               [[NSNumber alloc] initWithShort:326], @"iPad4,5", // on 2nd Generation iPad Mini - Cellular
                               [[NSNumber alloc] initWithShort:326], @"iPad4,6", // on 2nd Generation iPad Mini
                               [[NSNumber alloc] initWithShort:326], @"iPad4,7", // on 3nd Generation iPad Mini
                               [[NSNumber alloc] initWithShort:326], @"iPad4,8", // on 3nd Generation iPad Mini
                               [[NSNumber alloc] initWithShort:326], @"iPad4,9", // on 3nd Generation iPad Mini
                               [[NSNumber alloc] initWithShort:264], @"iPad5,3", // on iPad Air 2 - Wifi
                               [[NSNumber alloc] initWithShort:264], @"iPad5,4", // on iPad Air 2 - Wifi
                               [[NSNumber alloc] initWithShort:401], @"iPhone7,1", // on iPhone 6 Plus
                               [[NSNumber alloc] initWithShort:326], @"iPhone7,2", nil]; // on iPhone 6
    
    float infoDpi;
    NSString* device = deviceName();
    if (device != nil) {
        
        NSNumber* dpi = [deviceDpi objectForKey:device];
        if (dpi != nil)
            infoDpi = [dpi floatValue];
    }
    else
        infoDpi = 160.f;
    [deviceDpi release];
    
    PlatformData info;
    info.xDpi = infoDpi;
    info.yDpi = infoDpi;
    unchainedInit(&info);

    self.delegate = self;
}
-(void)load:(NSURLRequest*)request firstTime:(BOOL)start {

    if (Version == nil)
        Version = [[NSString alloc] initWithString:@DEFAULT_VERSION];
    if (self.navDelegate != nil)
        [self.navDelegate onRequestChange:request];

    NSString* url = [[NSString alloc] initWithString:[[request URL] absoluteString]];
    try {

        NSRange pos = [url rangeOfString:@"/" options:NSLiteralSearch
                                   range:NSMakeRange([url rangeOfString:@"//"].location + 2,
                                                      url.length - ([url rangeOfString:@"//"].location + 2))];
        if (pos.location != NSNotFound)
            baseURL = [[NSString alloc] initWithString:[url substringToIndex:pos.location]];
        else
            baseURL = [[NSString alloc] initWithString:url];
    }
    catch (NSException* e) {
        baseURL = [[NSString alloc] initWithString:url];
    }
    [url release];

    JSContext* context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"console"][@"log"] = ^(JSValue* msg) {
        NSLog(@"CONSOLE: %@", msg);
    };
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (start == TRUE)
        self.Error = unchainedStart([baseURL cStringUsingEncoding:NSUTF8StringEncoding],
                    [Version cStringUsingEncoding:NSUTF8StringEncoding]);
    else
        self.Error = unchainedReset([baseURL cStringUsingEncoding:NSUTF8StringEncoding]);

    if (self.Error == ERR_ID_NONE) // Create url connection and fire request
        connHTTP = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    else {

        NSLog(@"ERROR: Failed to start 'MobappJS' core - %d", self.Error);
        [super loadRequest:request];
    }
}

-(void)loadRequest:(NSURLRequest*)request { [self loadRequest:request andVersion:nil]; }
-(void)loadRequest:(NSURLRequest*)request andVersion:(NSString *)version {

    if (version != nil) {
        if (Version != nil)
            [version release];

        Version = [[NSString alloc] initWithString:version];
    }
    [self load:request firstTime:TRUE];
}

-(void)applicationDidBecomeActive { unchainedResume(); }
-(void)applicationWillResignActive { unchainedPause(); }
-(void)applicationWillTerminate { unchainedStop(); }

//
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
                                    navigationType:(UIWebViewNavigationType)navigationType {
    if (loading) {

        loading = FALSE;
        return YES;
    }
    [self load:request firstTime:FALSE];
    return NO;
}
//-(void)webViewDidStartLoad:(UIWebView*)webView
//-(void)webViewDidFinishLoad:(UIWebView*)webView
//-(void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error

//
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {

    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    if (replyHTML == nil)
        replyHTML = [[NSMutableData alloc] init];
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {

    // Append the new data to the instance variable you declared
    [replyHTML appendData:data];
}
-(NSCachedURLResponse*)connection:(NSURLConnection*)connection
                willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection {

    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSMutableString* html = [[NSMutableString alloc] initWithData:replyHTML encoding:NSASCIIStringEncoding];
    NSRange pos = [html rangeOfString:@JS_UNCHAINED_FILE];
    if (pos.location != NSNotFound) {

        pos = [html rangeOfString:@"<head>"];
        [html insertString:@"\n<script>\n"
         "window.requestMobapp = function() { };\n"
         "</script>" atIndex:pos.location + 6];
        pos = [html rangeOfString:@"</body>"];
        NSString* jsURL = [[NSString alloc] initWithFormat:@"<script src=\"%s%s.js\"></script>\n",
                           JS_UNCHAINED_URL, unchainedKey()];
        [html insertString:jsURL atIndex:pos.location];
        [jsURL release];
    }
    while (!unchainedReady())
        [NSThread sleepForTimeInterval:.1];

    loading = TRUE;
    [self loadHTMLString:html baseURL:[NSURL URLWithString:baseURL]];
    [html release];

    [replyHTML setLength:0];
    [connHTTP release];
    [baseURL release];

    connHTTP = nil;
    baseURL = nil;
}


//typedef void (*MyLoadRequestMethod)(id receiver, SEL selector, NSURLRequest*);


-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {

    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error: %@", error);

    

    
    
    //[super loadRequest:connection.currentRequest];
    //[[self superclass] loadRequest:connection.currentRequest];
    
    
    //MyLoadRequestMethod mthd = [[self superclass] instanceMethodForSelector:@selector(loadRequest:)];
    //mthd(self, @selector(loadRequest:), connection.currentRequest);
    
    
    



}

//////
-(void)dealloc {

    if (connHTTP != nil)
        [connHTTP release];
    if (replyHTML != nil)
        [replyHTML release];
    if (baseURL != nil)
        [baseURL release];

    if (Version != nil)
        [Version release];

    [super dealloc];
}

@end
