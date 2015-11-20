//
//  ImageUploadAFHTTPClient.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/15/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AFNetworking.h"

@interface ImageUploadAFHTTPClient : AFHTTPClient

+(ImageUploadAFHTTPClient *)sharedClient:(NSURL *)url;

@end
