//
//  Common.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/15/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "Common.h"
#import "Constants.h"
#import "SaveNoteAFHTTPClient.h"
#import "ImageUploadAFHTTPClient.h"
#import "AppDelegate.h"
#import "NoteAFHTTPClient.h"
#import "WeatherAFHTTPClient.h"
#import "DailyReportObject.h"

@implementation Common
{
    
}

+ (NSMutableArray *) buildExistingCrewRows:(NSMutableArray *) crewList
{
    
    NSMutableArray *crews = [[NSMutableArray alloc] init];
    NSArray *crewIds = [crewList valueForKeyPath:@"@distinctUnionOfObjects.crewId"];
    
    for (id cc in crewIds)
    {
        NSMutableDictionary *crew = [NSMutableDictionary dictionary];
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        for (CrewObject *co in crewList)
        {
            if (co.crewId == [cc intValue])
            {
                [crew setObject:[NSNumber numberWithInteger:co.crewId] forKey:@"crewId"];
                [crew setObject:[NSNumber numberWithInteger:co.phaseId] forKey:@"systemPhase"];
                [crew setObject:[NSNumber numberWithInteger:co.laborActivityId] forKey:@"laborActivity"];
                [crew setObject:[NSNumber numberWithInteger:co.workTypeId] forKey:@"workType"];
                [crew setObject:[NSNumber numberWithFloat:co.totalUnits] forKey:@"totalUnits"];
                
                NSMutableDictionary *row = [NSMutableDictionary dictionary];
                [row setObject:[NSNumber numberWithFloat:co.hoursST] forKey:@"hoursST"];
                [row setObject:[NSNumber numberWithFloat:co.hoursOT] forKey:@"hoursOT"];
                [row setObject:[NSNumber numberWithFloat:co.hoursDT] forKey:@"hoursDT"];
                [row setObject:[NSNumber numberWithFloat:co.hoursLost] forKey:@"hoursLost"];
                [row setObject:[NSNumber numberWithFloat:co.units] forKey:@"units"];
                if (co.comments)
                {
                    [row setObject:co.comments forKey:@"comments"];
                }
                else
                {
                    [row setObject:@"" forKey:@"comments"];
                }
                [row setObject:[NSNumber numberWithInteger:1] forKey:@"crewNumber"];
                NSMutableArray *crewMembers = [[NSMutableArray alloc] init];
                [crewMembers addObject:[NSNumber numberWithInteger:co.employeeId]];
                [row setObject:crewMembers forKey:@"crewMembers"];
                [rows addObject:row];
            }
        }
        [crew setObject:rows forKey:@"rows"];
        [crews addObject:crew];
    }
    
    return crews;
    
}

+ (NSData *) createThumbNail: (UIImage *) mainImage
{
    UIImage *thumbnail;
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
    BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
    float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
    CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
    //creating a square context the size of the final image which we will then
    // manipulate and transform before drawing in the original image
    UIGraphicsBeginImageContext(CGSizeMake(64, 64));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextClipToRect( currentContext, clippedRect);
    CGFloat scaleFactor = 64/sideFull;
    if (widthGreaterThanHeight)
    {
        //a landscape image – make context shift the original image to the left when drawn into the context
        //        CGContextTranslateCTM(currentContext, -((mainImage.size.width – sideFull) / 2) * scaleFactor, 0);
        CGContextTranslateCTM(currentContext, -((mainImage.size.width - sideFull) /2)* scaleFactor, 0);
    }
    else
    {
        //a portfolio image – make context shift the original image upwards when drawn into the context
        //        CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height – sideFull) / 2) * scaleFactor);
        CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height - sideFull) /2) * scaleFactor);
    }
    //this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
    CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
    [mainImageView.layer renderInContext:currentContext];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(thumbnail);
    
    return imageData;
    
}

+ (void) saveNoteImageToWebService: (NoteObject *) note
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    UIImage *img = [appD.eSubsDB getNoteImage:note.noteImages[0]];
    NSData *imageData = [Common createThumbNail:img];
    
    [note.noteThumbNails addObject:[NSNumber numberWithLong:[appD.eSubsDB insertNoteThumbNail:imageData]]];
    
    ImageUploadAFHTTPClient *client = [ImageUploadAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNull null] forKey:@"Id"];
    [data setObject:[NSNumber numberWithInteger:note.projectId] forKey:@"ProjectId"];
    [data setObject:@"Note" forKey:@"DocumentType"];
    [data setObject:[NSNumber numberWithInteger:note.id] forKey:@"DocumentId"];
    [data setObject:@"Description" forKey:@"Description"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                     path:@"Upload"
                                                               parameters:nil
                                                constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                    {
                                        [formData appendPartWithFileData:[appD.eSubsDB getNoteImageData:note.noteImages[0]] name:@"binaryData" fileName:@"file.png" mimeType:@"image/png"];
                                        [formData appendPartWithFormData:jsonData name:@"data"];
                                    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
    [client enqueueHTTPRequestOperation:operation];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];

         NSInteger projectId = 0;
         NSInteger notetId = 0;
         NSString *date = @"";
         NSArray *data = [jsonObject objectForKey:@"Document"];
         for (NSDictionary *doc in data)
         {
             NSLog(@" data : %@", doc);

             if ([doc objectForKey:@"Id"] != [NSNull null])
             {
                 notetId = (NSUInteger )[[doc objectForKey:@"Id"] intValue];
             }

             if ([doc objectForKey:@"ProjectId"] != [NSNull null])
             {
                 projectId = (NSUInteger )[[doc objectForKey:@"ProjectId"] intValue];
             }
             if ([doc objectForKey:@"Date"] != [NSNull null])
             {
                 date = [doc objectForKey:@"Date"];
             }
         }
         
         [appD.eSubsDB updateNoteObject:projectId andNoteId:notetId forUserID:appD.userId withDate:date];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error saveNoteImageToWebService: %@", operation.responseString);
         NSLog(@"%@",error);
     }];
    [operation start];

}

+ (void) saveDailyReportToWebService: (DailyReportObject *) dr success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNumber numberWithInteger:dr.projectId] forKey:@"ProjectId"];

