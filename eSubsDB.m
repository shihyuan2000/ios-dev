//
//  eSubsDB.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/9/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "eSubsDB.h"

@implementation eSubsDB

- (id) initialise
{
	if(![self openDatabase])
	{
		//NSLog(@"Open database failed.");
	}
    //NSLog(@"Open database");
    
	return self;
}

- (BOOL) openDatabase
{
    if (!database)
    {
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NotesDB.db"];
        int result = sqlite3_open([path UTF8String], &database);
        if (result != SQLITE_OK)
        {
            NSLog(@"Notes DB Open/Create failed!");
            return NO;
        }
        
        const char *sql;
        char *errMsg;

        sql = "CREATE TABLE IF NOT EXISTS UploadsThumbnails (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, projectId INTEGER, uploadId INTEGER, image BLOB)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB Uploads failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS NoteImages (id INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB NoteImages failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS NoteThumbNails (id INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB NoteThumbNails failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
        
        sql = "CREATE TABLE IF NOT EXISTS RFIThumbNails (id INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB NoteThumbNails failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS ListOfImages (projectID INTEGER, noteID INTEGER, imageID INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB ListOfImages failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
    
        sql = "CREATE TABLE IF NOT EXISTS ListOfThumbNails (projectID INTEGER, noteID INTEGER, imageID INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB ListOfThumbNails failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS NoteObject (userId INTEGER, projectId INTEGER, noteId INTEGER,  date text, title text, description text, address1 text, address2 text, city text, state text, zip text, country text, longitude float, latitude float)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB NoteObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS ProjectObject (userId INTEGER, id INTEGER, number text, name text, status text, startDate text, finishDate text, projectManager text, address1 text, address2 text, city text, state text, zip text, country text, longitude float, latitude float, comments text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB ProjectObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
    
        sql = "CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY AUTOINCREMENT, subscriber text, secret text, username text, password text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB Users failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS Attachments (userId INTEGER, projectId INTEGER, noteId INTEGER, id INTEGER, mimtype text, fileName text, size INTEGER, url text, thumbNail text, attachmentDate text, description text, documentType text, documentId INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB Attachments failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
    
        sql = "CREATE TABLE IF NOT EXISTS UploadObject (userId INTEGER, projectId INTEGER, uploadId INTEGER,  mimetype text, filename text, size INTEGER, url text, thumbnail text, date text, description text, category text, documentType text, documentId INTEGER, dailyReportId INTEGER, localFileStoreName text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB UploadObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
        
        sql = "CREATE TABLE IF NOT EXISTS UploadCategories (userId INTEGER, id INTEGER,  name text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB UploadCategory failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
        
        sql = "CREATE TABLE IF NOT EXISTS DailyReports (userId INTEGER, projectId INTEGER, id INTEGER, number text, revision text, subject text, date text, enteredBy INTEGER, timeOnSite text, timeOffSite text, weatherIcon text, weatherId INTEGER, windId INTEGER, temperature INTEGER, employeeFromId INTEGER, drCopyId INTEGER, communicationWithOthers TEXT, scheduleCoordination TEXT, extraWork TEXT, extraWorkIsInternal INTEGER, accidentReport TEXT, accidentReportIsInternal INTEGER, subcontractors TEXT, subcontractorsIsInternal INTEGER, otherVisitors TEXT, otherVisitorsIsInternal INTEGER, problems TEXT, problemsIsInternal INTEGER, internal TEXT, isEditable INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB DailyReports failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS Activity (userId INTEGER, projectId INTEGER, id INTEGER, code text, name text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB Activity failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS WorkType (userId INTEGER, projectId INTEGER, id INTEGER, type text, show INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB WorkType failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS Employee (userId INTEGER, projectId INTEGER, id INTEGER, first text, last text, laborClassId INTEGER, number text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB Employee failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
        
        sql = "CREATE TABLE IF NOT EXISTS CompanyPreferences (userId INTEGER, projectId INTEGER, dailyReportOvertimeEnabled INTEGER, dailyReportDoubleTimeEnabled INTEGER, dailyReportUnitTrackingEnabled INTEGER,dailyReportEquipment INTEGER,dailyReportMaterials INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB CompanyPreferences failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS systemPhases (userId INTEGER, projectId INTEGER, phaseName text, phaseId INTEGER, systemName text, systemId INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB systemPhases failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
        
        sql = "CREATE TABLE IF NOT EXISTS ContactAddress (projectId INTEGER, contactId INTEGER, address1 text, address2 text, city text, state text, zip text, country text, phone text, fax text, mobile text, pager text, tollfree text, home text, email text, website text, type text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB ContactAddress failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        if (![self isExistColumn:@"ContactObject" Column:@"addressId INTEGER"]) {
            sql = "DROP TABLE ContactObject";
            errMsg = NULL;
            result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
            if (result != SQLITE_OK)
            {
                NSLog(@"DROP DB ContactObject failed!");
                NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            }
        }
        sql = "CREATE TABLE IF NOT EXISTS ContactObject (projectId INTEGER, id INTEGER, firstName text, lastName text, company text,addressId INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB ContactObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        if (![self isExistColumn:@"EquipmentObject" Column:@"drEquipmentId INTEGER"]) {
            sql = "DROP TABLE EquipmentObject";
            errMsg = NULL;
            result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
            if (result != SQLITE_OK)
            {
                NSLog(@"DROP DB EquipmentObject failed!");
                NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            }
        }
        
        sql = "CREATE TABLE IF NOT EXISTS EquipmentObject (userId INTEGER, projectId INTEGER, dailyReportId INTEGER, id INTEGER, equipmentId INTEGER, equipment text, code text, asset text, hours REAL, useageDesc text, site INTEGER, user INTEGER,drEquipmentId INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB EquipmentObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
 
        sql = "CREATE TABLE IF NOT EXISTS ProjectEquipmentObject (projectId INTEGER, id INTEGER, equipment text, code text, asset text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB ProjectEquipmentObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }


        if (![self isExistColumn:@"ProjectMaterialsObject" Column:@"dailyReportId INTEGER"]) {
            sql = "DROP TABLE ProjectMaterialsObject";
            errMsg = NULL;
            result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
            if (result != SQLITE_OK)
            {
                NSLog(@"DROP DB ProjectMaterialsObject failed!");
                NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            }
        }
        sql = "CREATE TABLE IF NOT EXISTS ProjectMaterialsObject (projectId INTEGER, id INTEGER, name text, quantityValue text, perValue text, notesValue text,flag INTEGER,dailyReportId INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB MaterialObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS CrewObjects (userId INTEGER, projectId INTEGER, id INTEGER, crewId INTEGER, dailyReportId INTEGER, crewMemberId INTEGER, employeeId INTEGER, laborClasId INTEGER, lineNumber INTEGER, hoursST REAL, hoursOT REAL, hoursDT REAL, hoursLost REAL, units INTEGER, comments TEXT, crewName TEXT, laborActivityId INTEGER, workTypeId INTEGER, phaseId INTEGER, totalUnits INTEGER, drDate TEXT)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB MaterialObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }
        
        sql = "CREATE TABLE IF NOT EXISTS WeatherObjects (weatherId INTEGER, weather text, conditionGroup text, code INTEGER)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB WeatherObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

        sql = "CREATE TABLE IF NOT EXISTS WindObjects (windId INTEGER, name text)";
        errMsg = NULL;
        result = sqlite3_exec(database, sql, NULL, NULL, &errMsg);
        if (result != SQLITE_OK)
        {
            NSLog(@"Create DB WindObject failed!");
            NSLog(@"Error : %@", [NSString stringWithUTF8String:errMsg]);
            return NO;
        }

    }
    return YES;
}

-(BOOL)isExistColumn:(NSString*)chTableName Column:(NSString*)column
{
    BOOL isExist = FALSE;
    NSString *query = [NSString stringWithFormat:@"select sql from sqlite_master where tbl_name='%@';",chTableName];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
       while (sqlite3_step(statement) == SQLITE_ROW)
    {

        NSString *sqlResult = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        if([sqlResult rangeOfString:column].location != NSNotFound)
        {
            isExist = TRUE;
        }
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);

    return isExist;
}


- (void) insertWindObject:(WindObject *) windObject
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO WindObjects (windId, name) VALUES (?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)windObject.windId);
    str = @"";
    if (windObject.name != nil)
    {
        str = windObject.name;
    }
    sqlite3_bind_text(stmt, 2, [str UTF8String], -1, NULL);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteWindObjects
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From WindObjects"];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getWindObjects
{
    
    NSString *query = [NSString stringWithFormat:@"select * From WindObjects"];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *windObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        WindObject *wind = [[WindObject alloc] init];
        wind.windId = sqlite3_column_int(statement, 0);
        wind.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        [windObjects addObject:wind];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return windObjects;
    
}

- (void) insertWeatherObject:(WeatherObject *) weatherObject
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO WeatherObjects (weatherId, weather, conditionGroup, code) VALUES (?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)weatherObject.weatherId);
    str = @"";
    if (weatherObject.weather != nil)
    {
        str = weatherObject.weather;
    }
    sqlite3_bind_text(stmt, 2, [str UTF8String], -1, NULL);
    str = @"";
    if (weatherObject.conditionGroup != nil)
    {
        str = weatherObject.conditionGroup;
    }
    sqlite3_bind_text(stmt, 3, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 4, (int)weatherObject.code);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteWeatherObjects
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From WeatherObjects"];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getWeatherObjects
{
    
    NSString *query = [NSString stringWithFormat:@"select * From WeatherObjects"];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *weatherObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        WeatherObject *weather= [[WeatherObject alloc] init];
        weather.weatherId = sqlite3_column_int(statement, 0);
        weather.weather = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        weather.conditionGroup = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        weather.code = sqlite3_column_int(statement, 3);
        [weatherObjects addObject:weather];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return weatherObjects;
    
}

