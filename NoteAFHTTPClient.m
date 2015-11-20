//
//  NoteAFHTTPClient.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/13/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "NoteAFHTTPClient.h"
#import "AppDelegate.h"

@implementation NoteAFHTTPClient

+(NoteAFHTTPClient *)sharedClient:(NSURL *)url
{
/*
    static NoteAFHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:url];
    });
    return _sharedClient;
*/
    
    NoteAFHTTPClient *_sharedClient;
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
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    NSString *str = [NSString stringWithFormat:@"Bearer %@", appD.tokenAccess];
    [self setDefaultHeader:@"Authorization" value:str];
    
    //    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}

@end