// LTS - 2/10/2-15 remove once date field is changed to GMT
/*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:dr.date];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    [data setObject:[formatter stringFromDate:date] forKey:@"drDate"];
*/
    [data setObject:dr.date forKey:@"drDate"];
    [data setObject:[NSNumber numberWithInteger:dr.employeeFromId] forKey:@"drFrom"];
    if (dr.windId != 0)
    {
        [data setObject:[NSNumber numberWithInteger:dr.windId] forKey:@"Wind"];
        [data setObject:[NSNumber numberWithInteger:dr.weatherId] forKey:@"Weather"];
        [data setObject:[NSNumber numberWithInteger:dr.temperature] forKey:@"Temperature"];
    }
    
    if (dr.weatherIcon)
    {
        [data setObject:dr.weatherIcon forKey:@"WeatherIconValue"];
    }
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"DR" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            success(JSON);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(error);
        }];
    
    [operation start];
    
}

+ (void) saveUnsavedCrewsToWebService
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    NSMutableArray *cr = [appD.eSubsDB getUnsavedCrewObjects:appD.userId];
    for (CrewObject *crew in cr)
    {
        NSMutableArray *crewList = [appD.eSubsDB getUnsavedCrewObjects:appD.userId forProjectId:crew.projectId forDRId:crew.dailyReportId];
        
        for (CrewObject *obj in crewList) {
            obj.crewId = obj.id;
        }
        
        NSMutableArray *c = [Common buildExistingCrewRows:crewList];
        
        [Common saveCrewsToWebService:c forProjectId:crew.projectId forDRId:crew.dailyReportId forDate:crew.drDate forId:0
         success:^(id responseObject)
         {
             // 3-2-2014 Need to check for copyDR
         }
         failure:^(NSError *error)
         {
             
         }];    }
}

+ (void) saveUnsavedEquipmentToWebService:(EquipmentObject *) equipmentObject success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *equipment = [NSMutableDictionary dictionary];
    NSMutableArray *equipmentArray = [[NSMutableArray alloc] init];
    
    [equipment setObject:[NSNumber numberWithInteger:equipmentObject.equipmentId] forKey:@"equipmentId"];
    [equipment setObject:[NSNumber numberWithFloat:equipmentObject.hours] forKey:@"equipmentHours"];
    [equipment setObject:equipmentObject.useageDesc forKey:@"equipmentNotes"];
    
    [data setObject:[NSNumber numberWithInteger:equipmentObject.dailyReportId] forKey:@"dailyReportId"];
    [equipmentArray addObject:equipment];
    [data setObject:equipmentArray forKey:@"equipment"];
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Equipment" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            [appD.eSubsDB deleteUnsavedEquipmentObject:equipmentObject.id];
            success(JSON);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(error);
        }];
    
    [operation start];
    
}