- (void) insertCrewObject:(CrewObject *) crewObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO CrewObjects (userId, projectId, id, crewId, dailyReportId, crewMemberId, employeeId, laborClasId, lineNumber, hoursST, hoursOT, hoursDT, hoursLost, units, comments, crewName, laborActivityId, workTypeId, phaseId, totalUnits, drDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }

    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)crewObject.id);
    sqlite3_bind_int(stmt, 4, (int)crewObject.crewId);
    sqlite3_bind_int(stmt, 5, (int)crewObject.dailyReportId);
    sqlite3_bind_int(stmt, 6, (int)crewObject.crewMemberId);
    sqlite3_bind_int(stmt, 7, (int)crewObject.employeeId);
    sqlite3_bind_int(stmt, 8, (int)crewObject.laborClassId);
    sqlite3_bind_int(stmt, 9, (int)crewObject.lineNumber);
    sqlite3_bind_double(stmt, 10, crewObject.hoursST);
    sqlite3_bind_double(stmt, 11, crewObject.hoursOT);
    sqlite3_bind_double(stmt, 12, crewObject.hoursDT);
    sqlite3_bind_double(stmt, 13, crewObject.hoursLost);
    sqlite3_bind_int(stmt, 14, (int)crewObject.units);
    str = @"";
    if (crewObject.comments != nil)
    {
        str = crewObject.comments;
    }
    sqlite3_bind_text(stmt, 15, [str UTF8String], -1, NULL);
    str = @"";
    if (crewObject.crewName != nil)
    {
        str = crewObject.crewName;
    }
    sqlite3_bind_text(stmt, 16, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 17, (int)crewObject.laborActivityId);
    sqlite3_bind_int(stmt, 18, (int)crewObject.workTypeId);
    sqlite3_bind_int(stmt, 19, (int)crewObject.phaseId);
    sqlite3_bind_int(stmt, 20, (int)crewObject.totalUnits);
    str = @"";
    if (crewObject.drDate != nil)
    {
        str = crewObject.drDate;
    }
    sqlite3_bind_text(stmt, 21, [str UTF8String], -1, NULL);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteCrewObject:(NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From CrewObjects where projectId = %ld and id = %ld", (long) projectId, (long)dailyReportId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (void) deleteSavedCrewObject:(NSInteger) projectId forDRId: (NSInteger) drId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From CrewObjects where projectId = %ld and dailyReportId = %ld and crewName == 'This crew has not been saved'", (long) projectId, (long)drId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (void) deleteUnsavedCrewObject:(NSInteger) projectId forId: (NSInteger) drId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From CrewObjects where projectId = %ld and dailyReportId = %ld and crewName != 'This crew has not been saved'", (long) projectId, (long)drId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getUnsavedCrewObjects:(NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"select DISTINCT dailyReportId, userId, projectId, drDate From CrewObjects where userId = %ld and crewName = 'This crew has not been saved'", (long) userID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *crewObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        CrewObject *crew = [[CrewObject alloc] init];
        crew.dailyReportId = sqlite3_column_int(statement, 0);
        crew.projectId = sqlite3_column_int(statement, 2);
//        crew.id = sqlite3_column_int(statement, 3);
        crew.drDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        
//        crew.id = sqlite3_column_int(statement, 4);
//        crew.laborActivityId = sqlite3_column_int(statement, 5);
//        crew.workTypeId = sqlite3_column_int(statement, 6);
//        crew.phaseId = sqlite3_column_int(statement, 7);
        [crewObjects addObject:crew];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return crewObjects;

/*
    NSString *query = [NSString stringWithFormat:@"select DISTINCT userId, projectId, dailyReportId, drDate, id, laborActivityId, workTypeId, phaseId From CrewObjects where userId = %ld and crewName = 'This crew has not been saved'", (long) userID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *crewObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        CrewObject *crew = [[CrewObject alloc] init];
        crew.projectId = sqlite3_column_int(statement, 1);
        crew.dailyReportId = sqlite3_column_int(statement, 2);
        crew.drDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        crew.id = sqlite3_column_int(statement, 4);
        crew.laborActivityId = sqlite3_column_int(statement, 5);
        crew.workTypeId = sqlite3_column_int(statement, 6);
        crew.phaseId = sqlite3_column_int(statement, 7);
        [crewObjects addObject:crew];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return crewObjects;
*/
}

- (NSMutableArray *) getCrewObjects:(NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId 
{
    
    NSString *query = [NSString stringWithFormat:@"select * From CrewObjects where projectId = %ld and dailyReportId = %ld;", (long) projectId, (long)dailyReportId];
    
    return [self getCrewObjectsFromSQLQuery:query];
    
}
- (NSMutableArray *) getUnsavedCrewObjects:(NSInteger) userID forProjectId: (NSInteger) projectId forDRId: (NSInteger) drId
{
    
//    NSString *query = [NSString stringWithFormat:@"select * From CrewObjects where userId = %ld and projectId = %ld and dailyReportId = %ld and laborActivityId = %ld and workTypeId = %ld and  phaseId = %ld", (long) userID, (long) projectId, (long)drId, (long)activityId, (long)workTypeId, (long)phaseId];

//    NSString *query = [NSString stringWithFormat:@"select * From CrewObjects where userId = %ld and projectId = %ld and dailyReportId = %ld and crewName == 'This crew has not been saved'", (long) userID, (long) projectId, (long)drId];
    
    NSString *query = [NSString stringWithFormat:@"select * From CrewObjects where userId = %ld and projectId = %ld and dailyReportId = %ld", (long) userID, (long) projectId, (long)drId];

    return [self getCrewObjectsFromSQLQuery:query];
    
}


- (NSMutableArray *) getCrewObjectsFromSQLQuery:(NSString *) query
{
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *crewObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        CrewObject *crew = [[CrewObject alloc] init];
        crew.projectId = sqlite3_column_int(statement, 1);
        crew.id = sqlite3_column_int(statement, 2);
        crew.crewId = sqlite3_column_int(statement, 3);
        crew.dailyReportId = sqlite3_column_int(statement, 4);
        crew.crewMemberId = sqlite3_column_int(statement, 5);
        crew.employeeId = sqlite3_column_int(statement, 6);
        crew.laborClassId = sqlite3_column_int(statement, 7);
        crew.lineNumber = sqlite3_column_int(statement, 8);
        crew.hoursST = sqlite3_column_double(statement, 9);
        crew.hoursOT = sqlite3_column_double(statement, 10);
        crew.hoursDT = sqlite3_column_double(statement, 11);
        crew.hoursLost = sqlite3_column_double(statement, 12);
        crew.units = sqlite3_column_int(statement, 13);
        crew.comments = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
        crew.crewName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
        crew.laborActivityId = sqlite3_column_int(statement, 16);
        crew.workTypeId = sqlite3_column_int(statement, 17);
        crew.phaseId = sqlite3_column_int(statement, 18);
        crew.totalUnits = sqlite3_column_int(statement, 19);
        [crewObjects addObject:crew];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return crewObjects;

}

- (void) updateCrewObjectWithNewDRId: (NSInteger) newDRId forOldDRIdId: (NSInteger) oldDRId
{
    
    char *errMsg = NULL;
    NSString *query = [NSString stringWithFormat:@"UPDATE CrewObjects set dailyReportId  = %ld where dailyReportId = %ld", (long) newDRId, (long) oldDRId];
    sqlite3_stmt *statement;
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL );
    
    if((sqlite3_step(statement)) != SQLITE_DONE)
    {
        NSLog(@"SQL updateCrewObjectWithNewDRId: %@/n", query);
        NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
    }
    
    NSLog(@"updateCrewObjectWithNewDRId - number of rows updated %d", sqlite3_changes(database));
    
    sqlite3_finalize(statement);
    
    return;
    
}

- (void) insertProjectMaterialObject:(MaterialsObject *) materialObject forProjectId: (NSInteger) projectId forDailyReportId:(NSInteger)dailyreportId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT or replace INTO ProjectMaterialsObject (projectId, id, name, quantityValue, perValue,notesValue,flag,dailyReportId) VALUES (?, ?, ?, ?, ?, ?,?,?);";
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)projectId);
    sqlite3_bind_int(stmt, 2, (int)materialObject.id);
    str = @"";
    if (materialObject.name != nil)
    {
        str = materialObject.name;
    }
    sqlite3_bind_text(stmt, 3, [str UTF8String], -1, NULL);
    str = @"";
    if (materialObject.quantityValue != nil)
    {
        str = materialObject.quantityValue;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    str = @"";
    if (materialObject.perValue != nil)
    {
        str = materialObject.perValue;
    }
    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
    str = @"";
    if (materialObject.notesValue != nil)
    {
        str = materialObject.notesValue;
    }
    sqlite3_bind_text(stmt, 6, [str UTF8String], -1, NULL);


    sqlite3_bind_int(stmt, 7, (int)materialObject.flag);
    sqlite3_bind_int(stmt, 8, (int)dailyreportId);
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

-(void)  updateProjectMaterialObjectFlag:(MaterialsObject *)materialObject forProjectId:(NSInteger)projectId
{
    sqlite3_stmt *stmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"UPDATE ProjectMaterialsObject set flag=0 where projectId = %ld and name='%@';",(long) projectId, materialObject.name];
    sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL);
    
    if ((sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    NSLog(@"updateCrewObjectWithNewDRId - number of rows updated %d", sqlite3_changes(database));
    
    sqlite3_finalize(stmt);
}

- (void) updateProjectMaterialObject:(MaterialsObject *) materialObject forProjectId: (NSInteger) projectId
{
    sqlite3_stmt *stmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"UPDATE ProjectMaterialsObject set quantityValue='%@',perValue='%@',notesValue='%@',flag=%d where projectId = %ld and name='%@';", materialObject.quantityValue,materialObject.perValue,materialObject.notesValue,materialObject.flag,(long) projectId, materialObject.name];
    sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL);
    
    if ((sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    NSLog(@"updateCrewObjectWithNewDRId - number of rows updated %d", sqlite3_changes(database));
    
    sqlite3_finalize(stmt);
    
}

- (void) deleteProjectMaterialObjects:(NSInteger) projectId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From ProjectMaterialsObject where projectId = %ld", (long) projectId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getFlagMaterialObjects:(NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From ProjectMaterialsObject where projectId = %ld and (flag=1 or flag =2)", (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *materialsObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        MaterialsObject *material = [[MaterialsObject alloc] init];
        material.id = sqlite3_column_int(statement, 1);
        material.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        material.quantityValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        material.perValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        material.notesValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        material.flag =sqlite3_column_int(statement, 6);
        material.dailyReportId =sqlite3_column_int(statement, 7);
        [materialsObjects addObject:material];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return materialsObjects;
    
}

- (NSMutableArray *) getProjectMaterialObjects:(NSInteger) projectID DailyReportId:(NSInteger)DrId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From ProjectMaterialsObject where projectId = %ld and dailyReportId= %ld;", (long) projectID,(long)DrId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *materialsObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        MaterialsObject *material = [[MaterialsObject alloc] init];
        material.id = sqlite3_column_int(statement, 1);
        material.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        material.quantityValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        material.perValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        material.notesValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        material.flag =sqlite3_column_int(statement, 6);
        [materialsObjects addObject:material];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return materialsObjects;
    
}

