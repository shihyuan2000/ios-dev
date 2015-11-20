//
//  ImageCache.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/20/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

@property (nonatomic, retain) NSCache *imgCache;


#pragma mark - Methods

+ (ImageCache*)sharedImageCache;
- (void) AddImage:(NSString *)imageURL image: (UIImage *)image;
- (void) RemoveImage: (NSString *)imageURL;
- (UIImage*) GetImage:(NSString *)imageURL;
- (BOOL) DoesExist:(NSString *)imageURL;

@end
