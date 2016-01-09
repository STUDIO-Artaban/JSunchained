//
//  ViewController.h
//  YourSiteApp
//
//  Created by Pascal Viguié on 09/01/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Unchained/UView.h>

@interface ViewController : UIViewController<UViewDelegate>

@property (weak, nonatomic) IBOutlet UView *unchainedView;

@end
