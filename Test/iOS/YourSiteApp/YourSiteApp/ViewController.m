//
//  ViewController.m
//  YourSiteApp
//
//  Created by Pascal Viguié on 09/01/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import "ViewController.h"

#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

// ENTER YOUR WEB SITE URL BELOW ///////////////////////////////////////////////
static NSString* YOUR_INTERNET_SITE = @"http://jsunchained.com/demo.html";
static NSString* YOUR_ASSETS_SITE = @"assets://demo.html";
// NOTE: For the demo the site from assets will be used only when Internet connection will be unavailable

@interface ViewController ()

+(SCNetworkReachabilityFlags)getNetworkFlags:(BOOL)local;
+(bool)isOnline;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSString* demoURL;
    if (![ViewController isOnline])
        demoURL = YOUR_ASSETS_SITE;
    else
        demoURL = YOUR_INTERNET_SITE;

    NSURL* url = [NSURL URLWithString:demoURL];
    NSURLRequest* requestObj = [NSURLRequest requestWithURL:url];
    [self.unchainedView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
+(SCNetworkReachabilityFlags)getNetworkFlags:(BOOL)local {
    
    SCNetworkReachabilityRef reachability = NULL;
    if (local) {
        
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault,
                                                              (const struct sockaddr*)&zeroAddress);
    }
    else
        reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com");
    
    if (reachability != NULL) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags))
            return flags;
    }
    return 0;
}
+(bool)isOnline {
    
    SCNetworkReachabilityFlags flags = [ViewController getNetworkFlags:FALSE];
    if ((flags != 0) &&
        ((((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) &&
          ((flags & kSCNetworkFlagsReachable) != 0)) ||
         ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) ||
         (((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))  &&
          ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0))))
        return true;
    
    return false;
}

////// UViewDelegate
-(void)onRequestChange:(NSURLRequest *)request {
    NSLog(@"URL changed: %@", request);
}

@end