+ (void) saveDailyReportToWebService: (DailyReportObject *) dr isLast: (BOOL) last success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNumber numberWithInteger:dr.projectId] forKey:@"ProjectId"];
/*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:dr.date];
    [formatter setDateFormat:@"MM/dd/yy"];
    [data setObject:[formatter stringFromDate:date] forKey:@"drDate"];
*/
    [data setObject:dr.date forKey:@"drDate"];
    [data setObject:[NSNumber numberWithInteger:dr.employeeFromId] forKey:@"drFrom"];
    if (dr.windId != 0)
    {
        [data setObject:[NSNumber numberWithInteger:dr.windId] forKey:@"Wind"];
        [data setObject:[NSNumber numberWithInteger:dr.weatherId] forKey:@"Weather"];
        [data setObject:[NSNumber numberWithInteger:dr.temperature] forKey:@"Temperature"];
    }

    if (dr.weatherIcon)
    {
        [data setObject:dr.weatherIcon forKey:@"WeatherIconValue"];
    }

    NSMutableDictionary *comments = [NSMutableDictionary dictionary];
    
    if (dr.communicationWithOthers)
    {
        [comments setObject:dr.communicationWithOthers forKey:@"CommunicationWithOthers"];
    }
    else
    {
        [comments setObject:@"" forKey:@"CommunicationWithOthers"];
    }
    
    if (dr.scheduleCoordination)
    {
        [comments setObject:dr.scheduleCoordination forKey:@"ScheduleCoordination"];
    }
    else
    {
        [comments setObject:@"" forKey:@"ScheduleCoordination"];
    }
    
    NSMutableDictionary *extraWork = [NSMutableDictionary dictionary];
    if (dr.extraWork)
    {
        [extraWork setObject:dr.extraWork forKey:@"Comment"];
        [extraWork setObject:[NSNumber numberWithInteger:dr.extraWorkIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [extraWork setObject:@""forKey:@"Comment"];
        [extraWork setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:extraWork forKey:@"ExtraWork"];
    
    NSMutableDictionary *accidentReport = [NSMutableDictionary dictionary];
    if (dr.accidentReport)
    {
        [accidentReport setObject:dr.accidentReport forKey:@"Comment"];
        [accidentReport setObject:[NSNumber numberWithInteger:dr.accidentReportIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [accidentReport setObject:@"" forKey:@"Comment"];
        [accidentReport setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:accidentReport forKey:@"AccidentReport"];
    
    NSMutableDictionary *subcontractors = [NSMutableDictionary dictionary];
    if (dr.subcontractors)
    {
        [subcontractors setObject:dr.subcontractors forKey:@"Comment"];
        [subcontractors setObject:[NSNumber numberWithInteger:dr.subcontractorsIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [subcontractors setObject:@"" forKey:@"Comment"];
        [subcontractors setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:subcontractors forKey:@"Subcontractors"];
    
    NSMutableDictionary *otherVisitors = [NSMutableDictionary dictionary];
    if (dr.otherVisitors)
    {
        [otherVisitors setObject:dr.otherVisitors forKey:@"Comment"];
        [otherVisitors setObject:[NSNumber numberWithInteger:dr.otherVisitorsIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [otherVisitors setObject:@"" forKey:@"Comment"];
        [otherVisitors setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:otherVisitors forKey:@"OtherVisitors"];
    
    NSMutableDictionary *problems = [NSMutableDictionary dictionary];
    if (dr.problems)
    {
        [problems setObject:dr.problems forKey:@"Comment"];
        [problems setObject:[NSNumber numberWithInteger:dr.problemsIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [problems setObject:@"" forKey:@"Comment"];
        [problems setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:problems forKey:@"Problems"];
    
    if (dr.internal)
    {
        [comments setObject:dr.internal forKey:@"Internal"];
    }
    else
    {
        [comments setObject:@"" forKey:@"Internal"];
    }
    
    [data setObject:comments forKey:@"Comments"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"DR" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            [appD.eSubsDB deleteDailyReport:dr.projectId forUserID:appD.userId forDRId:dr.id];
            
            NSInteger newDRId = [[JSON objectForKey:@"Id"] integerValue];
            [appD.eSubsDB updateCrewObjectWithNewDRId:newDRId forOldDRIdId:dr.id];
            [appD.eSubsDB updateEquipmentObjectWithNewDRId:newDRId forOldDRIdId:dr.id];
            [appD.eSubsDB updateUploadObjecstWithNewDRId:newDRId forOldDRIdId:dr.id];
            
            if (last)
            {
                [self saveUnsavedCrewsToWebService];
                AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
                for (EquipmentObject *equipmentObject in [appD.eSubsDB getSavedEquipmentObjects:appD.userId])
                {
//                    [self saveUnsavedEquipmentToWebService:equipmentObject];
                    [self saveUnsavedEquipmentToWebService:equipmentObject
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
            success(JSON);
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(error);
        }];
    
    [operation start];

}

+ (void) saveCrewsToWebService: (NSMutableArray *) crewLists
                  forProjectId:(NSInteger) projectId
                       forDRId: (NSInteger) DRId
                       forDate: (NSString *) drDate
                         forId: (NSInteger) saveId
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNumber numberWithInteger:projectId] forKey:@"ProjectId"];
    [data setObject:[NSNumber numberWithInteger:DRId] forKey:@"dailyReportId"];
    [data setObject:drDate forKey:@"drDate"];
    [data setObject:crewLists forKey:@"crews"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Crew" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            if (saveId == 0)
            {
                [appD.eSubsDB deleteSavedCrewObject:projectId forDRId:DRId];
            }
            else if (saveId > 0)
            {
                [appD.eSubsDB deleteCrewObject:projectId forDailyReportId:saveId];
            }
            success(JSON);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(error);
        }];
    
    [operation start];
    
}

+ (void) editNoteToWebService: (NoteObject *) note usingUUID: (NSString *) uuid
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNumber numberWithInteger:note.id] forKey:@"Id"];
    
    [data setObject:note.notetitle forKey:@"Text"];
    [data setObject:[NSNumber numberWithInteger:note.projectId] forKey:@"ProjectId"];
    [data setObject:[NSNull null] forKey:@"Attachments"];
    NSMutableDictionary *geolocation = [NSMutableDictionary dictionary];
    [geolocation setObject:[NSNumber numberWithDouble:note.noteLocation.location.latitude] forKey:@"Latitude"];
    [geolocation setObject:[NSNumber numberWithDouble:note.noteLocation.location.longitude] forKey:@"Longtitude"];
    
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    if (note.noteLocation.address.address1 != nil)
    {
        [address setObject:note.noteLocation.address.address1 forKey:@"Address1"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Address1"];
    }
    if (note.noteLocation.address.address2 != nil)
    {
        [address setObject:note.noteLocation.address.address2 forKey:@"Address2"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Address2"];
    }
    if (note.noteLocation.address.city != nil)
    {
        [address setObject:note.noteLocation.address.city forKey:@"City"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"City"];
    }
    if (note.noteLocation.address.state != nil)
    {
        [address setObject:note.noteLocation.address.state forKey:@"State"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"State"];
    }
    if (note.noteLocation.address.zip != nil)
    {
        [address setObject:note.noteLocation.address.zip forKey:@"Zip"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Zip"];
    }
    if (note.noteLocation.address.country != nil)
    {
        [address setObject:note.noteLocation.address.country forKey:@"Country"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Country"];
    }
    
    NSMutableDictionary *location = [NSMutableDictionary dictionary];
    
    [location setObject:address forKey:@"Address"];
    [location setObject:geolocation forKey:@"Geolocation"];
    
    [data setObject:location forKey:@"Location"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    [params setObject:uuid forKey:@"RequestUid"];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld", (long)note.id]];
    if (str.length == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:[NSString stringWithFormat:@"%ld", (long)note.id]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:@"Notes" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%ld", (long)note.id]];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             if (note.noteImages.count)
                                             {
                                                 note.noteDate = @"The image for this note has not been saved";
                                                 [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId];
                                                 [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                                                 [self saveNoteImageToWebService:note];
                                             }
                                             else
                                             {
                                                 note.noteDate = [JSON objectForKey:@"Date"];
                                                 [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId];
                                                 [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                                             }
                                         }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             NSLog(@"error saveNoteToWebService: %@", error.localizedDescription);
                                             NSLog(@"%@",error);
                                             
                                             if ([JSON objectForKey:@"exception"] != [NSNull null])
                                             {
                                                 NSDictionary *mdata = [JSON objectForKey:@"exception"];
                                                 if ([[mdata objectForKey:@"number"] integerValue] == 409 && [[mdata objectForKey:@"message"] isEqualToString:@"Duplicate entry detected"])
                                                 {
                                                     NSDictionary *ndata = [mdata objectForKey:@"data"];
                                                     NSString *id = [ndata objectForKey:@"Id"];
                                                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:id];
                                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                                     if (note.noteImages.count)
                                                     {
                                                         note.noteDate = @"The image for this note has not been saved";
                                                         [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId];
                                                         [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                                                         [self saveNoteImageToWebService:note];
                                                     }
                                                     else
                                                     {
                                                         note.noteDate = [ndata objectForKey:@"DateCommitted"];
                                                         [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId];
                                                         [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                                                     }

                                                 }
                                             }
                                         }];
    
    [operation start];
    
}

+ (void) saveNoteToWebService: (NoteObject *) note usingUUID: (NSString *) uuid
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    //appD.eSUBServerURL =@"http://api.esub.localhost/v2/";
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:note.notetitle forKey:@"Text"];
    [data setObject:[NSNumber numberWithInteger:note.projectId] forKey:@"ProjectId"];
    [data setObject:[NSNull null] forKey:@"Attachments"];
    NSMutableDictionary *geolocation = [NSMutableDictionary dictionary];
    [geolocation setObject:[NSNumber numberWithDouble:note.noteLocation.location.latitude] forKey:@"Latitude"];
    [geolocation setObject:[NSNumber numberWithDouble:note.noteLocation.location.longitude] forKey:@"Longtitude"];
    
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    if (note.noteLocation.address.address1 != nil)
    {
        [address setObject:note.noteLocation.address.address1 forKey:@"Address1"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Address1"];
    }
    if (note.noteLocation.address.address2 != nil)
    {
        [address setObject:note.noteLocation.address.address2 forKey:@"Address2"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Address2"];
    }
    if (note.noteLocation.address.city != nil)
    {
        [address setObject:note.noteLocation.address.city forKey:@"City"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"City"];
    }
    if (note.noteLocation.address.state != nil)
    {
        [address setObject:note.noteLocation.address.state forKey:@"State"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"State"];
    }
    if (note.noteLocation.address.zip != nil)
    {
        [address setObject:note.noteLocation.address.zip forKey:@"Zip"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Zip"];
    }
    if (note.noteLocation.address.country != nil)
    {
        [address setObject:note.noteLocation.address.country forKey:@"Country"];
    }
    else
    {
        [address setObject:[NSNull null] forKey:@"Country"];
    }
    
    NSMutableDictionary *location = [NSMutableDictionary dictionary];
    
    [location setObject:address forKey:@"Address"];
    [location setObject:geolocation forKey:@"Geolocation"];
    
    [data setObject:location forKey:@"Location"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    [params setObject:uuid forKey:@"RequestUid"];

    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld", (long)note.id]];
    if (str.length == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:[NSString stringWithFormat:@"%ld", (long)note.id]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Notes" parameters:params];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%ld", (long)note.id]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSInteger oldNoteId = note.id;
            note.id = [[JSON objectForKey:@"Id"] integerValue];

            note.projectId = [[JSON objectForKey:@"ProjectId"] integerValue];
                                             
            if (note.noteImages.count)
            {
                note.noteDate = @"The image for this note has not been saved";
                [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:oldNoteId forUserID:appD.userId];
                [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                [self saveNoteImageToWebService:note];
            }
            else
            {
                note.noteDate = [JSON objectForKey:@"Date"];
                [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:oldNoteId forUserID:appD.userId];
                [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
            }
        
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            NSLog(@"error saveNoteToWebService: %@", error.localizedDescription);
            NSLog(@"%@",error);

            if ([JSON objectForKey:@"exception"] != [NSNull null])
            {
                NSDictionary *mdata = [JSON objectForKey:@"exception"];
                if ([[mdata objectForKey:@"number"] integerValue] == 409 && [[mdata objectForKey:@"message"] isEqualToString:@"Duplicate entry detected"])
                {
                    NSInteger oldNoteId = note.id;
                    NSDictionary *ndata = [mdata objectForKey:@"data"];
                    NSString *id = [ndata objectForKey:@"Id"];
                    note.id = [id integerValue];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:id];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if (note.noteImages.count)
                    {
                        note.noteDate = @"The image for this note has not been saved";
                        [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:oldNoteId forUserID:appD.userId];
                        [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                        [self saveNoteImageToWebService:note];
                    }
                    else
                    {
                        note.noteDate = [ndata objectForKey:@"DateCommitted"];
                        [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:oldNoteId forUserID:appD.userId];
                        [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                    }
                }
            }
        }];
    
    [operation start];

}

+ (NSString *) makeAddress: (NoteAddress *) noteAddress
{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    if (noteAddress != (id)[NSNull null])
    {
        if (noteAddress.address1 != (id)[NSNull null] && noteAddress.address1.length > 0)
        {
            [str appendString:[NSString stringWithFormat:@"%@\n", noteAddress.address1]];
        }
        if (noteAddress.address2 != (id)[NSNull null] && noteAddress.address2.length > 0)        {
            [str appendString:[NSString stringWithFormat:@"%@\n", noteAddress.address2]];
        }
        if (noteAddress.city != (id)[NSNull null] && noteAddress.city.length > 0)
        {
            [str appendString:[NSString stringWithFormat:@"%@ ", noteAddress.city]];
        }
        if (noteAddress.state != (id)[NSNull null] && noteAddress.state.length > 0)
        {
            [str appendString:[NSString stringWithFormat:@",%@ ", noteAddress.state]];
        }
        if (noteAddress.zip != (id)[NSNull null] && noteAddress.zip.length > 0)
        {
            [str appendString:[NSString stringWithFormat:@"%@", noteAddress.zip]];
        }
        if (noteAddress.country != (id)[NSNull null] && noteAddress.country.length > 0)
        {
            [str appendString:[NSString stringWithFormat:@"\n%@", noteAddress.country]];
        }
        
    }
    
    return str;
    
}

+ (UIImage *)scaleImage:(UIImage*)sourceImage toSize:(CGSize)targetSize
{
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    //    int kMaxResolution = 640; // Or whatever
    int kMaxResolution = 960;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (NSString *)urlEncodeValue:(NSString *)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    return result;
}

+ (void)GetListOfContacts:(int) projectId success:(void (^)(NSMutableArray *contacts))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
//    @"http://api.qa.esubonline.com/v2/"
    NSString  *contactWeburl = [appD.eSUBServerURL stringByReplacingOccurrencesOfString:@"api" withString:@"webapi"];
    contactWeburl = [contactWeburl stringByReplacingOccurrencesOfString:@"v2" withString:@"api"];
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:contactWeburl]];
    NSLog(@"subserver url:%@",appD.eSUBServerURL);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:projectId]  forKey:@"ProjectId"];
    //    [params setObject:@"object"  forKey:@"Type"];
    
//    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Contacts/projectId/" parameters:params];

     NSURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"Contacts/projectId/%@",[NSNumber numberWithInt:projectId]] parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            NSArray *data = responseObject;//[responseObject objectForKey:@"data"];
            if (data.count)
            {
                
                NSMutableArray *contacts = [[NSMutableArray alloc] init];
                for (NSDictionary *mdata in data)
                {
                    ContactsObject *contact = [[ContactsObject alloc] init];
                    if ([mdata objectForKey:@"Id"] != [NSNull null])
                    {
                        contact.id = [[mdata objectForKey:@"Id"] intValue];
                    }
                    if ([mdata objectForKey:@"FirstName"] != [NSNull null])
                    {
                        contact.contactFirstname = [mdata objectForKey:@"FirstName"];
                    }
                    if ([mdata objectForKey:@"LastName"] != [NSNull null])
                    {
                        contact.contactLastname = [mdata objectForKey:@"LastName"];
                    }
                    if ([mdata objectForKey:@"Company"] != [NSNull null])
                    {
                        contact.contactCompany = [mdata objectForKey:@"Company"];
                    }
                    if ([mdata objectForKey:@"AddressId"] != [NSNull null])
                    {
                        contact.AddressId = [[mdata objectForKey:@"AddressId"] intValue];
                    }
                    contact.contactAddresses = [[NSMutableArray alloc] init];
                    for (NSDictionary *ndata in [mdata objectForKey:@"Addresses"])
                    {
                        ContactAddressObject *contactAddresses = [[ContactAddressObject alloc] init];
                        if ([ndata objectForKey:@"Address"] != [NSNull null])
                        {
                            NSDictionary *ad = [ndata objectForKey:@"Address"];
                            NoteAddress *address = [[NoteAddress alloc] init];
                            if ([ad objectForKey:@"Address1"] != [NSNull null])
                            {
                                address.address1 = [ad objectForKey:@"Address1"];
                            }
                            if ([ad objectForKey:@"Address2"] != [NSNull null])
                            {
                                address.address2 = [ad objectForKey:@"Address2"];
                            }
                            if ([ad objectForKey:@"City"] != [NSNull null])
                            {
                                address.city = [ad objectForKey:@"City"];
                            }
                            if ([ad objectForKey:@"State"] != [NSNull null])
                            {
                                address.state = [ad objectForKey:@"State"];
                            }
                            if ([ad objectForKey:@"Zip"] != [NSNull null])
                            {
                                address.zip = [ad objectForKey:@"Zip"];
                            }
                            if ([ad objectForKey:@"County"] != [NSNull null])
                            {
                                address.country = [ad objectForKey:@"Country"];
                            }
                            contactAddresses.address = address;
                        }
                        if ([ndata objectForKey:@"Phone"] != [NSNull null])
                        {
                            contactAddresses.phone = [ndata objectForKey:@"Phone"];
                        }
                        if ([ndata objectForKey:@"Fax"] != [NSNull null])
                        {
                            contactAddresses.fax = [ndata objectForKey:@"Fax"];
                        }
                        if ([ndata objectForKey:@"Mobile"] != [NSNull null])
                        {
                            contactAddresses.mobile = [ndata objectForKey:@"Mobile"];
                        }
                        if ([ndata objectForKey:@"Pager"] != [NSNull null])
                        {
                            contactAddresses.pager = [ndata objectForKey:@"Pager"];
                        }
                        if ([ndata objectForKey:@"TollFree"] != [NSNull null])
                        {
                            contactAddresses.tollFree = [ndata objectForKey:@"TollFree"];
                        }
                        if ([ndata objectForKey:@"Home"] != [NSNull null])
                        {
                            contactAddresses.home = [ndata objectForKey:@"Home"];
                        }
                        if ([ndata objectForKey:@"Email"] != [NSNull null])
                        {
                            contactAddresses.email = [ndata objectForKey:@"Email"];
                        }
                        if ([ndata objectForKey:@"Website"] != [NSNull null])
                        {
                            contactAddresses.website = [ndata objectForKey:@"Website"];
                        }
                        if ([ndata objectForKey:@"Type"] != [NSNull null])
                        {
                            contactAddresses.type = [ndata objectForKey:@"Type"];
                        }
                        [contact.contactAddresses addObject:contactAddresses];
                    }
                    [contacts addObject:contact];
                }
                success(contacts);
            }

        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(response, error);
        }];
    
    [operation start];
    
}

+ (void)GetWeather:(NSString *)zipCode success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{

    WeatherAFHTTPClient *client = [WeatherAFHTTPClient sharedClient:[NSURL URLWithString:@"http://api.worldweatheronline.com/premium/v1/weather.ashx"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:zipCode forKey:@"q"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"1extra=localObsTime" forKey:@"num_of_days"];
    [params setObject:@"yes" forKey:@"includeLocation"];
    [params setObject:@"y5bem3d6f2szrvaccxsgg9c5" forKey:@"key"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            success(responseObject);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(error);
        }];
    
    [operation start];

}

+ (void)GetPastWeather:(NSString *)zipCode forDate: (NSString *) date success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    WeatherAFHTTPClient *client = [WeatherAFHTTPClient sharedClient:[NSURL URLWithString:@"http://api.worldweatheronline.com/premium/v1/past-weather.ashx"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:zipCode forKey:@"q"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"no" forKey:@"cc"];
    [params setObject:date forKey:@"date"];
    [params setObject:@"y5bem3d6f2szrvaccxsgg9c5" forKey:@"key"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            success(responseObject);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(error);
        }];
    
    [operation start];
    
}

+ (void) CopyCrewEquipmentMatieralsForDailyReport:(NSInteger) projectId
                                    dailyReportId:(NSInteger) drId
                                  dailyReportDate:(NSString *) drDate
                                copyDailyReportId: (NSInteger) copyDRId
                                         complete:(void(^)())completionBlock
{

    [self getListOfCrew:projectId dailyReportId:copyDRId
        success:^(id responseObject)
        {
            NSMutableArray *crewList = [Common buildExistingCrewRows:responseObject];
            [self copyCrewForDailyReport:projectId dailyReportId:drId dailyReportDate:drDate crewList:crewList];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error)
        {
        }];

    [self getListOfEquipment:projectId dailyReportId:copyDRId
        success:^(id responseObject)
        {
            NSMutableArray *listOfEquipment = responseObject;
            [self copyEquipmentForDailyReport:projectId dailyReportId:drId dailyReportDate:drDate listOfEquipment:listOfEquipment];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error)
        {
        }];

    completionBlock();

}

+ (void) copyEquipmentForDailyReport:(NSInteger) projectId dailyReportId:(NSInteger) drId dailyReportDate:(NSString *) drDate listOfEquipment:(NSMutableArray *) listOfEquipment
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableArray *equipmentArray = [[NSMutableArray alloc] init];
    
    
    for (EquipmentObject *e in listOfEquipment)
    {
        NSMutableDictionary *equipment = [NSMutableDictionary dictionary];
        [equipment setObject:[NSNumber numberWithInteger:e.equipmentId] forKey:@"equipmentId"];
        [equipment setObject:[NSNumber numberWithFloat:e.hours] forKey:@"equipmentHours"];
        [equipment setObject:e.useageDesc forKey:@"equipmentNotes"];
        [equipmentArray addObject:equipment];
    }
    
    [data setObject:equipmentArray forKey:@"equipment"];
    
    [data setObject:[NSNumber numberWithInteger:drId] forKey:@"dailyReportId"];
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *r = [client requestWithMethod:@"POST" path:@"Equipment" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:r
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
                                             
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {

        }];
    
    [operation start];

}

+ (void) getListOfEquipment:(NSInteger) projectId dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:[NSNumber numberWithInt:(int)projectId]  forKey:@"projectID"];
    [params setObject:[NSNumber numberWithInt:(int)drId]  forKey:@"dailyReportId"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Equipment" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            NSMutableArray *listOfEquipment = [[NSMutableArray alloc] init];
            [appD.eSubsDB deleteUnsavedEquipmentObjects:appD.userId forProjectId:projectId forDailyReportId:drId];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                for (NSDictionary *mdata in data)
                {
                    EquipmentObject *equipment = [[EquipmentObject alloc] init];
                    if ([mdata objectForKey:@"EquipmentID"] != [NSNull null])
                    {
                        equipment.equipmentId = [[mdata objectForKey:@"EquipmentID"] integerValue];
                    }
                    if ([mdata objectForKey:@"DREquipmentId"] != [NSNull null])
                    {
                        equipment.drEquipmentId = [[mdata objectForKey:@"DREquipmentId"] integerValue];
                    }
                    if ([mdata objectForKey:@"Equipment"] != [NSNull null])
                    {
                        equipment.equipment = [mdata objectForKey:@"Equipment"];
                    }
                    if ([mdata objectForKey:@"Code"] != [NSNull null])
                    {
                        equipment.code = [mdata objectForKey:@"Code"];
                    }
                    if ([mdata objectForKey:@"Asset"] != [NSNull null])
                    {
                        equipment.asset = [[mdata objectForKey:@"Asset"] integerValue];
                    }
                    if ([mdata objectForKey:@"DREquipmentHours"] != [NSNull null])
                    {
                        equipment.hours = [[mdata objectForKey:@"DREquipmentHours"] floatValue];
                    }
                    if ([mdata objectForKey:@"DREquipmentUseageDesc"] != [NSNull null])
                    {
                        equipment.useageDesc = [mdata objectForKey:@"DREquipmentUseageDesc"];
                    }
                    if ([mdata objectForKey:@"DREquipmentSite"] != [NSNull null])
                    {
                        equipment.site = [[mdata objectForKey:@"DREquipmentSite"] integerValue];
                    }
                    if ([mdata objectForKey:@"DREquipmentUser"] != [NSNull null])
                    {
                        equipment.user = [[mdata objectForKey:@"DREquipmentUser"] integerValue];
                    }
                    
//                    [listOfEquipment addObject:equipment];
                    [appD.eSubsDB insertEquipmentObject:equipment forUser:appD.userId forProjectId:projectId andDailyReportId:drId];
                }
                listOfEquipment = [appD.eSubsDB getEquipmentObjects:appD.userId forProjectId:projectId andDailyReportId:drId];
            }
            success(listOfEquipment);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(response, error);
        }];
    
    [operation start];
    
}

+ (void) copyCrewForDailyReport:(NSInteger) projectId dailyReportId:(NSInteger) drId dailyReportDate:(NSString *) drDate crewList:(NSMutableArray *) crewList
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *c = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNumber numberWithInteger:projectId] forKey:@"ProjectId"];
    [data setObject:[NSNumber numberWithInteger:drId] forKey:@"dailyReportId"];
    [data setObject:drDate forKey:@"drDate"];
    
    [data setObject:crewList  forKey:@"crews"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [c requestWithMethod:@"POST" path:@"Crew" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {

        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {

        }];
    [operation start];

}

+ (void) getListOfCrew:(NSInteger) projectId dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    //    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)projectId]  forKey:@"projectID"];
    [params setObject:[NSNumber numberWithInt:(int)drId]  forKey:@"dailyReportId"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Crew" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            NSMutableArray *crewList = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                NSArray *crewArray = [data objectAtIndex:0];
                if (crewArray)
                {
                    [appD.eSubsDB deleteUnsavedCrewObject:projectId forId:drId];
                    for (NSDictionary *mdata in crewArray)
                    {
                        CrewObject *crew = [[CrewObject alloc] init];
                        if ([mdata objectForKey:@"Id"] != [NSNull null])
                        {
                            crew.id = [[mdata objectForKey:@"Id"] integerValue];
                        }
                        if ([mdata objectForKey:@"CrewId"] != [NSNull null])
                        {
                            crew.crewId = [[mdata objectForKey:@"CrewId"] integerValue];
                        }
                        if ([mdata objectForKey:@"DaliyReportId"] != [NSNull null])
                        {
                            crew.dailyReportId = [[mdata objectForKey:@"DailyReportId"] integerValue];
                        }
                        if ([mdata objectForKey:@"CrewMemberId"] != [NSNull null])
                        {
                            crew.crewMemberId = [[mdata objectForKey:@"CrewMemberId"] integerValue];
                        }
                        if ([mdata objectForKey:@"EmployeeId"] != [NSNull null])
                        {
                            crew.employeeId = [[mdata objectForKey:@"EmployeeId"] integerValue];
                        }
                        if ([mdata objectForKey:@"LaborClassId"] != [NSNull null])
                        {
                            crew.laborClassId = [[mdata objectForKey:@"LaborClassId"] integerValue];
                        }
                        if ([mdata objectForKey:@"LineNumber"] != [NSNull null])
                        {
                            crew.lineNumber = [[mdata objectForKey:@"LineNumber"] integerValue];
                        }
                        if ([mdata objectForKey:@"HoursST"] != [NSNull null])
                        {
                            crew.hoursST = [[mdata objectForKey:@"HoursST"] doubleValue];
                        }
                        if ([mdata objectForKey:@"HoursOT"] != [NSNull null])
                        {
                            crew.hoursOT = [[mdata objectForKey:@"HoursOT"] doubleValue];
                        }
                        if ([mdata objectForKey:@"HoursDT"] != [NSNull null])
                        {
                            crew.hoursDT = [[mdata objectForKey:@"HoursDT"] doubleValue];
                        }
                        if ([mdata objectForKey:@"HoursLost"] != [NSNull null])
                        {
                            crew.hoursLost = [[mdata objectForKey:@"HoursLost"] doubleValue];
                        }
                        if ([mdata objectForKey:@"Units"] != [NSNull null])
                        {
                            crew.units = [[mdata objectForKey:@"Units"] integerValue];
                        }
                        if ([mdata objectForKey:@"Comments"] != [NSNull null])
                        {
                            crew.comments = [mdata objectForKey:@"Comments"];
                        }
                        if ([mdata objectForKey:@"CrewName"] != [NSNull null])
                        {
                            crew.crewName = [mdata objectForKey:@"CrewName"];
                        }
                        if ([mdata objectForKey:@"LaborActivityId"] != [NSNull null])
                        {
                            crew.laborActivityId = [[mdata objectForKey:@"LaborActivityId"] integerValue];
                        }
                        if ([mdata objectForKey:@"WorkTypeId"] != [NSNull null])
                        {
                            crew.workTypeId = [[mdata objectForKey:@"WorkTypeId"] integerValue];
                        }
                        if ([mdata objectForKey:@"PhaseId"] != [NSNull null])
                        {
                            crew.phaseId = [[mdata objectForKey:@"PhaseId"] integerValue];
                        }
                        if ([mdata objectForKey:@"TotalUnits"] != [NSNull null])
                        {
                            crew.totalUnits = [[mdata objectForKey:@"TotalUnits"] integerValue];
                        }
                        
                        [appD.eSubsDB insertCrewObject:crew forProjectId:projectId userId:appD.userId];
//                        [crewList addObject:crew];
                        
                        NSLog(@"Crew : %@", mdata);
                    }
                    crewList = [appD.eSubsDB getCrewObjects:projectId forDailyReportId:drId];
                }
            }
            success(crewList);
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(response, error);
        }];
    
    [operation start];
    
}