- (void) insertProjectEquipmentObject:(EquipmentObject *) equipmentObject forProjectId: (NSInteger) projectId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO ProjectEquipmentObject (projectId, id, equipment, code, asset) VALUES (?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)projectId);
    sqlite3_bind_int(stmt, 2, (int)equipmentObject.equipmentId);
    str = @"";
    if (equipmentObject.equipment != nil)
    {
        str = equipmentObject.equipment;
    }
    sqlite3_bind_text(stmt, 3, [str UTF8String], -1, NULL);
    str = @"";
    if (equipmentObject.code != nil)
    {
        str = equipmentObject.code;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 5, (int)equipmentObject.asset);
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteProjectEquipmentObjects:(NSInteger) projectId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From ProjectEquipmentObject where projectId = %ld", (long) projectId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getProjectEquipmentObjects:(NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From ProjectEquipmentObject where projectId = %ld;", (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *equipmentObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        EquipmentObject *equipment = [[EquipmentObject alloc] init];
        equipment.equipmentId = sqlite3_column_int(statement, 1);
        equipment.equipment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        equipment.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        equipment.asset = sqlite3_column_int(statement, 4);
        [equipmentObjects addObject:equipment];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return equipmentObjects;
    
}

- (void) insertEquipmentObject:(EquipmentObject *) equipmentObject forUser: (NSInteger) userId forProjectId: (NSInteger) projectId andDailyReportId: (NSInteger) dailyReportId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT OR REPLACE INTO EquipmentObject (userId, projectId, dailyReportId, id, equipmentId, equipment, code, asset, hours, useageDesc, site, user,drEquipmentId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)dailyReportId);
    sqlite3_bind_int(stmt, 4, (int)equipmentObject.id);
    sqlite3_bind_int(stmt, 5, (int)equipmentObject.equipmentId);
    str = @"";
    if (equipmentObject.equipment != nil)
    {
        str = equipmentObject.equipment;
    }
    sqlite3_bind_text(stmt, 6, [str UTF8String], -1, NULL);
    str = @"";
    if (equipmentObject.code != nil)
    {
        str = equipmentObject.code;
    }
    sqlite3_bind_text(stmt, 7, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 8, (int)equipmentObject.asset);
    sqlite3_bind_double(stmt, 9, equipmentObject.hours);
    str = @"";
    if (equipmentObject.useageDesc != nil)
    {
        str = equipmentObject.useageDesc;
    }
    sqlite3_bind_text(stmt, 10, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 11, (int)equipmentObject.site);
    sqlite3_bind_int(stmt, 12, (int)equipmentObject.user);
    sqlite3_bind_int(stmt, 13, (int)equipmentObject.drEquipmentId);
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteUnsavedEquipmentObject:(NSInteger) id
{

    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From EquipmentObject where id = %ld", (long)id];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;

}

- (void) deleteUnsavedEquipmentObjects:(NSInteger) userId forProjectId: (NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From EquipmentObject where userId = %ld and projectId = %ld and dailyReportId = %ld and equipment != 'This equipment has not been saved'", (long)userId, (long)projectId, (long)dailyReportId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }

    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (void) deleteEquipmentObjects:(NSInteger) userId forProjectId: (NSInteger) projectId forDailyReportId: (NSInteger) dailyReportId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From EquipmentObject where userId = %ld and projectId = %ld and dailyReportId = %ld", (long)userId, (long)projectId, (long)dailyReportId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getEquipmentObjects:(NSInteger) userId forProjectId: (NSInteger) projectId andDailyReportId: (NSInteger) drId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From EquipmentObject where userId = %ld and projectId = %ld and dailyReportId = %ld", (long) userId, (long) projectId, (long) drId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *equipmentObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        EquipmentObject *equipment = [[EquipmentObject alloc] init];
        equipment.projectId = sqlite3_column_int(statement, 1);
        equipment.dailyReportId = sqlite3_column_int(statement, 2);
        equipment.id = sqlite3_column_int(statement, 3);
        equipment.equipmentId = sqlite3_column_int(statement, 4);
        equipment.equipment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        equipment.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        equipment.asset = sqlite3_column_int(statement, 7);
        equipment.hours = sqlite3_column_double(statement, 8);
        equipment.useageDesc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        equipment.site = sqlite3_column_int(statement, 10);
        equipment.user = sqlite3_column_int(statement, 11);
        equipment.drEquipmentId =sqlite3_column_int(statement, 12);
        [equipmentObjects addObject:equipment];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return equipmentObjects;
    
}

- (NSMutableArray *) getSavedEquipmentObjects:(NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From EquipmentObject where userId = %ld and code = 'This equipment has not been saved'", (long) userId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *equipmentObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        EquipmentObject *equipment = [[EquipmentObject alloc] init];
        equipment.projectId = sqlite3_column_int(statement, 1);
        equipment.dailyReportId = sqlite3_column_int(statement, 2);
        equipment.id = sqlite3_column_int(statement, 3);
        equipment.equipmentId = sqlite3_column_int(statement, 4);
        equipment.equipment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        equipment.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        equipment.asset = sqlite3_column_int(statement, 7);
        equipment.hours = sqlite3_column_double(statement, 8);
        equipment.useageDesc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        equipment.site = sqlite3_column_int(statement, 10);
        equipment.user = sqlite3_column_int(statement, 11);
        
        [equipmentObjects addObject:equipment];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return equipmentObjects;
    
}

- (void) updateEquipmentObjectWithNewDRId: (NSInteger) newDRId forOldDRIdId: (NSInteger) oldDRId
{
    
    char *errMsg = NULL;
    NSString *query = [NSString stringWithFormat:@"UPDATE EquipmentObject set dailyReportId  = %ld where dailyReportId = %ld", (long) newDRId, (long) oldDRId];
    sqlite3_stmt *statement;
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL );
    
    if((sqlite3_step(statement)) != SQLITE_DONE)
    {
        NSLog(@"SQL updateEquipmentWithNewDRId: %@/n", query);
        NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
    }
    
    NSLog(@"updateEquipmentWithNewDRId - number of rows updated %d", sqlite3_changes(database));
    
    sqlite3_finalize(statement);
    
    return;
    
}

- (void) insertContactObject:(ContactsObject *) contactObject forProjectId: (NSInteger) projectId
{

    NSString *str;
    sqlite3_stmt *stmt = nil;

    const char *sql = "INSERT INTO ContactAddress (projectId, contactId, address1, address2, city, state, zip, country, phone, fax, mobile, pager, tollfree, home, email, website, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    const char *sql2 = "INSERT INTO ContactObject (projectId, id, firstName, lastName, company,addressId) VALUES (?, ?, ?, ?, ?,?);";

    int res = sqlite3_prepare_v2(database, sql2, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)projectId);
    sqlite3_bind_int(stmt, 2, (int)contactObject.id);
    str = @"";
    if (contactObject.contactFirstname != nil)
    {
        str = contactObject.contactFirstname;
    }
    sqlite3_bind_text(stmt, 3, [str UTF8String], -1, NULL);
    str = @"";
    if (contactObject.contactLastname != nil)
    {
        str = contactObject.contactLastname;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    str = @"";
    if (contactObject.contactCompany != nil)
    {
        str = contactObject.contactCompany;
    }

    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 6, (int)contactObject.AddressId);
    
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);

    for (ContactAddressObject *contactAddress in contactObject.contactAddresses)
    {
        NoteAddress *address = contactAddress.address;
        sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
        sqlite3_bind_int(stmt, 1, (int)projectId);
        sqlite3_bind_int(stmt, 2, (int)contactObject.id);
        str = @"";
        if (address.address1 != nil)
        {
            str = address.address1;
        }
        sqlite3_bind_text(stmt, 3, [str UTF8String], -1, NULL);
        str = @"";
        if (address.address2 != nil)
        {
            str = address.address2;
        }
        sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
        str = @"";
        if (address.city != nil)
        {
            str = address.city;
        }
        sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
        str = @"";
        if (address.state != nil)
        {
            str = address.state;
        }
        sqlite3_bind_text(stmt, 6, [str UTF8String], -1, NULL);
        str = @"";
        if (address.zip != nil)
        {
            str = address.zip;
        }
        sqlite3_bind_text(stmt, 7, [str UTF8String], -1, NULL);
        str = @"";
        if (address.country != nil)
        {
            str = address.country;
        }
        sqlite3_bind_text(stmt, 8, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.phone != nil)
        {
            str = contactAddress.phone;
        }
        sqlite3_bind_text(stmt, 9, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.fax != nil)
        {
            str = contactAddress.fax;
        }
        sqlite3_bind_text(stmt, 10, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.mobile != nil)
        {
            str = contactAddress.mobile;
        }
        sqlite3_bind_text(stmt, 11, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.pager != nil)
        {
            str = contactAddress.pager;
        }
        sqlite3_bind_text(stmt, 12, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.tollFree != nil)
        {
            str = contactAddress.tollFree;
        }
        sqlite3_bind_text(stmt, 13, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.home != nil)
        {
            str = contactAddress.home;
        }
        sqlite3_bind_text(stmt, 14, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.email != nil)
        {
            str = contactAddress.email;
        }
        sqlite3_bind_text(stmt, 15, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.website != nil)
        {
            str = contactAddress.website;
        }
        sqlite3_bind_text(stmt, 16, [str UTF8String], -1, NULL);
        str = @"";
        if (contactAddress.type != nil)
        {
            str = contactAddress.type;
        }
        sqlite3_bind_text(stmt, 17, [str UTF8String], -1, NULL);

        if((res = sqlite3_step(stmt)) != SQLITE_DONE)
        {
            NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
            sqlite3_reset(stmt);
            return;
        }
        sqlite3_reset(stmt);
    }

    sqlite3_finalize(stmt);
    return;

}

- (void) deleteContactObjects:(NSInteger) projectId
{
    
    sqlite3_stmt *updStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"delete From ContactAddress where projectId = %ld", (long) projectId];
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);

    query = [NSString stringWithFormat:@"delete From ContactObject where projectId = %ld", (long)projectId];
    res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getContactObjects:(NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From ContactObject where projectId = %ld;", (long) projectID];
    
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;

    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        ContactsObject *contact = [[ContactsObject alloc] init];
        contact.contactAddresses = [[NSMutableArray alloc] init];
        contact.id = sqlite3_column_int(statement, 1);
        contact.contactFirstname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        contact.contactLastname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        contact.contactCompany = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        contact.AddressId =sqlite3_column_int(statement, 5);
        NSString *query2 = [NSString stringWithFormat:@"select * From ContactAddress where projectID = %ld and contactId = %ld;", (long)projectID, (long)contact.id];
        int result = sqlite3_prepare(database, [query2 UTF8String], -1, &statement2, NULL);
        if (result != SQLITE_OK)
        {
            NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
            return nil;
        }
// projectId, contactId, address1, address2, city, state, zip, country, phone, fax, mobile, pager, tollfree, home, email, website, type
        if (sqlite3_step(statement2) == SQLITE_ROW)
        {
            NoteAddress *address = [[NoteAddress alloc] init];
            address.address1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 2)];
            address.address2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 3)];
            address.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 4)];
            address.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 5)];
            address.zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 6)];
            address.country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 7)];
            ContactAddressObject *contactAddress = [[ContactAddressObject alloc] init];
            contactAddress.phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 8)];
            contactAddress.fax = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 9)];
            contactAddress.mobile = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 10)];
            contactAddress.pager = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 11)];
            contactAddress.tollFree = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 12)];
            contactAddress.home = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 13)];
            contactAddress.email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 14)];
            contactAddress.website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 15)];
            contactAddress.type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement2, 16)];
            contactAddress.address = address;
            [contact.contactAddresses addObject:contactAddress];
        }
        sqlite3_finalize(statement2);

        [contacts addObject:contact];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return contacts;
    
}

