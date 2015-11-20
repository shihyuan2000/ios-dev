//
//  WeatherAFHTTPClient.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/23/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "AFNetworking.h"

@interface WeatherAFHTTPClient : AFHTTPClient

+(WeatherAFHTTPClient *)sharedClient:(NSURL *)url;

@end
