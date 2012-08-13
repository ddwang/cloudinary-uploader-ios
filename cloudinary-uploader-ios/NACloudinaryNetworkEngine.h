//
//  NACloudinaryNetworkEngine.h
//  cloudinary-tester
//
//  Created by Daniel Wang on 8/12/12.
//  Copyright (c) 2012 Network Anomaly. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface NACloudinaryNetworkEngine : MKNetworkEngine

-(NACloudinaryNetworkEngine *) initCloud:(NSString *) cloudName
							  withApiKey:(NSString *) apiKey
							andApiSecret:(NSString *) apiSecret;

@property (strong, readonly) NSString* cloudName;
@property (strong, readonly) NSString* apiKey;
@property (strong, readonly) NSString* apiSecret;

-(MKNetworkOperation *) imageUpload:(UIImage *) image
					   onCompletion:(MKNKResponseBlock) completionBlock
							onError:(MKNKErrorBlock) errorBlock;

@end