- (void) insertSystemPhases:(SystemPhase *) systemPhaseObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO systemPhases (userId, projectId, phaseName, phaseId, systemName, systemId) VALUES (?, ?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    str = @"";
    if (systemPhaseObject.systemName != nil)
    {
        str = systemPhaseObject.systemName;
    }
    sqlite3_bind_text(stmt, 3, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 4, (int)systemPhaseObject.systemId);
    str = @"";
    if (systemPhaseObject.phaseName != nil)
    {
        str = systemPhaseObject.phaseName;
    }
    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 6, (int)systemPhaseObject.phaseId);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteSystemPhases:(NSInteger) projectId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From systemPhases where userId = %ld and projectId = %ld", (long) userID, (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getSystemPhases: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From systemPhases where userID = %ld and projectId = %ld;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        SystemPhase *systemPhase = [[SystemPhase alloc] init];
        systemPhase.systemName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        systemPhase.systemId = sqlite3_column_int(statement, 3);
        systemPhase.phaseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        systemPhase.phaseId = sqlite3_column_int(statement, 5);

        [uploads addObject:systemPhase];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (void) insertDailyReports:(DailyReportObject *) drObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;

//userId, projectId, id, number, revision, subject, date, enteredBy, timeOnSite, timeOffSite, weatherIcon, weatherId, windId, temperature
// communicationWithOthers, scheduleCoordination, extraWork, extraWorkIsInternal, accidentReport accidentReportIsInternal, subcontractors, subcontractorsIsInternal, otherVisitors, otherVisitorsIsInternal, problems, problemsIsInternal, internal
    const char *sql = "INSERT INTO DailyReports (userId, projectId, id, number, revision, subject, date, enteredBy, timeOnSite, timeOffSite, weatherIcon, weatherId, windId, temperature, employeeFromId, drCopyId, communicationWithOthers, scheduleCoordination, extraWork, extraWorkIsInternal, accidentReport, accidentReportIsInternal, subcontractors, subcontractorsIsInternal, otherVisitors, otherVisitorsIsInternal, problems, problemsIsInternal, internal, isEditable) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)drObject.id);
    str = @"";
    if (drObject.number != nil)
    {
        str = drObject.number;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.revision != nil)
    {
        str = drObject.revision;
    }
    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.subject != nil)
    {
        str = drObject.subject;
    }
    sqlite3_bind_text(stmt, 6, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.date != nil)
    {
        str = drObject.date;
    }
    sqlite3_bind_text(stmt, 7, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 8, (int)drObject.enteredBy);
    str = @"";
    if (drObject.timeOnSite != nil)
    {
        str = drObject.timeOnSite;
    }
    sqlite3_bind_text(stmt, 9, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.timeOffSite != nil)
    {
        str = drObject.timeOffSite;
    }
    sqlite3_bind_text(stmt, 10, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.weatherIcon != nil)
    {
        str = drObject.weatherIcon;
    }
    sqlite3_bind_text(stmt, 11, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 12, (int)drObject.weatherId);
    sqlite3_bind_int(stmt, 13, (int)drObject.windId);
    sqlite3_bind_int(stmt, 14, (int)drObject.temperature);
    sqlite3_bind_int(stmt, 15, (int)drObject.employeeFromId);
    sqlite3_bind_int(stmt, 16, (int)drObject.drCopyId);

//communicationWithOthers, scheduleCoordination, extraWork, extraWorkIsInternal, accidentReport accidentReportIsInternal, subcontractors, subcontractorsIsInternal, otherVisitors, otherVisitorsIsInternal, problems, problemsIsInternal, internal
    
    str = @"";
    if (drObject.communicationWithOthers != nil)
    {
        str = drObject.communicationWithOthers;
    }
    sqlite3_bind_text(stmt, 17, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.scheduleCoordination != nil)
    {
        str = drObject.scheduleCoordination;
    }
    sqlite3_bind_text(stmt, 18, [str UTF8String], -1, NULL);
    str = @"";
    if (drObject.extraWork != nil)
    {
        str = drObject.extraWork;
    }
    sqlite3_bind_text(stmt, 19, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 20, (int)drObject.extraWorkIsInternal);
    str = @"";
    if (drObject.accidentReport != nil)
    {
        str = drObject.accidentReport;
    }
    sqlite3_bind_text(stmt, 21, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 22, (int)drObject.accidentReportIsInternal);
    str = @"";
    if (drObject.subcontractors != nil)
    {
        str = drObject.subcontractors;
    }
    sqlite3_bind_text(stmt, 23, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 24, (int)drObject.subcontractorsIsInternal);
    str = @"";
    if (drObject.otherVisitors != nil)
    {
        str = drObject.otherVisitors;
    }
    sqlite3_bind_text(stmt, 25, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 26, (int)drObject.otherVisitorsIsInternal);
    str = @"";
    if (drObject.problems != nil)
    {
        str = drObject.problems;
    }
    sqlite3_bind_text(stmt, 27, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 28, (int)drObject.problemsIsInternal);
    str = @"";
    if (drObject.internal != nil)
    {
        str = drObject.internal;
    }
    sqlite3_bind_text(stmt, 29, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 30, (int)drObject.isEditable);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);

}

