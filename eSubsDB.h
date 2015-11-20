//
//  eSubsDB.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/9/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NoteObject.h"
#import "ProjectObject.h"
#import "NoteAttachment.h"
#import "UploadObject.h"
#import "UploadCategory.h"
#import "DailyReportObject.h"
#import "ActivityObject.h"
#import "WorkTypeObject.h"
#import "EmployeeObject.h"
#import "CompanyPreferencesObject.h"
#import "SystemPhase.h"
#import "ContactsObject.h"
#import "ContactAddressObject.h"
#import "NoteAddress.h"
#import "EquipmentObject.h"
#import "MaterialsObject.h"
#import "CrewObject.h"
#import "WeatherObject.h"
#import "WindObject.h"

@interface eSubsDB : NSObject
{
    sqlite3 *database;
}

-(id) initialise;
-(BOOL)openDatabase;

- (NSMutableArray *) getUploadObjects: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (NSMutableArray *) getUploadAttachmentPhotoObjects: (NSInteger) userId forProjectId: (NSInteger) projectID forDailyReport: (NSInteger) drId;
- (void) insertUploadObject: (UploadObject *) uploadObject forUserID: (NSInteger) userID;
- (void) deleteUploadObject:(NSInteger) projectId andUploadId: (NSInteger) uploadId forUserID: (NSInteger) userID;
- (void) deleteUnsavedUploadObjects:(NSInteger) userId forProjectId: (NSInteger) projectId forDailyReportId: (NSInteger) drId;
- (NSMutableArray *) getUnsavedUploadObjects:(NSInteger) projectId forUserID: (NSInteger) userId;
- (void) updateUploadObjecstWithNewDRId: (NSInteger) newDRId forOldDRIdId: (NSInteger) oldDRId;
- (NSMutableArray *) getUnsavedUploadAttachmentPhotoObjects: (NSInteger) userId;
- (NSUInteger) insertUploadThumbnail:(UploadObject *) uploadObject forUserID: (NSInteger) userID withData: (NSData *) upload;
- (UIImage *) getUploadThumbNail: (UploadObject *) uploadObject forUserID: (NSInteger) userID;
- (NSUInteger) insertNoteThumbNail: (NSData *) imageData;
- (UIImage *) getNoteThumbNail: (NSNumber *) index;
- (NSData *) getNoteThumbNailData: (NSNumber *) index;
- (NSUInteger) insertNoteImage: (NSData *) imageData;
- (void) insertNoteObject: (NoteObject *) noteObject forUserID: (NSInteger) userID;
- (UIImage *) getNoteImage: (NSNumber *) index;
- (NSData *) getNoteImageData: (NSNumber *) index;
- (NoteObject *) getNoteObject:(NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userId;
- (void) deleteNoteObject:(NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userID;
- (NSMutableArray *) getNoteObjects: (NSInteger) projectId forUserId: (NSInteger) userId;
- (void) updateNoteObject: (NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userID withDate: (NSString *) date;
- (void) deleteProjectObject:(NSInteger) projectId;
- (NSString *) getNoteDate: (NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userId;
- (NSMutableArray *) getUnsavedNoteObjects: (NSInteger) userId;
- (NSMutableArray *) getUnsavedNoteImageObjects: (NSInteger) userId;
- (void) insertProjectObject: (ProjectObject *) projectObject forUserID: (NSInteger) userID;
- (NSMutableArray *) getProjectObjects: (NSInteger) userID;
- (void) insertUploadCategories: (NSMutableArray *) uploadCategories forUserID: (NSInteger) userID;
- (NSMutableArray *) getUploadCategories: (NSInteger) userID;
- (NSUInteger) insertUser: (NSString *) subscriber forUserName: (NSString *) username andPassword: (NSString *) password;
- (NSUInteger) checkForUser: (NSString *) subscriber forUserName: (NSString *) username andPassword: (NSString *) password;
- (NSString *) getUsername: (NSUInteger) id;
- (NSUInteger) insertRFIThumbNail: (NSData *) imageData;
- (UIImage *) getRFIThumbNail: (NSNumber *) index;
- (NSData *) getRFIThumbNailData: (NSNumber *) index;
- (void) insertDailyReports:(DailyReportObject *) drObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) insertActivity:(ActivityObject *) activityObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) insertWorkType:(WorkTypeObject *) workTypeObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) insertEmployee:(EmployeeObject *) employeeObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) insertCompanyPreferences:(CompanyPreferencesObject *) companyPreferencesObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) insertSystemPhases:(SystemPhase *) systemPhaseObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) deleteDailyReports:(NSInteger) projectId forUserID: (NSInteger) userID;
- (void) deleteDailyReport:(NSInteger) projectId forUserID: (NSInteger) userID forDRId: (NSInteger) drId;
- (void) deleteActivity:(NSInteger) projectId forUserID: (NSInteger) userID;
- (void) deleteWorkType:(NSInteger) projectId forUserID: (NSInteger) userID;
- (void) deleteEmployee:(NSInteger) projectId forUserID: (NSInteger) userID;
- (void) deleteCompanyPreferences:(NSInteger) projectId forUserID: (NSInteger) userID;
- (void) deleteSystemPhases:(NSInteger) projectId forUserID: (NSInteger) userID;
- (NSMutableArray *) getDailyReports: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (DailyReportObject *) getDailyReport: (NSInteger) userId forProjectId: (NSInteger) projectID forDRId: (NSInteger) drId;
- (NSMutableArray *) getActivity: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (NSMutableArray *) getWorkType: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (NSMutableArray *) getEmployee: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (CompanyPreferencesObject *) getCompanyPreferences: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (NSMutableArray *) getSystemPhases: (NSInteger) userId forProjectId: (NSInteger) projectID;
- (void) insertContactObject:(ContactsObject *) contactObject forProjectId: (NSInteger) projectId;
- (void) deleteContactObjects:(NSInteger) projectId;
- (NSMutableArray *) getContactObjects:(NSInteger) projectID;
- (void) insertEquipmentObject:(EquipmentObject *) equipmentObject forUser: (NSInteger) userId forProjectId: (NSInteger) projectId andDailyReportId: (NSInteger) dailyReportId;
- (void) deleteEquipmentObjects:(NSInteger) userId forProjectId: (NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId;
- (void) deleteUnsavedEquipmentObjects:(NSInteger) userId forProjectId: (NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId;
- (void) deleteUnsavedEquipmentObject:(NSInteger) id;
- (NSMutableArray *) getEquipmentObjects:(NSInteger) userId forProjectId: (NSInteger) projectId andDailyReportId: (NSInteger) drId;
- (void) insertProjectEquipmentObject:(EquipmentObject *) equipmentObject forProjectId: (NSInteger) projectId;
- (void) deleteProjectEquipmentObjects:(NSInteger) projectId;
- (NSMutableArray *) getProjectEquipmentObjects:(NSInteger) projectID;
- (void) insertProjectMaterialObject:(MaterialsObject *) materialObject forProjectId: (NSInteger) projectId forDailyReportId:(NSInteger)dailyreportId;
- (void) updateProjectMaterialObject:(MaterialsObject *) materialObject forProjectId: (NSInteger) projectId;
-(void)  updateProjectMaterialObjectFlag:(MaterialsObject *)materialObject forProjectId:(NSInteger)projectId;
- (void) deleteProjectMaterialObjects:(NSInteger) projectId;
- (NSMutableArray *) getProjectMaterialObjects:(NSInteger) projectID DailyReportId:(NSInteger)DrId;
- (NSMutableArray *) getFlagMaterialObjects:(NSInteger) projectID;
- (void) insertCrewObject:(CrewObject *) crewObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId;
- (void) deleteCrewObject:(NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId;
- (NSMutableArray *) getCrewObjects:(NSInteger) projectID forDailyReportId: (NSInteger) dailyReportId;
- (void) insertWeatherObject:(WeatherObject *) weatherObject;
- (void) deleteWeatherObjects;
- (NSMutableArray *) getWeatherObjects;
- (void) insertWindObject:(WindObject *) windObject;
- (void) deleteWindObjects;
- (NSMutableArray *) getWindObjects;
- (NSMutableArray *) getUnsavedDailyReportsObjects: (NSInteger) userId;
- (void) deleteUnsavedCrewObject:(NSInteger) projectId forId: (NSInteger) drId;
- (void) deleteSavedCrewObject:(NSInteger) projectId forDRId: (NSInteger) drId;
- (NSMutableArray *) getUnsavedCrewObjects:(NSInteger) userID forProjectId: (NSInteger) projectId forDRId: (NSInteger) drId;
- (NSMutableArray *) getUnsavedCrewObjects:(NSInteger) userID;
- (void) updateCrewObjectWithNewDRId: (NSInteger) newDRId forOldDRIdId: (NSInteger) oldDRId;
- (void) updateEquipmentObjectWithNewDRId: (NSInteger) newDRId forOldDRIdId: (NSInteger) oldDRId;
- (NSMutableArray *) getSavedEquipmentObjects:(NSInteger) userId;
- (void) updateDailyReport:(NSInteger) oldDRId forDR: (DailyReportObject *) dr;

@end
