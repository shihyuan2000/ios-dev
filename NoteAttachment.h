//
//  NoteAttachment.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/20/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteAttachment : NSObject

@property (nonatomic) NSUInteger                attachmentId;
@property (strong, nonatomic) NSString          *attachmentMimetype;
@property (strong, nonatomic) NSString          *attachmentFilename;
@property (nonatomic) NSUInteger                attachmentSize;
@property (strong, nonatomic) NSString          *attachmentUrl;
@property (strong, nonatomic) NSString          *attachmentThumbnail;
@property (strong, nonatomic) NSString          *attachmentDate;
@property (strong, nonatomic) NSString          *attachmentDescription;
@property (nonatomic) NSUInteger                attachmentProjectId;
@property (strong, nonatomic) NSString          *attachmentDocumentType;
@property (nonatomic) NSUInteger                attachmentDocumentId;

@end