- (void) deleteDailyReports:(NSInteger) projectId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From DailyReports where userId = %ld and projectId = %ld and number != 'This DR has not been saved'", (long) userID, (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (void) deleteDailyReport:(NSInteger) projectId forUserID: (NSInteger) userID forDRId: (NSInteger) drId
{
    
    NSString *query = [NSString stringWithFormat:@"delete From DailyReports where userId = %ld and projectId = %ld and id = %ld", (long) userID, (long)projectId, (long) drId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}


- (NSMutableArray *) getDailyReports: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From DailyReports where userID = %ld and projectId = %ld order by id desc;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        DailyReportObject *drObject = [[DailyReportObject alloc] init];
        drObject.projectId = sqlite3_column_int(statement, 1);
        drObject.id = sqlite3_column_int(statement, 2);
        drObject.number = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        drObject.revision = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        drObject.subject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        drObject.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        drObject.enteredBy = sqlite3_column_int(statement, 7);
        drObject.timeOnSite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        drObject.timeOnSite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        drObject.weatherIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        drObject.weatherId = sqlite3_column_int(statement, 11);
        drObject.windId = sqlite3_column_int(statement, 12);
        drObject.temperature = sqlite3_column_int(statement, 13);
        drObject.employeeFromId = sqlite3_column_int(statement, 14);
        drObject.drCopyId = sqlite3_column_int(statement, 15);
        drObject.communicationWithOthers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
        drObject.scheduleCoordination = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
        drObject.extraWork = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
        drObject.extraWorkIsInternal = sqlite3_column_int(statement, 19);
        drObject.accidentReport = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
        drObject.accidentReportIsInternal = sqlite3_column_int(statement, 21);
        drObject.subcontractors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
        drObject.subcontractorsIsInternal = sqlite3_column_int(statement, 23);
        drObject.otherVisitors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
        drObject.otherVisitorsIsInternal = sqlite3_column_int(statement, 25);
        drObject.problems = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
        drObject.problemsIsInternal = sqlite3_column_int(statement, 27);
        drObject.internal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
        drObject.isEditable = sqlite3_column_int(statement, 29);
        
        [uploads addObject:drObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (DailyReportObject *) getDailyReport: (NSInteger) userId forProjectId: (NSInteger) projectID forDRId: (NSInteger) drId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From DailyReports where userID = %ld and projectId = %ld and id = %ld;", (long)userId, (long) projectID, (long) drId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        DailyReportObject *drObject = [[DailyReportObject alloc] init];
        drObject.projectId = sqlite3_column_int(statement, 1);
        drObject.id = sqlite3_column_int(statement, 2);
        drObject.number = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        drObject.revision = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        drObject.subject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        drObject.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        drObject.enteredBy = sqlite3_column_int(statement, 7);
        drObject.timeOnSite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        drObject.timeOnSite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        drObject.weatherIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        drObject.weatherId = sqlite3_column_int(statement, 11);
        drObject.windId = sqlite3_column_int(statement, 12);
        drObject.temperature = sqlite3_column_int(statement, 13);
        drObject.employeeFromId = sqlite3_column_int(statement, 14);
        drObject.drCopyId = sqlite3_column_int(statement, 15);
        drObject.communicationWithOthers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
        drObject.scheduleCoordination = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
        drObject.extraWork = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
        drObject.extraWorkIsInternal = sqlite3_column_int(statement, 19);
        drObject.accidentReport = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
        drObject.accidentReportIsInternal = sqlite3_column_int(statement, 21);
        drObject.subcontractors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
        drObject.subcontractorsIsInternal = sqlite3_column_int(statement, 23);
        drObject.otherVisitors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
        drObject.otherVisitorsIsInternal = sqlite3_column_int(statement, 25);
        drObject.problems = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
        drObject.problemsIsInternal = sqlite3_column_int(statement, 27);
        drObject.internal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
        drObject.isEditable = sqlite3_column_int(statement, 29);

        sqlite3_finalize(statement);
        return drObject;
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return nil;
    
}

- (NSMutableArray *) getUnsavedDailyReportsObjects: (NSInteger) userId
{

    NSString *query = [NSString stringWithFormat:@"select * From DailyReports where userID = %ld and number == 'This DR has not been saved';", (long)userId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        DailyReportObject *drObject = [[DailyReportObject alloc] init];
        drObject.projectId = sqlite3_column_int(statement, 1);
        drObject.id = sqlite3_column_int(statement, 2);
        drObject.number = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        drObject.revision = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        drObject.subject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        drObject.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        drObject.enteredBy = sqlite3_column_int(statement, 7);
        drObject.timeOnSite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        drObject.timeOnSite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        drObject.weatherIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        drObject.weatherId = sqlite3_column_int(statement, 11);
        drObject.windId = sqlite3_column_int(statement, 12);
        drObject.temperature = sqlite3_column_int(statement, 13);
        drObject.employeeFromId = sqlite3_column_int(statement, 14);
        drObject.drCopyId = sqlite3_column_int(statement, 15);
        drObject.communicationWithOthers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
        drObject.scheduleCoordination = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
        drObject.extraWork = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
        drObject.extraWorkIsInternal = sqlite3_column_int(statement, 19);
        drObject.accidentReport = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
        drObject.accidentReportIsInternal = sqlite3_column_int(statement, 21);
        drObject.subcontractors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
        drObject.subcontractorsIsInternal = sqlite3_column_int(statement, 23);
        drObject.otherVisitors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
        drObject.otherVisitorsIsInternal = sqlite3_column_int(statement, 25);
        drObject.problems = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
        drObject.problemsIsInternal = sqlite3_column_int(statement, 27);
        drObject.internal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
        drObject.isEditable = sqlite3_column_int(statement, 29);

        [uploads addObject:drObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;

}

- (void) updateDailyReport:(NSInteger) oldDRId forDR: (DailyReportObject *) dr
{
    
    char *errMsg = NULL;
// userId INTEGER, projectId INTEGER, id INTEGER, number text, revision text, subject text, date text, enteredBy INTEGER, timeOnSite text, timeOffSite text, weatherIcon text, weatherId INTEGER, windId INTEGER, temperature INTEGER, employeeFromId INTEGER, drCopyId INTEGER
    
    NSString *query = [NSString stringWithFormat:@"UPDATE DailyReports set id = %ld, number = '%@', subject = '%@' where id = %ld;", (long) dr.id, dr.number, dr.subject, (long) oldDRId];
    sqlite3_stmt *statement;
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL );
    
    if((sqlite3_step(statement)) != SQLITE_DONE)
    {
        NSLog(@"SQL updateDailyReport: %@/n", query);
        NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
    }
    
    NSLog(@"updateDailyReport - number of rows updated %d", sqlite3_changes(database));
    
    sqlite3_finalize(statement);
    
    return;
    
}


- (void) insertActivity:(ActivityObject *) activityObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO Activity (userId, projectId, id, code, name) VALUES (?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)activityObject.id);
    str = @"";
    if (activityObject.code != nil)
    {
        str = activityObject.code;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    str = @"";
    if (activityObject.name != nil)
    {
        str = activityObject.name;
    }
    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteActivity:(NSInteger) projectId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From Activity where userId = %ld and projectId = %ld", (long) userID, (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getActivity: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From Activity where userID = %ld and projectId = %ld;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        ActivityObject *activityObject = [[ActivityObject alloc] init];
        activityObject.id =  sqlite3_column_int(statement, 2);
        activityObject.code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        activityObject.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        [uploads addObject:activityObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (void) insertWorkType:(WorkTypeObject *) workTypeObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO WorkType (userId, projectId, id, type, show) VALUES (?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)workTypeObject.id);
    str = @"";
    if (workTypeObject.type != nil)
    {
        str = workTypeObject.type;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 5, (int)workTypeObject.show);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }

    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteWorkType:(NSInteger) projectId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From WorkType where userId = %ld and projectId = %ld", (long) userID, (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getWorkType: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From WorkType where userID = %ld and projectId = %ld order by id desc;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        WorkTypeObject *workTypeObject = [[WorkTypeObject alloc] init];
        workTypeObject.id = sqlite3_column_int(statement, 2);
        workTypeObject.type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        workTypeObject.show = sqlite3_column_int(statement, 4);
        [uploads addObject:workTypeObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (void) insertEmployee:(EmployeeObject *) employeeObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO Employee (userId, projectId, id, first, last, laborClassId, number) VALUES (?, ?, ?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)employeeObject.id);
    str = @"";
    if (employeeObject.firstName != nil)
    {
        str = employeeObject.firstName;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    str = @"";
    if (employeeObject.lastName != nil)
    {
        str = employeeObject.lastName;
    }
    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 6, (int)employeeObject.laborClassId);
    str = @"";
    if (employeeObject.number != nil)
    {
        str = employeeObject.number;
    }
    sqlite3_bind_text(stmt, 7, [str UTF8String], -1, NULL);
    
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteEmployee:(NSInteger) projectId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From Employee where userId = %ld and projectId = %ld", (long) userID, (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getEmployee: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From Employee where userID = %ld and projectId = %ld order by id desc;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        EmployeeObject *employeeObject = [[EmployeeObject alloc] init];
        employeeObject .id = sqlite3_column_int(statement, 2);
        employeeObject.firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        employeeObject.lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        employeeObject.laborClassId = sqlite3_column_int(statement, 5);
        employeeObject.number = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        [uploads addObject:employeeObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (void) insertCompanyPreferences:(CompanyPreferencesObject *) companyPreferencesObject forProjectId: (NSInteger) projectId userId: (NSInteger) userId
{
    
    sqlite3_stmt *stmt = nil;
    
    const char *sql = "INSERT INTO CompanyPreferences (userId, projectId, dailyReportOvertimeEnabled, dailyReportDoubleTimeEnabled, dailyReportUnitTrackingEnabled,dailyReportEquipment,dailyReportMaterials) VALUES (?, ?, ?, ?, ?,?,?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userId);
    sqlite3_bind_int(stmt, 2, (int)projectId);
    sqlite3_bind_int(stmt, 3, (int)companyPreferencesObject.dailyReportOvertimeEnabled);
    sqlite3_bind_int(stmt, 4, (int)companyPreferencesObject.dailyReportDoubleTimeEnabled);
    sqlite3_bind_int(stmt, 5, (int)companyPreferencesObject.dailyReportUnitTrackingEnabled);
    sqlite3_bind_int(stmt, 6, (int)companyPreferencesObject.dailyReportEquipmentEnabled);
    sqlite3_bind_int(stmt, 7, (int)companyPreferencesObject.dailyReportMaterialsEnabled);
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteCompanyPreferences:(NSInteger) projectId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From CompanyPreferences where userId = %ld and projectId = %ld", (long) userID, (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (CompanyPreferencesObject *) getCompanyPreferences: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From CompanyPreferences where userID = %ld and projectId = %ld;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        CompanyPreferencesObject *companyPreferencesObject = [[CompanyPreferencesObject alloc] init];
        companyPreferencesObject.dailyReportOvertimeEnabled = sqlite3_column_int(statement, 2);
        companyPreferencesObject.dailyReportDoubleTimeEnabled = sqlite3_column_int(statement, 3);
        companyPreferencesObject.dailyReportUnitTrackingEnabled = sqlite3_column_int(statement, 4);
        companyPreferencesObject.dailyReportEquipmentEnabled = sqlite3_column_int(statement, 5);
        companyPreferencesObject.dailyReportMaterialsEnabled = sqlite3_column_int(statement, 6);
        sqlite3_finalize(statement);
        return companyPreferencesObject;
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return nil;
    
}

- (NSMutableArray *) getUnsavedUploadAttachmentPhotoObjects: (NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From UploadObject where userID = %ld and description = 'This attachment/photo has not been saved'", (long)userId];
    
    return [self getUploadAttachmentPhotoObjects:query];
    
}

- (NSMutableArray *) getUploadAttachmentPhotoObjects: (NSInteger) userId forProjectId: (NSInteger) projectID forDailyReport: (NSInteger) drId
{
   
    NSString *query = [NSString stringWithFormat:@"select * From UploadObject where userID = %ld and projectId = %ld and dailyReportId = %ld order by uploadId desc;", (long)userId, (long) projectID, (long) drId];
    
    //    NSString *query = [NSString stringWithFormat:@"select * From UploadObject"];

    return [self getUploadAttachmentPhotoObjects:query];

}

- (NSMutableArray *) getUploadAttachmentPhotoObjects: (NSString *) query
{
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        UploadObject *uploadObject = [[UploadObject alloc] init];
        uploadObject.uploadProjectId = sqlite3_column_int(statement, 1);
        uploadObject.uploadId = sqlite3_column_int(statement, 2);
        uploadObject.uploadMimetype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        uploadObject.uploadFilename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        uploadObject.uploadSize = sqlite3_column_int(statement, 5);
        uploadObject.uploadUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        uploadObject.uploadThumbnail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        uploadObject.uploadDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        uploadObject.uploadDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        uploadObject.uploadCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        uploadObject.uploadDocumentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        uploadObject.uploadDocumentId = sqlite3_column_int(statement, 12);
        uploadObject.dailyReportId = sqlite3_column_int(statement, 13);
        uploadObject.localFileStoreName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
        
        [uploads addObject:uploadObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (NSMutableArray *) getUploadObjects: (NSInteger) userId forProjectId: (NSInteger) projectID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From UploadObject where userID = %ld and projectId = %ld order by uploadId desc;", (long)userId, (long) projectID];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        UploadObject *uploadObject = [[UploadObject alloc] init];
        uploadObject.uploadProjectId = sqlite3_column_int(statement, 1);
        uploadObject.uploadId = sqlite3_column_int(statement, 2);
        uploadObject.uploadMimetype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        uploadObject.uploadFilename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        uploadObject.uploadSize = sqlite3_column_int(statement, 5);
        uploadObject.uploadUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        uploadObject.uploadThumbnail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        uploadObject.uploadDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        uploadObject.uploadDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        uploadObject.uploadCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        uploadObject.uploadDocumentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        uploadObject.uploadDocumentId = sqlite3_column_int(statement, 12);
        uploadObject.dailyReportId = sqlite3_column_int(statement, 13);

        [uploads addObject:uploadObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (void) insertUploadObject: (UploadObject *) uploadObject forUserID: (NSInteger) userID
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO UploadObject (userId, projectId, uploadId,  mimetype, filename, size, url, thumbnail, date, description, category, documentType, documentId, dailyReportId, localFileStoreName) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)userID);
    sqlite3_bind_int(stmt, 2, (int)uploadObject.uploadProjectId);
    sqlite3_bind_int(stmt, 3, (int)uploadObject.uploadId);
    str = @"";
    if (uploadObject.uploadMimetype != nil)
    {
        str = uploadObject.uploadMimetype;
    }
    sqlite3_bind_text(stmt, 4, [str UTF8String], -1, NULL);
    str = @"";
    if (uploadObject.uploadFilename != nil)
    {
        str = uploadObject.uploadFilename;
    }
    sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 6, (int)uploadObject.uploadSize);
    str = @"";
    if (uploadObject.uploadUrl != nil)
    {
        str = uploadObject.uploadUrl;
    }
    sqlite3_bind_text(stmt, 7, [str UTF8String], -1, NULL);
    str = @"";
    if (uploadObject.uploadThumbnail != nil)
    {
        str = uploadObject.uploadThumbnail;
    }
    sqlite3_bind_text(stmt, 8, [str UTF8String], -1, NULL);
    str = @"";
    if (uploadObject.uploadDate != nil)
    {
        str = uploadObject.uploadDate;
    }
    sqlite3_bind_text(stmt, 9, [str UTF8String], -1, NULL);
    str = @"";
    if (uploadObject.uploadDescription != nil)
    {
        str = uploadObject.uploadDescription;
    }
    sqlite3_bind_text(stmt, 10, [str UTF8String], -1, NULL);
    str = @"";
    if (uploadObject.uploadCategory != nil)
    {
        str = uploadObject.uploadCategory;
    }
    sqlite3_bind_text(stmt, 11, [str UTF8String], -1, NULL);
    str = @"";
    if (uploadObject.uploadDocumentType != nil)
    {
        str = uploadObject.uploadDocumentType;
    }
    sqlite3_bind_text(stmt, 12, [str UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 13, (int)uploadObject.uploadDocumentId);
    sqlite3_bind_int(stmt, 14, (int)uploadObject.dailyReportId);
    str = @"";
    if (uploadObject.localFileStoreName != nil)
    {
        str = uploadObject.localFileStoreName;
    }
    sqlite3_bind_text(stmt, 15, [str UTF8String], -1, NULL);

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }

    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
}

- (void) deleteUploadObject:(NSInteger) projectId andUploadId: (NSInteger) uploadId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From UploadObject where userId = %ld and projectId = %ld and uploadId = %ld;", (long) userID, (long)projectId, (long)uploadId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (void) deleteUnsavedUploadObjects:(NSInteger) userId forProjectId: (NSInteger) projectId forDailyReportId: (NSInteger) drId
{
    
    NSString *query = [NSString stringWithFormat:@"delete From UploadObject where userId = %ld and projectId = %ld and dailyReportId = %ld and description <> 'This attachment/photo has not been saved'", (long) userId, (long)projectId, (long)drId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (void) updateUploadObjecstWithNewDRId: (NSInteger) newDRId forOldDRIdId: (NSInteger) oldDRId
{
    
    char *errMsg = NULL;
    NSString *query = [NSString stringWithFormat:@"UPDATE UploadObject set dailyReportId = %ld where dailyReportId = %ld and documentType = 'DailyReport';", (long) newDRId, (long) oldDRId];
    sqlite3_stmt *statement;
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL );
    
    if((sqlite3_step(statement)) != SQLITE_DONE)
    {
        NSLog(@"SQL updateUploadObjectsWithNewDRId: %@/n", query);
        NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
    }
    
    NSLog(@"updateUploadObjectsWithNewDRId - number of rows updated %d", sqlite3_changes(database));
    
    sqlite3_finalize(statement);
    
    return;
    
}


- (NSUInteger) insertUploadThumbnail:(UploadObject *) uploadObject forUserID: (NSInteger) userID withData: (NSData *) upload
{
    
    sqlite3_stmt *updStmt = nil;
    
    const char *sql = "INSERT INTO UploadsThumbnails (userId, projectId, uploadId, image) VALUES (?, ?, ?, ?);";
    int res = sqlite3_prepare_v2(database, sql, -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }

    sqlite3_bind_int(updStmt, 1, (int)userID);
    sqlite3_bind_int(updStmt, 2, (int)uploadObject.uploadProjectId);
    sqlite3_bind_int64(updStmt, 3, (int)uploadObject.uploadId);
    sqlite3_bind_blob(updStmt, 4, [upload bytes], (int)[upload length] , SQLITE_TRANSIENT);
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(updStmt);
        return 0;
    }
    
    sqlite3_reset(updStmt);
    
    sqlite3_finalize(updStmt);
    return ((NSUInteger) sqlite3_last_insert_rowid(database));
    
}

- (UIImage *) getUploadThumbNail: (UploadObject *) uploadObject forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"select image from UploadsThumbnails where userId = %ld and projectId = %ld and uploadId = %ld;", (long)userID, (long)uploadObject.uploadProjectId, (unsigned long)uploadObject.uploadId];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];
        
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        sqlite3_finalize(statement);
        return img;
    }
    
    sqlite3_finalize(statement);
    return nil;
    
}

