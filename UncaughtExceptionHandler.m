
#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "AppDelegate.h"
#import "Common.h"
#import "DejalActivityView.h"
#import "SaveNoteAFHTTPClient.h"
//#import "ASIHTTPRequest.h"

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    //	    [UIDevice currentDevice].uniqueIdentifier];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}

void MySignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[[UncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.\n"
                         @"%@", nil),
       signal, getAppInfo()]
      userInfo:
      [NSDictionary   dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]] waitUntilDone:YES];
}

@implementation UncaughtExceptionHandler
+(void) InstallUncaughtExceptionHandler
{
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
}
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        dismissed = YES;
    }
}
- (void)handleException:(NSException *)exception
{
    UIAlertView *alert =
    [[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
      message:[NSString stringWithFormat:NSLocalizedString(
                                                           @"You can try to continue but the application may be unstable.\n"
                                                           @"%@\n%@", nil),
               [exception reason],
               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"Quit", nil)
      otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    [alert show];
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

void UncaughtExceptionHandlers (NSException *exception)
{
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [[exception name] stringByAppendingString:@" *** "];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//    NSDictionary *json = @{
//                                           @"OsType":@"0",
//                                           @"Version":version,
//                                           @"ErrorMsg":[name stringByAppendingString:reason] ,
//                                           @"StackTrace":[arr componentsJoinedByString:@"  |  "],
//                                           @"DeviceId":@"",
//                                           @"Model":@"",
//                                           @"Brand":@"",
//                                           @"Product":@""
//                           };
    //写日志文件
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    //    @"http://api.qa.esubonline.com/v2/"
    NSString  *contactWeburl = [appD.eSUBServerURL stringByReplacingOccurrencesOfString:@"api" withString:@"webapi"];
    contactWeburl = [contactWeburl stringByReplacingOccurrencesOfString:@"v2" withString:@"api"];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:contactWeburl]];
//    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:@"http://webapi.qa.esubonline.com/api/"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     [params setValue:@"0" forKey:@"OsType"];
     [params setValue:version forKey:@"Version"];
     [params setValue:[name stringByAppendingString:reason] forKey:@"ErrorMsg"];
     [params setValue:[arr componentsJoinedByString:@"  |  "] forKey:@"StackTrace"];
     [params setValue:@"" forKey:@"DeviceId"];
     [params setValue:@"" forKey:@"Model"];
     [params setValue:@"" forKey:@"Brand"];
     [params setValue:@"" forKey:@"Product"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"error" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You have sucessfully saved the error message to the database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];

            }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You have't sucessfully saved the error message to the database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
    
        [operation start];
        [operation waitUntilFinished];
    

//    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    NSLog(@"1heqin, CRASH: %@", exception);
//    NSLog(@"heqin, Stack Trace: %@", [exception callStackSymbols]);
}

@end