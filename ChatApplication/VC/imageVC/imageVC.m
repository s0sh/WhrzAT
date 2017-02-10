//
//  imageVC.m
//  ChatApplication
//
//  Created by developer on 19/12/14.
//  Copyright (c) 2014 ErmineSoft. All rights reserved.
//

#import "imageVC.h"
#import <Accelerate/Accelerate.h>


@implementation UIImage (Blur)
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur {
	if (blur < 0.f || blur > 1.f) {
		blur = 0.5f;
	}
	int boxSize = (int)(blur * 160);
	boxSize = boxSize - (boxSize % 2) + 1;
    
	CGImageRef img = self.CGImage;
    
	vImage_Buffer inBuffer, outBuffer;
    
	vImage_Error error;
    
	void *pixelBuffer;
    
	CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    
	CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
	inBuffer.width = CGImageGetWidth(img);
	inBuffer.height = CGImageGetHeight(img);
	inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
	inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
	pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
	if (pixelBuffer == NULL)
		NSLog(@"No pixelbuffer");
    
	outBuffer.data = pixelBuffer;
	outBuffer.width = CGImageGetWidth(img);
	outBuffer.height = CGImageGetHeight(img);
	outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
	// Create a third buffer for intermediate processing
	void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
	vImage_Buffer outBuffer2;
	outBuffer2.data = pixelBuffer2;
	outBuffer2.width = CGImageGetWidth(img);
	outBuffer2.height = CGImageGetHeight(img);
	outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
	//perform convolution
	vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
	vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
	error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
	if (error) {
		NSLog(@"error from convolution %ld", error);
	}
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
	                                         outBuffer.width,
	                                         outBuffer.height,
	                                         8,
	                                         outBuffer.rowBytes,
	                                         colorSpace,
	                                         kCGImageAlphaNoneSkipLast);
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
	//clean up
	CGContextRelease(ctx);
    
	CGColorSpaceRelease(colorSpace);
    
	free(pixelBuffer);
    
	free(pixelBuffer2);
    
	CFRelease(inBitmapData);
    
	CGImageRelease(imageRef);
    
	return returnImage;
}


@end



@interface imageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *backImagBlur;

@property (weak, nonatomic) IBOutlet UIImageView *bigAvatar;

@end



@implementation imageVC

@synthesize avatar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
    }
    return self;
}


-(void)dealloc{

    [_backImagBlur removeFromSuperview];
    
    _backImagBlur = nil;
    
    [_bigAvatar removeFromSuperview];
    
    _bigAvatar = nil;
    
     avatar = nil;
    
    [MC saveData:nil toArchive:@"dImage"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bigAvatar.image = avatar;

    self.bigAvatar.layer.cornerRadius = self.bigAvatar.frame.size.width / 2;
    
    self.bigAvatar.layer.borderWidth = 1.0f;
    
    self.bigAvatar.layer.borderColor = [UIColor colorWithRed:95/255.f green:129/255.f blue:139/255.f alpha:0.5f].CGColor;
    
    self.bigAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.bigAvatar.clipsToBounds = YES;

    UIImage* phIm =  avatar;
    
    self.backImagBlur.image = [phIm boxblurImageWithBlur:0.9];
 
}

- (IBAction)backAction{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

@end
