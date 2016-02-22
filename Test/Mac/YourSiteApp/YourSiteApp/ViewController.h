//
//  ViewController.h
//  YourSiteApp
//
//  Created by Pascal Viguié on 22/02/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Unchained/UView.h>

@interface ViewController : NSViewController<UViewDelegate>

@property (weak) IBOutlet UView *unchainedView;

@end