- (NSMutableArray *) getUnsavedUploadObjects:(NSInteger) projectId forUserID: (NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From UploadObject where projectId = %ld and userID = %ld and date = 'This upload hasn''t been saved' order by uploadId desc;", (long) projectId, (long)userId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        UploadObject *uploadObject = [[UploadObject alloc] init];
        uploadObject.uploadProjectId = sqlite3_column_int(statement, 1);
        uploadObject.uploadId = sqlite3_column_int(statement, 2);
        uploadObject.uploadMimetype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        uploadObject.uploadFilename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        uploadObject.uploadSize = sqlite3_column_int(statement, 5);
        uploadObject.uploadUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        uploadObject.uploadThumbnail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        uploadObject.uploadDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        uploadObject.uploadDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        uploadObject.uploadCategory = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        uploadObject.uploadDocumentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        uploadObject.uploadDocumentId = sqlite3_column_int(statement, 12);
        
        [uploads addObject:uploadObject];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return uploads;
    
}

- (NSUInteger) insertNoteThumbNail: (NSData *) imageData
{
    
    sqlite3_stmt *updStmt = nil;
    
    const char *sql = "INSERT INTO NoteThumbNails (image) VALUES (?);";
    int res = sqlite3_prepare_v2(database, sql, -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_blob(updStmt, 1, [imageData bytes], (int)[imageData length] , SQLITE_TRANSIENT);
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(updStmt);
        return 0;
    }
    
    sqlite3_reset(updStmt);

    sqlite3_finalize(updStmt);
    return ((NSUInteger) sqlite3_last_insert_rowid(database));
    
}

- (UIImage *) getNoteThumbNail: (NSNumber *) index
{
    
    NSString *query = [NSString stringWithFormat:@"select image from NoteThumbNails where id = %@;", index];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];
        
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        sqlite3_finalize(statement);
        return img;
    }

    sqlite3_finalize(statement);
    return nil;
    
}

- (NSData *) getNoteThumbNailData: (NSNumber *) index
{
    
    NSString *query = [NSString stringWithFormat:@"select image from NoteThumbNails where id = %@;", index];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];
        NSLog(@"Image data length : %d", len);
        sqlite3_finalize(statement);
        return imgData;
    }

    sqlite3_finalize(statement);
    return nil;
    
}

- (NSUInteger) insertRFIThumbNail: (NSData *) imageData
{
    
    sqlite3_stmt *updStmt = nil;
    
    const char *sql = "INSERT INTO RFIThumbNails (image) VALUES (?);";
    int res = sqlite3_prepare_v2(database, sql, -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_blob(updStmt, 1, [imageData bytes], (int)[imageData length] , SQLITE_TRANSIENT);
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(updStmt);
        return 0;
    }
    
    sqlite3_reset(updStmt);
    
    sqlite3_finalize(updStmt);
    return ((NSUInteger) sqlite3_last_insert_rowid(database));
    
}

- (UIImage *) getRFIThumbNail: (NSNumber *) index
{
    
    NSString *query = [NSString stringWithFormat:@"select image from RFIThumbNails where id = %@;", index];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];
        
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        sqlite3_finalize(statement);
        return img;
    }
    
    sqlite3_finalize(statement);
    return nil;
    
}

- (NSData *) getRFIThumbNailData: (NSNumber *) index
{
    
    NSString *query = [NSString stringWithFormat:@"select image from RFIThumbNails where id = %@;", index];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];
        NSLog(@"Image data length : %d", len);
        sqlite3_finalize(statement);
        return imgData;
    }
    
    sqlite3_finalize(statement);
    return nil;
    
}

- (NSUInteger) insertNoteImage: (NSData *) imageData
{

    sqlite3_stmt *updStmt = nil;
    
    const char *sql = "INSERT INTO NoteImages (image) VALUES (?);";
    int res = sqlite3_prepare_v2(database, sql, -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_blob(updStmt, 1, [imageData bytes], (int)[imageData length] , SQLITE_TRANSIENT);
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(updStmt);
        return 0;
    }
    
    sqlite3_reset(updStmt);

    sqlite3_finalize(updStmt);
    return ((NSUInteger) sqlite3_last_insert_rowid(database));
    
}

- (UIImage *) getNoteImage: (NSNumber *) index
{
    
    NSString *query = [NSString stringWithFormat:@"select image from NoteImages where id = %@;", index];

    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }

    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];

        UIImage *img = [[UIImage alloc] initWithData:imgData];
        sqlite3_finalize(statement);
        return img;
    }

    sqlite3_finalize(statement);
    return nil;

}

- (NSData *) getNoteImageData: (NSNumber *) index
{
    
    NSString *query = [NSString stringWithFormat:@"select image from NoteImages where id = %@;", index];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        int len = sqlite3_column_bytes(statement, 0);
        NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:len];
        NSLog(@"Image data length : %d", len);
        sqlite3_finalize(statement);
        return imgData;
    }

    sqlite3_finalize(statement);
    return nil;
    
}

