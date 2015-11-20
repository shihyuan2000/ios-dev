//
//  LoginAFHTTPClient.m
//  OilWell
//
//  Created by LAWRENCE SHANNON on 1/14/14.
//  Copyright (c) 2014 Saritasa. All rights reserved.
//

#import "LoginAFHTTPClient.h"
#define kNetworkTimeOut 30

@implementation LoginAFHTTPClient

+(LoginAFHTTPClient *)sharedClient:(NSURL *)url
{
/*
    static LoginAFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:url];
    });
    return _sharedClient;
*/

    LoginAFHTTPClient *_sharedClient;
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

//    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [request setTimeoutInterval:kNetworkTimeOut];


    return request;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [request setTimeoutInterval:kNetworkTimeOut];
    return request;
}

@end
