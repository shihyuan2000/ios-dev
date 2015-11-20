//
//  AppDelegate.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/22/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "NoteObject.h"
#import "DailyReportObject.h"
#import "CrewObject.h"
#import "UploadObject.h"
#import <PSPDFKit/PSPDFKit.h>
#import "UncaughtExceptionHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //start catch error log
    [UncaughtExceptionHandler InstallUncaughtExceptionHandler];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandlers);
    
    self.projectFilter = @"Open";
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = (id) self;
    self.locationManager.distanceFilter = 1;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    self.eSubsDB = [[eSubsDB alloc] initialise];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;

    self.window.backgroundColor = [UIColor whiteColor];

    // Logging Control - Do NOT use logging for non-development builds.

    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNewNoteCount] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", NSIntegerMax] forKey:kNewNoteCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNewDRCount] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", NSIntegerMax] forKey:kNewDRCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNewCrewCount] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", NSIntegerMax] forKey:kNewCrewCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNewEquipmentCount] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", NSIntegerMax] forKey:kNewEquipmentCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    PSPDFSetLicenseKey("HV5rcgfAIA1cR50FVhqzbc505BQj/6tyxRfwyHvNcW+cMi+IXqK77vVx2jLi7zF86G+i7nD839Vr1FxnSiTWIBKlr7bb4AAfGLmw8KYme0Pe8BhI02Njkn0GsYV4BOPR4A3aYdzFmkQ81CBrXwwo48doIM9BOlhZfCnAGe7cOpVvLFOfaYLOyYMWv+z0A++ljKvZ2/TQo5Yl5wBkh/Jo3nNPKwNbb632gIOZ+aRwIl6GskYai6KP10DGr6i//98y2vAUYHTWMiUFuzHFcgelbQQVK01j3+EJt56szqqtNC1mJEqpjSJtYjie1G9bVK8VYW92NDEQTCiXcaCPg5kru1CXNyfBrJhwrxwxw1cdlHzIi93NMdvc/paE5X8PzSbgDyq7YddmtsCfquhLQl0jEA==");
    
    return YES;

}

