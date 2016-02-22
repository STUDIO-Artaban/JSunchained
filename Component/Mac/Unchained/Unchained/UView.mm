//
//  UView.mm
//  Unchained
//
//  Created by Pascal Viguié on 09/02/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import "UView.h"
#import <JavaScriptCore/JavaScriptCore.h>

#include "Unchained.h"
#import <sys/utsname.h>

#define JS_UNCHAINED_URL            "http://code.jsunchained.com/"
#define JS_UNCHAINED_FILE           JS_UNCHAINED_URL "unchained"
#define DEFAULT_VERSION             "1.0.0"


//////
@interface UView()

-(void)initWithVersion:(NSString*)version;
-(void)load:(NSURLRequest*)request firstTime:(BOOL)start;
-(void)webView:(WebView*)sender didStartProvisionalLoadForFrame:(WebFrame*)frame;
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

-(void)initWithVersion:(NSString*)version {

    replyHTML = nil;
    connHTTP = nil;
    baseURL = nil;
    loading = FALSE;

    if (version != nil)
        Version = [[NSString alloc] initWithString:version];
    
    PlatformData info;
    info.xDpi = 0.f;
    info.yDpi = 0.f;
    unchainedInit(&info);

    self.frameLoadDelegate = self;
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

    
    
    

    
    
    
    //JSContext* context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //[[context objectForKeyedSubscript:@"console"] setObject:^(JSValue* msg) {
    //    NSLog(@"CONSOLE: %@", msg);
    //} forKeyedSubscript:@"log"];
    
    
    
    
    
    
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (start == TRUE)
        self.Error = unchainedStart([baseURL cStringUsingEncoding:NSUTF8StringEncoding],
                    [Version cStringUsingEncoding:NSUTF8StringEncoding]);
    else
        self.Error = unchainedReset([baseURL cStringUsingEncoding:NSUTF8StringEncoding]);

    if (self.Error == ERR_ID_NONE) // Create url connection and fire request
        connHTTP = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    else {

        NSLog(@"ERROR: Failed to start 'JSunchained' core - %d", self.Error);
        [[super mainFrame] loadRequest:request];
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
-(void)webView:(WebView*)sender didStartProvisionalLoadForFrame:(WebFrame*)frame {

    if (loading) {
        loading = FALSE;
        return;
    }
    NSURL* url = [[NSURL alloc] initWithString:sender.mainFrameURL];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [self load:request firstTime:FALSE];
    [request release];
    [url release];

    [frame stopLoading];
}
//- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
//- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame

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
         "window.requestUnchained = function() { };\n"
         "</script>" atIndex:pos.location + 6];
    }
    while (!unchainedReady())
        [NSThread sleepForTimeInterval:.1];
    
    loading = TRUE;
    [self.mainFrame loadHTMLString:html baseURL:[NSURL URLWithString:baseURL]];
    [html release];

    [replyHTML setLength:0];
    [connHTTP release];
    [baseURL release];

    connHTTP = nil;
    baseURL = nil;
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {

    NSLog(@"ERROR: %@ (line:%d)", error, __LINE__);
    // TODO: Load URL using common UIWebView control features
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
