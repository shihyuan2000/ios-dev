//
//  ProjectAFHTTPClient.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/11/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AFNetworking.h"

@interface ProjectAFHTTPClient : AFHTTPClient

+(ProjectAFHTTPClient *)sharedClient:(NSURL *)url;

@end