+ (void)saveUNsavedUploadAttachmentsPhotosToWebService:(UploadObject *) uploadObject
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNull null] forKey:@"Id"];
    [data setObject:[NSNumber numberWithInteger:uploadObject.uploadProjectId] forKey:@"ProjectId"];
    [data setObject:@"DailyReport" forKey:@"DocumentType"];
    [data setObject:[NSNumber numberWithInteger:uploadObject.dailyReportId] forKey:@"DocumentId"];
    [data setObject:@"Description" forKey:@"Description"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath;
    filePath = [applicationDocumentsDir stringByAppendingPathComponent:uploadObject.localFileStoreName];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    ImageUploadAFHTTPClient *client = [ImageUploadAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                     path:@"Upload"
                                                               parameters:nil
                                                constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                    {
                                        NSString *fn = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
                                        [formData appendPartWithFileData:imageData name:@"binaryData" fileName:fn mimeType:@"image/png"];
                                        [formData appendPartWithFormData:jsonData name:@"data"];
                                    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
    [client enqueueHTTPRequestOperation:operation];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [appD.eSubsDB deleteUploadObject:uploadObject.uploadProjectId andUploadId:uploadObject.uploadId forUserID:appD.userId];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error saveUNsavedUploadAttachmentsPhotosToWebService: %@", operation.responseString);
         NSLog(@"%@",error);
     }];
    [operation start];
    
}

