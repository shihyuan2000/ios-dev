//
//  LoginAFHTTPClient.h
//  OilWell
//
//  Created by LAWRENCE SHANNON on 1/14/14.
//  Copyright (c) 2014 Saritasa. All rights reserved.
//

#import "AFNetworking.h"

@interface LoginAFHTTPClient : AFHTTPClient

+(LoginAFHTTPClient *)sharedClient:(NSURL *)url;

@end
