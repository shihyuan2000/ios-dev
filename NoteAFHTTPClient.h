//
//  NoteAFHTTPClient.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/13/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AFNetworking.h"

@interface NoteAFHTTPClient : AFHTTPClient

+(NoteAFHTTPClient *)sharedClient:(NSURL *)url;

@end
