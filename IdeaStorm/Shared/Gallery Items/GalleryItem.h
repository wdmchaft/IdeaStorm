//
//  GalleryItem.h
//  IdeaStorm
//
//  Created by Robert Cole on 3/11/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Resize.h" 

#define kPathIDKey @"pathID"
#define kThumbnailImagePathKey @"thumbnailImagePath"
#define kFullImagePathKey @"fullImagePath"
#define kChildrenKey @"children"
#define kFullImageFileName @"fullImage.png"
#define kThumbImageFileName @"thumbImage.png"
#define kThumbWidth 112.5
#define kThumbHeight 150.0

@protocol GalleryItem <NSCoding>

@required

@property (nonatomic, strong) NSObject <GalleryItem> *parent;
@property (nonatomic, strong, readonly) NSMutableArray *children;
@property (nonatomic, strong, readonly) NSString *pathID;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *fullImage;

- (id)initWithPathID:(NSString *)pathID;

- (NSString *)getFullPathWithDataFilename:(bool)yesOrNo;

- (bool)addChild:(NSObject <GalleryItem> *)galleryItem;

- (bool)deleteChild:(NSObject <GalleryItem> *)galleryItem;

- (NSString *)saveThumbnailImage;

- (NSString *)saveFullImage;

- (bool)exportToCameraRoll;

+ (NSString *)extention;

@end
