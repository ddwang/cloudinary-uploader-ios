//
//  NAViewController.h
//  cloudinary-uploader
//
//  Created by Daniel Wang on 8/12/12.
//  Copyright (c) 2012 Network Anomaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)doUpload:(id)sender;
@end
