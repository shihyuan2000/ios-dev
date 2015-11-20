//
//  WeatherAFHTTPClient.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/23/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "WeatherAFHTTPClient.h"
#import "AppDelegate.h"

@implementation WeatherAFHTTPClient

+(WeatherAFHTTPClient *)sharedClient:(NSURL *)url
{
    
    WeatherAFHTTPClient *_sharedClient;
    _sharedClient = [[self alloc] initWithBaseURL:url];
    return _sharedClient;
    
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}


@end
