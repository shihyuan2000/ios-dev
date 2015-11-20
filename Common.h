//
//  Common.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/15/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteAddress.h"
#import "NoteObject.h"
#import "EquipmentObject.h"
#import "DailyReportObject.h"
#import "MaterialsObject.h"

@interface Common : NSObject

+ (NSMutableArray *) buildExistingCrewRows:(NSMutableArray *) crewList;
+ (void) saveNoteImageToWebService: (NoteObject *) note;
+ (void) saveNoteToWebService: (NoteObject *) note usingUUID: (NSString *) uuid;
+ (NSString *) makeAddress: (NoteAddress *) noteAddress;
+ (UIImage *)scaleImage:(UIImage*)sourceImage toSize:(CGSize)targetSize;
+ (NSString *)urlEncodeValue:(NSString *)str;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (NSData *) createThumbNail: (UIImage *) mainImage;
+ (void)GetListOfContacts:(int) projectId success:(void (^)(NSMutableArray *contacts))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
+ (void)GetWeather:(NSString *)zipCode success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)GetPastWeather:(NSString *)zipCode forDate: (NSString *) date success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void) getListOfCrew:(NSInteger) projectId dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
+ (void) getListOfEquipment:(NSInteger) projectId dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;

+ (void) CopyCrewEquipmentMatieralsForDailyReport:(NSInteger) projectId dailyReportId:(NSInteger) drId
                                  dailyReportDate:(NSString *) drDate
                                copyDailyReportId: (NSInteger) copyDRId
                                         complete:(void(^)())completionBlock;
+ (void) saveDailyReportToWebService: (DailyReportObject *) dr isLast: (BOOL) last success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void) saveDailyReportToWebService: (DailyReportObject *) dr success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void) saveCrewsToWebService: (NSMutableArray *) crewLists
                  forProjectId:(NSInteger) projectId
                       forDRId: (NSInteger) DRId
                       forDate: (NSString *) drDate
                         forId: (NSInteger) saveId
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

+ (void) saveUnsavedCrewsToWebService;
+ (void) saveUnsavedEquipmentToWebService:(EquipmentObject *) equipmentObject success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)saveUNsavedUploadAttachmentsPhotosToWebService:(UploadObject *) uploadObject;

+ (void) getDailyReports:(NSInteger) projectId success:(void (^)(NSMutableArray *dailyReports))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error, id JSON))failure;
+ (void) editNoteToWebService: (NoteObject *) note usingUUID: (NSString *) uuid;
+(void) SaveMaterial:(MaterialsObject *)materialObj dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+(void) UpdateMaterial:(MaterialsObject *)materialObj dailyReportId:(NSInteger) drId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