- (void) handleNetworkChange:(NSNotification *)notice
{

#ifdef DEBUG
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];

    NSString *errorDesc = @"Got Network change message, status unknown";
    if (remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
        errorDesc = [NSString stringWithFormat:@"Got Network change message, No connectivity!"];
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
        errorDesc = [NSString stringWithFormat:@"Got Network change message, Wifi connectivity!"];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        errorDesc = [NSString stringWithFormat:@"Got Network change message, Cell connectivity!"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorDesc message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
#endif

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if (remoteHostStatus != NotReachable && self.tokenAccess)
    {
        for (NoteObject *note in [self.eSubsDB getUnsavedNoteImageObjects:self.userId])
        {
            [Common saveNoteImageToWebService:[self.eSubsDB getNoteObject:note.projectId andNoteId:note.id forUserID:self.userId]];
        }
        
        for (NoteObject *note in [self.eSubsDB getUnsavedNoteObjects:self.userId])
        {
            NoteObject *n = [self.eSubsDB getNoteObject:note.projectId andNoteId:note.id forUserID:self.userId];
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld", (long)n.id]];
            if (!str)
            {
                str = [[NSUUID UUID] UUIDString];
            }
            [Common saveNoteToWebService:n usingUUID:str];
        }
        
        NSMutableArray *listOfDR = [self.eSubsDB getUnsavedDailyReportsObjects:self.userId];
        for (int i = 0; i < listOfDR.count; i++ )
        {
            DailyReportObject *dr = [listOfDR objectAtIndex:i];
            NSString *zipCode = dr.weatherIcon;

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd-yyyy"];
            NSDate *dateDr = [formatter dateFromString:dr.date];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *date  =[formatter stringFromDate:dateDr];

            BOOL isLastValue =(i < listOfDR.count);
            //get weather information todo
            if (zipCode)
            {
                [Common GetPastWeather:zipCode forDate:date
                success:^(id responseObject)
                 {
                     NSDictionary *data = [responseObject objectForKey:@"data"];
                     NSArray *w = [data objectForKey:@"weather"];
                     if (w.count > 0)
                     {
                         NSDictionary *ndata = [w objectAtIndex:0];
                         NSArray *h = [ndata objectForKey:@"hourly"];
                         if (h.count > 4)
                         {
                             NSDictionary *hourly = [h objectAtIndex:4];
                             dr.weatherId = [[hourly objectForKey:@"weatherCode"] integerValue];
                             NSInteger windSpeed = [[hourly objectForKey:@"windspeedMiles"] integerValue];
                             if (windSpeed <= 2)
                             {
                               dr.windId = 1;
                             }
                             else if (windSpeed > 2 && windSpeed <= 15)
                             {
                                 dr.windId = 2;
                             }
                             else if (windSpeed > 15 && windSpeed <= 22)
                             {
                                 dr.windId = 3;
                             }
                             else if (windSpeed > 22)
                             {
                                 dr.windId = 4;
                             }
                             else
                             {
                                 dr.windId = 0;
                             }
                             dr.temperature = [[hourly objectForKey:@"tempF"] integerValue];
                             NSArray *weatherIconUrl = [hourly objectForKey:@"weatherIconUrl"];
                             if (weatherIconUrl.count)
                             {
                                 NSDictionary *val = [weatherIconUrl objectAtIndex:0];
                                 dr.weatherIcon = [val objectForKey:@"value"];
                             }
                         }
                     }
                     
                     [self SaveDaliyReport:dr IsLast:isLastValue Delegate:appD];

                 }
                failure:^(NSError *error)
                 {
                     NSLog(@"Network error in downloading weather: %@", [error localizedDescription]);
                     [self SaveDaliyReport:dr IsLast:isLastValue Delegate:appD];

                 }];
                
            }
            else
            {
               [self SaveDaliyReport:dr IsLast:isLastValue Delegate:appD];
            }

            //end
        }
        if (listOfDR.count == 0)
        {
            [Common saveUnsavedCrewsToWebService];
            
            for (EquipmentObject *equipmentObject in [appD.eSubsDB getSavedEquipmentObjects:appD.userId])
            {
//                [Common saveUnsavedEquipmentToWebService:equipmentObject];
                  [Common saveUnsavedEquipmentToWebService:equipmentObject
                                               success:^(id responseObject) {
                                               }
                                               failure:^(NSError *error){
                                               }];

            }
            
            for (UploadObject *uploadObject in [appD.eSubsDB getUnsavedUploadAttachmentPhotoObjects:appD.userId])
            {
                [Common saveUNsavedUploadAttachmentsPhotosToWebService:uploadObject];
            }
        }
        
//        NSString *errorDesc = [NSString stringWithFormat:@"local stored data will now be uploaded, please check back in a few minutes."];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorDesc message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }

}

-(void) SaveDaliyReport:(DailyReportObject *) dr IsLast:(BOOL)isLastvalue Delegate:(AppDelegate *) appD
{
    [Common saveDailyReportToWebService:dr isLast:isLastvalue
                                success:^(id responseObject)
     {
         NSMutableArray *crewList = [appD.eSubsDB getCrewObjects:dr.projectId forDailyReportId:dr.drCopyId];
         NSMutableArray *c = [Common buildExistingCrewRows:crewList];
         
         if (c.count > 0)
         {
             [Common saveCrewsToWebService:c forProjectId:dr.projectId forDRId:[[responseObject objectForKey:@"Id"] integerValue] forDate:dr.date forId:-1
                                   success:^(id responseObject)
              {
              }
                                   failure:^(NSError *error)
              {
              }];
         }
         NSMutableArray *listOfEquipment = [appD.eSubsDB getEquipmentObjects:appD.userId forProjectId:dr.projectId andDailyReportId:dr.drCopyId];
         for (EquipmentObject *e in listOfEquipment)
         {
             e.id = 0;
             e.dailyReportId = [[responseObject objectForKey:@"Id"] integerValue];
             [Common saveUnsavedEquipmentToWebService:e
                                              success:^(id responseObject) {
                                              }
                                              failure:^(NSError *error){
                                              }];
         }
         
         // to do add local data to server.
         NSMutableArray *getListUnSaveToServer = [appD.eSubsDB getFlagMaterialObjects:dr.projectId];
         for (MaterialsObject *obj in getListUnSaveToServer) {
             obj.id = 0;
             obj.dailyReportId =[[responseObject objectForKey:@"Id"] integerValue];
             [Common SaveMaterial:obj dailyReportId:obj.dailyReportId
                          success:^(id responseObject)
              {
                  [appD.eSubsDB updateProjectMaterialObjectFlag:obj forProjectId:dr.projectId];
              }
                          failure:^(NSError *error)
              {
              }];
         }
         
     }
                                failure:^(NSError *error)
     {
     }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CoreLocation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
        
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"gps"];
    [defaults synchronize];
    
    NSLog(@"didFailWithError: %@", error);
    
// LTS removed 4-17-2014

//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
    
}
@end
