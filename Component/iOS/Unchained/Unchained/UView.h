//
//  UView.h
//  JSunchained
//
//  Created by Pascal Viguié on 02/07/2015.
//  Copyright (c) 2015 Pascal Viguié. All rights reserved.
//

#import <UIKit/UIWebView.h>


//////
@protocol UViewDelegate

@required
-(void)onRequestChange:(NSURLRequest*)request;

@end //

@interface UView : UIWebView<UIWebViewDelegate, NSURLConnectionDelegate> {

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
