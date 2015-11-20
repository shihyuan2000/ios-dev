//
//  UncaughtExceptionHandler.h
//  ilearn
//
//  Created by 2009 MacBook on 10/30/14.
//  Copyright (c) 2014 NewGenWeb. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AsyncSocket.h"
//#import "GCDAsyncSocket.h"
//#import "ASIFormDataRequest.h"

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}
+(void) InstallUncaughtExceptionHandler;
+ (NSArray *)backtrace;

@end

void UncaughtExceptionHandlers (NSException *exception);
