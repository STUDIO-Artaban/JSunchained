//
//  AppDelegate.m
//  YourSiteApp
//
//  Created by Pascal Viguié on 22/02/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [((ViewController*)NSApp.mainWindow.windowController.contentViewController).unchainedView applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [((ViewController*)NSApp.mainWindow.windowController.contentViewController).unchainedView applicationWillTerminate];
}

@end
