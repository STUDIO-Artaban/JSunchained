//
//  NSResources.h
//  MobappJS
//
//  Created by Pascal Viguié on 27/08/2015.
//  Copyright (c) 2015 Pascal Viguié. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureInput.h>

#import <UIKit/UIAlertView.h>


////// Sensors
@interface NSMotion : NSObject {

    CMMotionManager* motion;
    NSTimer* accelTimer;
}
-(id)init;

-(void)resume;
-(void)pause;
-(void)stop;

@end //

////// Alert
@interface NSAlert : UIAlertView<UIAlertViewDelegate>

-(id)initWithURL:(const char*)url andPermissions:(int)perm;
-(void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;

@end //

////// Camera
@interface NSCamera : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    AVCaptureSession* captureSession;
    AVCaptureDeviceInput* deviceInput;
    AVCaptureVideoDataOutput* videoOutput;
}

@property(atomic) BOOL camReady;

-(BOOL)initCamera;
-(bool)startCamera:(short)width andHeight:(short)height;
-(bool)stopCamera;

@end