+ (void) getDailyReports:(NSInteger) projectId success:(void (^)(NSMutableArray *dailyReports))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)projectId]  forKey:@"projectId"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"DR" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [appD.eSubsDB deleteDailyReports:projectId forUserID:appD.userId];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                NSMutableArray *dailyReports = [[NSMutableArray alloc] init];
                for (NSDictionary *mdata in data)
                {
                    DailyReportObject *dr = [[DailyReportObject alloc] init];
                    if ([mdata objectForKey:@"Id"] != [NSNull null])
                    {
                        dr.id = [[mdata objectForKey:@"Id"] integerValue];
                    }
                    if ([mdata objectForKey:@"Number"] != [NSNull null])
                    {
                        dr.number = [mdata objectForKey:@"Number"];
                    }
                    if ([mdata objectForKey:@"Revision"] != [NSNull null])
                    {
                        dr.revision = [mdata objectForKey:@"Revision"];
                    }
                    if ([mdata objectForKey:@"Subject"] != [NSNull null])
                    {
                        dr.subject = [mdata objectForKey:@"Subject"];
                    }
                    if ([mdata objectForKey:@"Date"] != [NSNull null])
                    {
                        dr.date = [mdata objectForKey:@"Date"];
                    }
                    if ([mdata objectForKey:@"EnteredBy"] != [NSNull null])
                    {
                        dr.enteredBy = [[mdata objectForKey:@"EnteredBy"] integerValue];
                    }
                    if ([mdata objectForKey:@"TimeOnSite"] != [NSNull null])
                    {
                        dr.timeOnSite = [mdata objectForKey:@"TimeOnSite"];
                    }
                    if ([mdata objectForKey:@"TimeOffSite"] != [NSNull null])
                    {
                        dr.timeOffSite = [mdata objectForKey:@"TimeOffSite"];
                    }
                    if ([mdata objectForKey:@"WeatherIcon"] != [NSNull null])
                    {
                        dr.weatherIcon = [mdata objectForKey:@"WeatherIcon"];
                    }
                    if ([mdata objectForKey:@"WeatherId"] != [NSNull null])
                    {
                        dr.weatherId = [[mdata objectForKey:@"WeatherId"] integerValue];
                    }
                    if ([mdata objectForKey:@"WindId"] != [NSNull null])
                    {
                        dr.windId = [[mdata objectForKey:@"WindId"] integerValue];
                    }
                    if ([mdata objectForKey:@"Temperature"] != [NSNull null])
                    {
                        dr.temperature = [[mdata objectForKey:@"Temperature"] integerValue];
                    }
                    if ([mdata objectForKey:@"EmployeeFromId"] != [NSNull null])
                    {
                        dr.employeeFromId = [[mdata objectForKey:@"EmployeeFromId"] integerValue];
                    }
                    if ([mdata objectForKey:@"Comments"] != [NSNull null])
                    {
                        NSDictionary *cdata = [mdata objectForKey:@"Comments"];
                        if ([cdata objectForKey:@"CommunicationWithOthers"] != [NSNull null])
                        {
                            dr.communicationWithOthers = [cdata objectForKey:@"CommunicationWithOthers"];
                        }
                        if ([cdata objectForKey:@"ScheduleCoordination"] != [NSNull null])
                        {
                            dr.scheduleCoordination = [cdata objectForKey:@"ScheduleCoordination"];
                        }
                        if ([cdata objectForKey:@"ExtraWork"] != [NSNull null])
                        {
                            NSDictionary *ndata = [cdata objectForKey:@"ExtraWork"];
                            if ([ndata objectForKey:@"Comment"] != [NSNull null])
                            {
                                dr.extraWork = [ndata objectForKey:@"Comment"];
                            }
                            if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                            {
                                dr.extraWorkIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                            }
                        }
                        if ([cdata objectForKey:@"AccidentReport"] != [NSNull null])
                        {
                            NSDictionary *ndata = [cdata objectForKey:@"AccidentReport"];
                            if ([ndata objectForKey:@"Comment"] != [NSNull null])
                            {
                                dr.accidentReport = [ndata objectForKey:@"Comment"];
                            }
                            if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                            {
                                dr.accidentReportIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                            }
                        }
                        if ([cdata objectForKey:@"Subcontractors"] != [NSNull null])
                        {
                            NSDictionary *ndata = [cdata objectForKey:@"Subcontractors"];
                            if ([ndata objectForKey:@"Comment"] != [NSNull null])
                            {
                                dr.subcontractors = [ndata objectForKey:@"Comment"];
                            }
                            if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                            {
                                dr.subcontractorsIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                            }
                        }
                        if ([cdata objectForKey:@"OtherVisitors"] != [NSNull null])
                        {
                            NSDictionary *ndata = [cdata objectForKey:@"OtherVisitors"];
                            if ([ndata objectForKey:@"Comment"] != [NSNull null])
                            {
                                dr.otherVisitors = [ndata objectForKey:@"Comment"];
                            }
                            if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                            {
                                dr.otherVisitorsIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                            }
                        }
                        if ([cdata objectForKey:@"Problems"] != [NSNull null])
                        {
                            NSDictionary *ndata = [cdata objectForKey:@"Problems"];
                            if ([ndata objectForKey:@"Comment"] != [NSNull null])
                            {
                                dr.problems = [ndata objectForKey:@"Comment"];
                            }
                            if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                            {
                                dr.problemsIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                            }
                        }
                        if ([cdata objectForKey:@"Internal"] != [NSNull null])
                        {
                            dr.internal = [cdata objectForKey:@"Internal"];
                        }
                    }
                    if ([mdata objectForKey:@"AllowEdit"] != [NSNull null])
                    {
                        dr.isEditable = [[mdata objectForKey:@"AllowEdit"] boolValue];
                    }
                    [dailyReports addObject:dr];
                }
                success(dailyReports);
            }
            else
            {
                success(nil);
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            failure(response, error, JSON);
        }];

        [operation start];

}