- (void) insertNoteObject: (NoteObject *) noteObject forUserID: (NSInteger) userID
{
    
    sqlite3_stmt *stmt = nil;
    NSString *str;
    
    const char *sql = "INSERT INTO NoteObject (userId, projectId, noteId, date, title, description, address1, address2, city, state, zip, country, longitude, latitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    const char *sql2 = "INSERT INTO ListOfImages (projectID, noteID, imageID) VALUES (?, ?, ?);";
    const char *sql3 = "INSERT INTO ListOfThumbNails (projectID, noteID, imageID) VALUES (?, ?, ?);";
    const char *sql4 = "INSERT INTO Attachments (userId, projectId, noteId, id, mimtype, fileName, size, url, thumbNail, attachmentDate, description, documentType, documentId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
    int res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }

    sqlite3_bind_int(stmt, 1, (int)userID);
    sqlite3_bind_int(stmt, 2, (int)noteObject.projectId);
    sqlite3_bind_int(stmt, 3, (int)noteObject.id);
    sqlite3_bind_text(stmt, 4, [noteObject.noteDate UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [noteObject.notetitle UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 6, [noteObject.noteDescription UTF8String], -1, NULL);
    str = @"";
    if (noteObject.noteLocation.address.address1 != nil)
    {
        str = noteObject.noteLocation.address.address1;
    }
    sqlite3_bind_text(stmt, 7, [str UTF8String], -1, NULL);
    str = @"";
    if (noteObject.noteLocation.address.address2 != nil)
    {
        str = noteObject.noteLocation.address.address2;
    }
    sqlite3_bind_text(stmt, 8, [str UTF8String], -1, NULL);
    str = @"";
    if (noteObject.noteLocation.address.city != nil)
    {
        str = noteObject.noteLocation.address.city;
    }
    sqlite3_bind_text(stmt, 9, [str UTF8String], -1, NULL);
    str = @"";
    if (noteObject.noteLocation.address.state != nil)
    {
        str = noteObject.noteLocation.address.state;
    }
    sqlite3_bind_text(stmt, 10, [str UTF8String], -1, NULL);
    str = @"";
    if (noteObject.noteLocation.address.zip != nil)
    {
        str = noteObject.noteLocation.address.zip;
    }
    sqlite3_bind_text(stmt, 11, [str UTF8String], -1, NULL);
    str = @"";
    if (noteObject.noteLocation.address.country != nil)
    {
        str = noteObject.noteLocation.address.country;
    }
    sqlite3_bind_text(stmt, 12, [str UTF8String], -1, NULL);

    sqlite3_bind_double(stmt, 13, noteObject.noteLocation.location.longitude);
    sqlite3_bind_double(stmt, 14, noteObject.noteLocation.location.latitude);
    
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }

    sqlite3_reset(stmt);
    NSMutableArray *attachments = noteObject.noteAttachments;
    
    for (NoteAttachment *attachment in attachments)
    {
        sqlite3_prepare_v2(database, sql4, -1, &stmt, NULL);
        sqlite3_bind_int(stmt, 1, (int)userID);
        sqlite3_bind_int(stmt, 2, (int)noteObject.projectId);
        sqlite3_bind_int(stmt, 3, (int)noteObject.id);
        sqlite3_bind_int(stmt, 4, (int)attachment.attachmentId);
        str = @"";
        if (attachment.attachmentMimetype != nil)
        {
            str = attachment.attachmentMimetype;
        }
        sqlite3_bind_text(stmt, 5, [str UTF8String], -1, NULL);
        str = @"";
        if (attachment.attachmentFilename != nil)
        {
            str = attachment.attachmentFilename;
        }
        sqlite3_bind_text(stmt, 6, [str UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 7, (int)attachment.attachmentSize);
        str = @"";
        if (attachment.attachmentUrl != nil)
        {
            str = attachment.attachmentUrl;
        }
        sqlite3_bind_text(stmt, 8, [str UTF8String], -1, NULL);
        str = @"";
        if (attachment.attachmentThumbnail != nil)
        {
            str = attachment.attachmentThumbnail;
        }
        sqlite3_bind_text(stmt, 9, [str UTF8String], -1, NULL);
        str = @"";
        if (attachment.attachmentDate != nil)
        {
            str = attachment.attachmentDate;
        }
        sqlite3_bind_text(stmt, 10, [str UTF8String], -1, NULL);
        str = @"";
        if (attachment.attachmentDescription != nil)
        {
            str = attachment.attachmentDescription;
        }
        sqlite3_bind_text(stmt, 11, [str UTF8String], -1, NULL);
        str = @"";
        if (attachment.attachmentDocumentType != nil)
        {
            str = attachment.attachmentDocumentType;
        }
        sqlite3_bind_text(stmt, 12, [str UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 13, (int)attachment.attachmentDocumentId);

        if((res = sqlite3_step(stmt)) != SQLITE_DONE)
        {
            NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
            sqlite3_reset(stmt);
            return;
        }
        sqlite3_reset(stmt);
    }
    
    for ( NSNumber *i in noteObject.noteImages)
    {
        sqlite3_prepare_v2(database, sql2, -1, &stmt, NULL);
        sqlite3_bind_int(stmt, 1, (int)noteObject.projectId);
        sqlite3_bind_int(stmt, 2, (int)noteObject.id);
        sqlite3_bind_int(stmt, 3, [i intValue]);
        if((res = sqlite3_step(stmt)) != SQLITE_DONE)
        {
            NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
            sqlite3_reset(stmt);
            return;
        }
        sqlite3_reset(stmt);
    }

    for ( NSNumber *i in noteObject.noteThumbNails)
    {
        sqlite3_prepare_v2(database, sql3, -1, &stmt, NULL);
        sqlite3_bind_int(stmt, 1, (int)noteObject.projectId);
        sqlite3_bind_int(stmt, 2, (int)noteObject.id);
        sqlite3_bind_int(stmt, 3, [i intValue]);
        if((res = sqlite3_step(stmt)) != SQLITE_DONE)
        {
            NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
            sqlite3_reset(stmt);
            return;
        }
        sqlite3_reset(stmt);
    }

    sqlite3_finalize(stmt);
    return;
    
}

- (NoteObject *) getNoteObject:(NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From NoteObject where userID = ? and projectId = ? and noteId = ?;"];
    NSString *query2 = [NSString stringWithFormat:@"select imageID From ListOfImages where projectID = ? and noteID = ?;"];
    NSString *query3 = [NSString stringWithFormat:@"select imageID From ListOfThumbNails where projectID = ? and noteID = ?;"];
    NSString *query4 = [NSString stringWithFormat:@"select * From Attachments where userId = ? and projectID = ? and noteID = ?;"];
    
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    sqlite3_stmt *statement4;

    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }

    sqlite3_bind_int(statement, 1, (int)userId);
    sqlite3_bind_int(statement, 2, (int)projectId);
    sqlite3_bind_int(statement, 3, (int)noteId);
    NoteObject *note;
    if ((result = sqlite3_step(statement)) != SQLITE_DONE)
    {
        note = [[NoteObject alloc] init];
        note.projectId = sqlite3_column_int(statement, 1);
        note.id = sqlite3_column_int(statement, 2);
        note.noteDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        note.notetitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        note.noteDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        note.noteLocation.address.address1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//        note.noteLocation.address.address2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        note.noteLocation.address.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        note.noteLocation.address.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        note.noteLocation.address.zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        note.noteLocation.address.country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        note.noteLocation.location.longitude = (float)sqlite3_column_double(statement, 12);
        note.noteLocation.location.latitude = (float)sqlite3_column_double(statement, 13);

        if (sqlite3_prepare(database, [query2 UTF8String], -1, &statement2, NULL) != SQLITE_OK)
        {
            NSLog(@"Database sqlite prepare for failed!");
            return nil;
        }

        NSMutableArray *images = [[NSMutableArray alloc] init];
        sqlite3_bind_int(statement2, 1, (int)note.projectId);
        sqlite3_bind_int(statement2, 2, (int)note.id);
        while (sqlite3_step(statement2) == SQLITE_ROW)
        {
            [images addObject:[[NSNumber alloc] initWithInt:sqlite3_column_int(statement2, 0)]];
        }
        sqlite3_finalize(statement2);
        note.noteImages = images;

        if (sqlite3_prepare(database, [query3 UTF8String], -1, &statement3, NULL) != SQLITE_OK)
        {
            NSLog(@"Database sqlite prepare for failed!");
            return nil;
        }
        
        NSMutableArray *thumbsNails = [[NSMutableArray alloc] init];
        sqlite3_bind_int(statement3, 1, (int)note.projectId);
        sqlite3_bind_int(statement3, 2, (int)note.id);
        while (sqlite3_step(statement3) == SQLITE_ROW)
        {
            [thumbsNails addObject:[[NSNumber alloc] initWithInt:sqlite3_column_int(statement3, 0)]];
        }

        sqlite3_finalize(statement3);
        note.noteThumbNails = thumbsNails;

        if (sqlite3_prepare(database, [query4 UTF8String], -1, &statement4, NULL) != SQLITE_OK)
        {
            NSLog(@"Database sqlite prepare for failed!");
            return nil;
        }

        NSMutableArray *attachments = [[NSMutableArray alloc] init];
        sqlite3_bind_int(statement4, 1, (int)userId);
        sqlite3_bind_int(statement4, 2, (int)projectId);
        sqlite3_bind_int(statement4, 3, (int)noteId);

        while (sqlite3_step(statement4) == SQLITE_ROW)
        {
            NoteAttachment *attachment = [[NoteAttachment alloc] init];
            attachment.attachmentId = sqlite3_column_int(statement4, 3);
            attachment.attachmentMimetype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 4)];
            attachment.attachmentFilename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 5)];
            attachment.attachmentSize = sqlite3_column_int(statement4, 6);
            attachment.attachmentUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 7)];
            attachment.attachmentThumbnail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 8)];
            attachment.attachmentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 9)];
            attachment.attachmentDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 10)];
            attachment.attachmentProjectId = sqlite3_column_int(statement4, 11);
            attachment.attachmentDocumentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement4, 12)];
            attachment.attachmentDocumentId = sqlite3_column_int(statement4, 13);
            [attachments addObject:attachment];
        }
        sqlite3_finalize(statement4);
        note.noteAttachments = attachments;

    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return note;
    
}

- (NSMutableArray *) getNoteObjects: (NSInteger) projectId forUserId: (NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From NoteObject where userID = %ld and projectId = %ld order by noteId desc;", (long)userId, (long)projectId];
//    NSString *query2 = [NSString stringWithFormat:@"select imageID From ListOfImages where noteID = ?;"];
    
    sqlite3_stmt *statement;
//    sqlite3_stmt *statement2;

    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
/*
        NoteObject *note = [[NoteObject alloc] init];
        note.projectId = sqlite3_column_int(statement, 1);
        note.id = sqlite3_column_int(statement, 2);
        note.noteDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        note.notetitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        note.noteDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        note.noteLocation.address.address1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        //        note.noteLocation.address.address2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        note.noteLocation.address.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        note.noteLocation.address.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        note.noteLocation.address.zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        note.noteLocation.address.country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        note.noteLocation.location.longitude = (float)sqlite3_column_double(statement, 12);
        note.noteLocation.location.latitude = (float)sqlite3_column_double(statement, 13);
        if (sqlite3_prepare(database, [query2 UTF8String], -1, &statement2, NULL) != SQLITE_OK)
        {
            NSLog(@"Database sqlite prepare for failed!");
            return nil;
        }
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        sqlite3_bind_int(statement2, 1, (int)note.id);
        while (sqlite3_step(statement2) == SQLITE_ROW)
        {
            [images addObject:[[NSNumber alloc] initWithInt:sqlite3_column_int(statement2, 0)]];
        }
        sqlite3_finalize(statement2);
        note.noteImages = images;
*/
        
        [notes addObject:[self getNoteObject:projectId andNoteId:sqlite3_column_int(statement, 2) forUserID:userId]];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return notes;
    
}

