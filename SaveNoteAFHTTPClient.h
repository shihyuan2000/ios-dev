//
//  SaveNoteAFHTTPClient.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/21/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AFNetworking.h"

@interface SaveNoteAFHTTPClient : AFHTTPClient

+(SaveNoteAFHTTPClient *)sharedClient:(NSURL *)url;

@end
