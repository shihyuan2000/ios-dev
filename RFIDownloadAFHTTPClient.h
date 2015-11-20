//
//  RFIDownloadAFHTTPClient.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 7/8/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AFNetworking.h"

@interface RFIDownloadAFHTTPClient : AFHTTPClient

+(RFIDownloadAFHTTPClient *)sharedClient:(NSURL *)url;

@end
