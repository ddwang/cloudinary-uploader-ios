//
//  NAViewController.m
//  cloudinary-uploader
//
//  Created by Daniel Wang on 8/12/12.
//  Copyright (c) 2012 Network Anomaly. All rights reserved.
//

#import "NAViewController.h"
#import "NACloudinaryNetworkEngine.h"

#define CLOUDINARY_CLOUD_NAME @"YOUR_CLOUD_NAME"
#define CLOUDINARY_API_KEY @"YOU_API_KEY"
#define CLOUDINARY_API_SECRET @"YOUR_API_SECRET"

@interface NAViewController ()

@end

@implementation NAViewController

@synthesize imageView = _imageView;
@synthesize textView = _textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setTextView:nil];
	
    [super viewDidUnload];
}

- (IBAction)doUpload:(id) sender
{
	NACloudinaryNetworkEngine* cloudinary =
	[[NACloudinaryNetworkEngine alloc] initCloud:CLOUDINARY_CLOUD_NAME
									  withApiKey:CLOUDINARY_API_KEY
									andApiSecret:CLOUDINARY_API_SECRET];
	
	[cloudinary imageUpload:_imageView.image
			   onCompletion:^(MKNetworkOperation* completedOperation)
	 {
		 _textView.text = completedOperation.responseString;
	 }
					onError:^(NSError* error)
	 {
		 NSLog(@"Error: %@", error.description);
	 }];
}

@end
