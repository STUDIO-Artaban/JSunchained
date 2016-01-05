//
//  NSResources.mm
//  JSunchained
//
//  Created by Pascal Viguié on 27/08/2015.
//  Copyright (c) 2015 Pascal Viguié. All rights reserved.
//

#import "NSResources.h"
#include "Unchained.h"
#include "Permission.h"

#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>


////// Sensors
#define ACCEL_TIMER_INTERVAL    1/30.0 // Accelerometer update interval (in seconds)

@interface NSMotion()

-(void)accelUpdate;

@end //

@implementation NSMotion

-(id)init {

    if (self = [super init])
        motion = [[CMMotionManager alloc] init];
    return self;
}

-(void)resume {

    [motion startAccelerometerUpdates];
    accelTimer = [NSTimer scheduledTimerWithTimeInterval:ACCEL_TIMER_INTERVAL target:self
                                                selector:@selector(accelUpdate) userInfo:nil repeats:YES];
}
-(void)pause { [self stopMotion]; }
-(void)stop { [self stopMotion]; }

-(void)stopMotion {

    [motion stopAccelerometerUpdates];
    [accelTimer invalidate];
    accelTimer = nil;
}
-(void)accelUpdate {

    unchainedAccel((float)motion.accelerometerData.acceleration.x,
                   (float)motion.accelerometerData.acceleration.y,
                   (float)motion.accelerometerData.acceleration.z);
}

//
-(void)dealloc {

    [motion release];
    [super dealloc];
}

@end


////// Alert
#define PERMISSION_CAMERA       "\n\u2022 Camera feature"

@implementation NSAlert

-(id)initWithURL:(const char*)url andPermissions:(int)perm {

    NSString* permission;
    if ((perm & PERMISSION_MASK_CAMERA) != 0)
        permission = @PERMISSION_CAMERA;

    NSString* msg = [[NSString alloc] initWithFormat:@"Allow %s to Access:%@", url, permission];
    if (self = [super initWithTitle:@"Confirm Access" message:msg delegate:nil
                   cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"Allow", nil])
        self.delegate = self;

    [msg release];
    return self;
}
-(void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
#ifndef UNCHAINED_COMPONENT
    unchainedPermission((buttonIndex == 0)? PERMISSION_ACCES_NOT_ALLOWED:PERMISSION_ACCES_ALLOWED);
#endif
}

@end


////// Camera
@interface NSCamera()

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
      fromConnection:(AVCaptureConnection *)connection;

@end //

@implementation NSCamera

-(BOOL)initCamera {
    
    captureSession = nil;
    videoOutput = nil;
    deviceInput = nil;
    
    AVCaptureDevice* backCamera = nil;
    NSArray* deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* device in deviceArray)
        if ([device position] == AVCaptureDevicePositionBack)
            backCamera = device;
    
    if (backCamera == nil) {
        
        NSLog(@"ERROR: No back-facing camera found (line:%d)", __LINE__);
        return FALSE;
    }
    NSError* err = nil;
    if ([backCamera lockForConfiguration:&err] == YES) {
        
        if ([backCamera isFocusModeSupported:AVCaptureFocusModeLocked])
            [backCamera setFocusMode:AVCaptureFocusModeLocked];
        if ([backCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            [backCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        if ([backCamera isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
            [backCamera setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        if ([backCamera isFlashModeSupported:AVCaptureFlashModeOff])
            [backCamera setFlashMode:AVCaptureFlashModeOff];
        if ([backCamera isTorchModeSupported:AVCaptureTorchModeOff])
            [backCamera setTorchMode:AVCaptureTorchModeOff];
        [backCamera unlockForConfiguration];
    }
    else
        NSLog(@"WARNING: Failed to configure camera (line:%d)", __LINE__);
    
    deviceInput = [[[AVCaptureDeviceInput alloc] initWithDevice:backCamera error:&err] autorelease];
    if (!deviceInput) {
        
        NSLog(@"ERROR: %@ (line:%d)", err, __LINE__);
        return FALSE;
    }
    captureSession = [[AVCaptureSession alloc] init];
    if ([captureSession canAddInput:deviceInput])
        [captureSession addInput:deviceInput];
    else {
        
        NSLog(@"ERROR: Failed to add input device (line:%d)", __LINE__);
        return FALSE;
    }
    videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSArray* formatArray = [videoOutput availableVideoCVPixelFormatTypes];
    BOOL bgraFormat = NO;
    for (NSNumber* format in formatArray)
        if ([format integerValue] == kCVPixelFormatType_32BGRA)
            bgraFormat = YES;
    
    if (bgraFormat == NO) {
        
        NSLog(@"ERROR: 'kCVPixelFormatType_32BGRA' video format not supported (line:%d)", __LINE__);
        return FALSE;
    }
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber
                                                                      numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    dispatch_queue_t camQueue = dispatch_queue_create("camQueue", NULL);
    [videoOutput setSampleBufferDelegate:self queue:camQueue];
    if ([captureSession canAddOutput:videoOutput])
        [captureSession addOutput:videoOutput];
    else {
        
        NSLog(@"ERROR: Failed to add video output (line:%d)", __LINE__);
        return FALSE;
    }
    return TRUE;
}

-(bool)startCamera:(short)width andHeight:(short)height {
    
    if (self.camReady == FALSE) {
        NSLog(@"ERROR: Camera not ready (line:%d)", __LINE__);
        return false;
    }
    if ((width == 640) && (height == 480))
        [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    else if ((width == 1280) && (height == 720))
        [captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    else {
        NSLog(@"ERROR: Session preset format %dx%d not supported (line:%d)", width, height, __LINE__);
        return false;
    }
    if (![captureSession isRunning]) {
        [captureSession startRunning];
        return true;
    }
    return false;
}
-(bool)stopCamera {
    
    if (self.camReady == FALSE) {
        NSLog(@"ERROR: Camera not ready (line:%d)", __LINE__);
        return false;
    }
    
    if ([captureSession isRunning]) {
        [captureSession stopRunning];
        return true;
    }
    return false;
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
      fromConnection:(AVCaptureConnection *)connection {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    CVImageBufferRef camBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(camBuffer, 0);
    unchainedCamera(reinterpret_cast<const unsigned char*>((uint8_t*)CVPixelBufferGetBaseAddress(camBuffer)));
    CVPixelBufferUnlockBaseAddress(camBuffer, 0);
    [pool release];
}
@end
