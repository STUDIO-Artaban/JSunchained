//
//  NSResources.h
//  Unchained
//
//  Created by Pascal Viguié on 09/02/2016.
//  Copyright © 2016 STUDIO Artaban. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureInput.h>


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
