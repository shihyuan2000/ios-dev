//
//  RFIDownloadAFHTTPClient.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 7/8/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "RFIDownloadAFHTTPClient.h"
#import "AppDelegate.h"

@implementation RFIDownloadAFHTTPClient

+(RFIDownloadAFHTTPClient *)sharedClient:(NSURL *)url
{
    
    RFIDownloadAFHTTPClient *_sharedClient;
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
    [self setDefaultHeader:@"Accept" value:@"application/pdf"];
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    NSString *str = [NSString stringWithFormat:@"Bearer %@", appD.tokenAccess];
    [self setDefaultHeader:@"Authorization" value:str];
    
    //    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}

@end