+(void) SaveMaterial:(MaterialsObject *)materialObj dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *material = [NSMutableDictionary dictionary];
    NSMutableArray *materialArray = [[NSMutableArray alloc] init];
    [material setObject:[NSNumber numberWithInteger:materialObj.id] forKey:@"materialId"];
    [material setObject:materialObj.name forKey:@"materialName"];
    [material setObject:materialObj.quantityValue forKey:@"materialQuantityValue"];
    [material setObject:materialObj.perValue forKey:@"materialPerValue"];
    [material setObject:materialObj.notesValue forKey:@"materialNotesValue"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [data setObject:[NSNumber numberWithInteger:drId] forKey:@"dailyReportId"];
    [materialArray addObject:material];
    [data setObject:materialArray forKey:@"material"];
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Material" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             success(JSON);
                                         }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                              failure(error);

                                         }];
    
    [operation start];
}

+(void) UpdateMaterial:(MaterialsObject *)materialObj dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *material = [NSMutableDictionary dictionary];
    NSMutableArray *materialArray = [[NSMutableArray alloc] init];
    
    [material setObject:[NSNumber numberWithInteger:materialObj.id] forKey:@"id"];
    [material setObject:[NSNumber numberWithInteger:materialObj.id] forKey:@"materialId"];
    [material setObject:materialObj.name forKey:@"materialName"];
    [material setObject:materialObj.quantityValue forKey:@"materialQuantityValue"];
    [material setObject:materialObj.perValue forKey:@"materialPerValue"];
    [material setObject:materialObj.notesValue forKey:@"materialNotesValue"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [data setObject:[NSNumber numberWithInteger:drId] forKey:@"dailyReportId"];
    [materialArray addObject:material];
    [data setObject:materialArray forKey:@"material"];
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:@"Material" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             success(JSON);
                                         }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             failure(error);
                                             
                                         }];
    
    [operation start];
}
@end
