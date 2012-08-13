//
//  NACloudinaryNetworkEngine.m
//  cloudinary-tester
//
//  Created by Daniel Wang on 8/12/12.
//  Copyright (c) 2012 Network Anomaly. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NACloudinaryNetworkEngine.h"

@implementation NACloudinaryNetworkEngine
{
	NSString* _imageUploadPath;
}

@synthesize cloudName =_cloudName;
@synthesize apiKey = _apiKey;
@synthesize apiSecret = _apiSecret;

-(NACloudinaryNetworkEngine *) initCloud:(NSString *) cloudName
							  withApiKey:(NSString *) apiKey
							andApiSecret:(NSString *) apiSecret;
{
	self = [super initWithHostName:@"api.cloudinary.com"];
	if (self)
	{
		_cloudName = cloudName;
		_apiKey = apiKey;
		_apiSecret = apiSecret;
		
		_imageUploadPath = [NSString stringWithFormat:@"/v1_1/%@/image/upload", _cloudName];
	}
	return self;
}

-(MKNetworkOperation *) imageUpload:(UIImage *) image
					   onCompletion:(MKNKResponseBlock) completionBlock
							onError:(MKNKErrorBlock) errorBlock
{
	NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								   _apiKey, @"api_key",
								   [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]], @"timestamp",
								   nil];
	[params setObject:[self calculateSignature:params]
			   forKey:@"signature"];
	
	MKNetworkOperation* op = [self operationWithPath:_imageUploadPath
											  params:params
										  httpMethod:@"POST"];
	[op setFreezable:YES];
	
	NSData* imageData = UIImageJPEGRepresentation(image, 0.75);
	[op addData:imageData forKey:@"file"];
	
	[op onCompletion:^(MKNetworkOperation* operation) {
		if (completionBlock)
		{
			completionBlock(operation);
		}
	} onError:^(NSError* error) {
		if (errorBlock)
		{
			errorBlock(error);
		}
	}];
	
	[self enqueueOperation:op];
	return op;
}

-(NSString *) calculateSignature:(NSMutableDictionary *) params
{
	static NSArray* importantKeys = nil;
	if (!importantKeys)
	{
		importantKeys = [NSArray arrayWithObjects:@"callback", @"eager", @"format", @"public_id", @"tags", @"timestamp", @"transformation", @"type", nil];
	}
	
	NSMutableString* paramString = [[NSMutableString alloc] init];
	for (NSString* key in importantKeys)
	{
		NSString* value = [params objectForKey:key];
		if (value)
		{
			if (paramString.length > 0)
			{
				[paramString appendString:@"&"];
			}
			[paramString appendString:key];
			[paramString appendString:@"="];
			[paramString appendString:value];
		}
	}
	[paramString appendString:_apiSecret];
	
	return [self SHA1Digest:paramString];
}

-(NSString *) SHA1Digest:(NSString *) input
{
	NSData* data = [input dataUsingEncoding:NSASCIIStringEncoding
					   allowLossyConversion:YES];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
	{
		[output appendFormat:@"%02x", digest[i]];
	}
	return output;
}

@end
