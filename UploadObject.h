//
//  UploadObject.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/14/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadObject : NSObject

@property (nonatomic) NSUInteger                uploadId;
@property (strong, nonatomic) NSString          *uploadMimetype;
@property (strong, nonatomic) NSString          *uploadFilename;
@property (nonatomic) NSUInteger                uploadSize;
@property (strong, nonatomic) NSString          *uploadUrl;
@property (strong, nonatomic) NSString          *uploadThumbnail;
@property (strong, nonatomic) NSString          *uploadDate;
@property (strong, nonatomic) NSString          *uploadDescription;
@property (strong, nonatomic) NSString          *uploadCategory;
@property (nonatomic) NSInteger                 uploadProjectId;
@property (strong, nonatomic) NSString          *uploadDocumentType;
@property (nonatomic) NSInteger                 uploadDocumentId;
@property (nonatomic) NSInteger                 uploadThumbnailId;
@property NSInteger                             dailyReportId;
@property (strong, nonatomic) NSString          *localFileStoreName;

@end
