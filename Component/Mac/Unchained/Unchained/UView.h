//
//  UView.h
//  Unchained
//
//  Created by Pascal Viguié on 09/02/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@protocol UViewDelegate

@required
-(void)onRequestChange:(NSURLRequest*)request;

@end //

@interface UView : WebView<WebFrameLoadDelegate, NSURLConnectionDelegate> {
    
    NSMutableData* replyHTML;
    NSURLConnection* connHTTP;
    
    NSString* baseURL;
    NSString* Version;
    BOOL loading;
}

@property(atomic) unsigned char Error;
@property(nonatomic, assign) id<UViewDelegate> navDelegate;

-(id)init;
-(id)initWithCoder:(NSCoder*)aDecoder;
-(id)initWithFrame:(CGRect)rect;
-(id)initWithFrame:(CGRect)rect andVersion:(NSString*)version;

-(void)applicationDidBecomeActive;
-(void)applicationWillResignActive;
-(void)applicationWillTerminate;

-(void)loadRequest:(NSURLRequest*)request;
-(void)loadRequest:(NSURLRequest*)request andVersion:(NSString*)version;

@end //