- (NSString *) getNoteDate: (NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userId
{
    NSString *query = [NSString stringWithFormat:@"select Date From NoteObject where userID = %ld and projectId = %ld  and noteId = %ld;", (long)userId, (long)projectId, (long) noteId];
    
    sqlite3_stmt *statement;
    //    sqlite3_stmt *statement2;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSString *date = @"";
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return date;
    
}

- (NSMutableArray *) getUnsavedNoteObjects: (NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From NoteObject where userID = %ld and date = 'This note hasn''t been saved' order by noteId desc;", (long)userId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NoteObject *note = [[NoteObject alloc] init];
        note.projectId = sqlite3_column_int(statement, 1);
        note.id = sqlite3_column_int(statement, 2);
        note.noteDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        note.notetitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        note.noteDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        note.noteLocation.address.address1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        //        note.noteLocation.address.address2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        note.noteLocation.address.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        note.noteLocation.address.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        note.noteLocation.address.zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        note.noteLocation.address.country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        note.noteLocation.location.longitude = (float)sqlite3_column_double(statement, 12);
        note.noteLocation.location.latitude = (float)sqlite3_column_double(statement, 13);
        [notes addObject:note];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return notes;
    
}


- (void) deleteNoteObject:(NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From NoteObject where userId = %ld and projectId = %ld and noteId = %ld;", (long) userID, (long)projectId, (long)noteId];

    sqlite3_stmt *updStmt = nil;

    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }

    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleteing: %s", sqlite3_errmsg(database));
    }

    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getUnsavedNoteImageObjects: (NSInteger) userId
{
    
    NSString *query = [NSString stringWithFormat:@"select * From NoteObject where userID = %ld and date = 'The image for this note has not been saved' order by noteId desc;", (long)userId];
    
    sqlite3_stmt *statement;
    
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
        return nil;
    }
    
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NSLog(@"UserId : %d", sqlite3_column_int(statement, 0));
        NoteObject *note = [[NoteObject alloc] init];
        note.projectId = sqlite3_column_int(statement, 1);
        note.id = sqlite3_column_int(statement, 2);
        note.noteDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        note.notetitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        note.noteDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        note.noteLocation.address.address1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        //        note.noteLocation.address.address2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        note.noteLocation.address.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        note.noteLocation.address.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        note.noteLocation.address.zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        note.noteLocation.address.country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        note.noteLocation.location.longitude = (float)sqlite3_column_double(statement, 12);
        note.noteLocation.location.latitude = (float)sqlite3_column_double(statement, 13);
        [notes addObject:note];
    }
    
    // Clean up the select statement
    sqlite3_finalize(statement);
    
    return notes;
    
}


- (void) updateNoteObject: (NSInteger) projectId andNoteId: (NSInteger) noteId forUserID: (NSInteger) userID withDate: (NSString *) date
{
    
    char *errMsg = NULL;
    NSString *query = [NSString stringWithFormat:@"UPDATE NoteObject set date = '%@' where projectId = %ld and noteId = %ld and userId = %ld", date, (long) projectId, (long) noteId, (long) userID];
    sqlite3_stmt *statement;

    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL );
    
    if((sqlite3_step(statement)) != SQLITE_DONE)
    {
        NSLog(@"SQL updateNoteObject with date: %@/n", query);
        NSLog(@"Error : %@/n", [NSString stringWithUTF8String:errMsg]);
    }
    
    NSLog(@"updateNoteObject - number of rows updated %d", sqlite3_changes(database));

    sqlite3_finalize(statement);

    return;
    
}


- (void) insertProjectObject: (ProjectObject *) projectObject forUserID: (NSInteger) userID
{

    NSString *query = [NSString stringWithFormat:@"delete From ProjectObject where Id = %ld and userId = %ld;", (long)projectObject.id, (long)userID];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleting %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);

    sqlite3_stmt *stmt = nil;
    
    const char *sql = "INSERT INTO ProjectObject (userId, id, number, name, status, startDate, finishDate, projectManager, address1, address2, city, state, zip, country, longitude, latitude, comments) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";

    res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }

    sqlite3_bind_int(stmt, 1, (int)userID);
    sqlite3_bind_int(stmt, 2, (int)projectObject.id);
    
    if (projectObject.projectNumber != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 3, [projectObject.projectNumber UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 3, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectName != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 4, [projectObject.projectName UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 4, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectStatus != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 5, [projectObject.projectStatus UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 5, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectStartDate != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 6, [projectObject.projectStartDate UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 6, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectEndDate != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 7, [projectObject.projectEndDate UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 7, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectManager != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 8, [projectObject.projectManager UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 8, [@"" UTF8String], -1, NULL);
    }

    if (projectObject.projectLocation.address.address1 != (id)[NSNull null])
    {
    sqlite3_bind_text(stmt, 9, [projectObject.projectLocation.address.address1 UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 9, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectLocation.address.address2 != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 10, [projectObject.projectLocation.address.address2 UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 10, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectLocation.address.city != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 11, [projectObject.projectLocation.address.city UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 11, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectLocation.address.state != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 12, [projectObject.projectLocation.address.state UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 12, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectLocation.address.zip != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 13, [projectObject.projectLocation.address.zip UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 13, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectLocation.address.country != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 14, [projectObject.projectLocation.address.country UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 14, [@"" UTF8String], -1, NULL);
    }
    if (projectObject.projectLocation.location.longitude)
    {
        sqlite3_bind_double(stmt, 15, projectObject.projectLocation.location.longitude);
    }
    else
    {
        sqlite3_bind_double(stmt, 15, 0);
    }
    if (projectObject.projectLocation.location.latitude)
    {
        sqlite3_bind_double(stmt, 16, projectObject.projectLocation.location.latitude);
    }
    else
    {
        sqlite3_bind_double(stmt, 16, 0);
    }
    if (projectObject.projectComments != (id)[NSNull null])
    {
        sqlite3_bind_text(stmt, 17, [projectObject.projectComments UTF8String], -1, NULL);
    }
    else
    {
        sqlite3_bind_text(stmt, 17, [@"" UTF8String], -1, NULL);
    }

    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return;
    }
    
    sqlite3_reset(stmt);

    sqlite3_finalize(stmt);
    return;
    
}

- (void) deleteProjectObject:(NSInteger) projectId
{
    
    NSString *query = [NSString stringWithFormat:@"delete From ProjectObject where projectId = %ld;", (long)projectId];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleting %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);
    return;
    
}

- (NSMutableArray *) getProjectObjects: (NSInteger) userID
{

    NSString *query = [NSString stringWithFormat:@"select * From ProjectObject where userId = %ld order by id", (long)userID];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    NSMutableArray *projectObjects = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        ProjectObject *project = [[ProjectObject alloc] init];
        NoteLocation *noteLocation = [[NoteLocation alloc] init];
        project.id = sqlite3_column_int(statement, 1);
        project.projectNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        project.projectName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        project.projectStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        project.projectStartDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        project.projectEndDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        project.projectManager = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        noteLocation.address.address1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        noteLocation.address.address2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        noteLocation.address.city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        noteLocation.address.state = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        noteLocation.address.zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
        noteLocation.address.country = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
        noteLocation.location.longitude = (float)sqlite3_column_double(statement, 14);
        noteLocation.location.latitude = (float)sqlite3_column_double(statement, 15);
        project.projectLocation = noteLocation;
        project.projectComments = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
        [projectObjects addObject:project];
    }

    sqlite3_reset(statement);
    sqlite3_finalize(statement);

    return projectObjects;

}

- (void) insertUploadCategories: (NSMutableArray *) uploadCategories forUserID: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"delete From UploadCategories where userId = %ld;", (long)userID];
    
    sqlite3_stmt *updStmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &updStmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement:%s", sqlite3_errmsg(database));
        return;
    }
    
    if((res = sqlite3_step(updStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while deleting %s", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(updStmt);
    sqlite3_finalize(updStmt);

    sqlite3_stmt *statement;

    const char *sqlDB = "INSERT INTO UploadCategories (userId, id, name) VALUES (?, ?, ?);";
    if(sqlite3_prepare_v2(database, sqlDB, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s", sqlite3_errmsg(database));
    }

    sqlite3_exec(database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
    
    for (int i = 0; i < uploadCategories.count; i++)
    {

        UploadCategory *d = [uploadCategories objectAtIndex:i];

        sqlite3_bind_int(statement, 1, (int)userID);
        sqlite3_bind_int(statement, 2, (int)d.categoryId);
        sqlite3_bind_text(statement, 3, [d.categoryName UTF8String], -1, SQLITE_TRANSIENT);
    
        if (SQLITE_DONE != sqlite3_step(statement))
        {
            NSLog(@"Error while inserting data. %s", sqlite3_errmsg(database));
        }
        sqlite3_clear_bindings(statement);
        sqlite3_reset(statement);
        
    }
    
    if (sqlite3_exec(database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK)
    {
        NSLog(@"SQL Error: %s", sqlite3_errmsg(database));
    }

    sqlite3_finalize(statement);

    return;
    
}

- (NSMutableArray *) getUploadCategories: (NSInteger) userID
{
    
    NSString *query = [NSString stringWithFormat:@"select * From UploadCategories where userId = %ld order by id", (long)userID];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare(database, [query UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK)
    {
        NSLog(@"Database sqlite prepare for failed!");
        return nil;
    }
    
    NSMutableArray *uploadCategories = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        UploadCategory *categories = [[UploadCategory alloc] init];

        categories.categoryId = sqlite3_column_int(statement, 1);
        categories.categoryName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        [uploadCategories addObject:categories];
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    
    return uploadCategories;
    
}

- (NSUInteger) insertUser: (NSString *) subscriber forUserName: (NSString *) username andPassword: (NSString *) password
{
    
    NSString *query = [NSString stringWithFormat:@"select * From Users where subscriber = ? and username = ? and password = ?;"];
    
    sqlite3_stmt *stmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(stmt, 1, [subscriber UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [username UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [password UTF8String], -1, NULL);
    
    if (sqlite3_step(stmt) == SQLITE_ROW)
    {
        int i = sqlite3_column_int(stmt, 0);
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        return i;
    }
    
    const char *sql = "INSERT INTO Users (subscriber, secret, username, password) VALUES (?, ?, ?, ?);";
    res = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(stmt, 1, [subscriber UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [@"" UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [username UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [password UTF8String], -1, NULL);
    
    if((res = sqlite3_step(stmt)) != SQLITE_DONE)
    {
        NSLog(@"Error while inserting: %s", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        return 0;
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
    return ((NSUInteger) sqlite3_last_insert_rowid(database));
    
}

- (NSUInteger) checkForUser: (NSString *) subscriber forUserName: (NSString *) username andPassword: (NSString *) password
{
    
    NSString *query = [NSString stringWithFormat:@"select * From Users where subscriber = ? and username = ? and password = ?;"];
    
    sqlite3_stmt *stmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(stmt, 1, [subscriber UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [username UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [password UTF8String], -1, NULL);

    int i = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW)
    {
        i = sqlite3_column_int(stmt, 0);
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return i;

}

- (NSString *) getUsername: (NSUInteger) id
{
    
    NSString *query = [NSString stringWithFormat:@"select username From Users where id = ?;"];
    
    sqlite3_stmt *stmt = nil;
    
    int res = sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, NULL);
    
    if(res != SQLITE_OK)
    {
        NSLog(@"Error while creating select statement:%s", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(stmt, 1, (int)id);
    
    NSString *str = @"";
    if (sqlite3_step(stmt) == SQLITE_ROW)
    {
        str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return str;
    
}


@end
