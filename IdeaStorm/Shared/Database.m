//
//  Database.m
//  IdeaStorm
//
//  Created by Robert Cole on 10/30/11.
//  Copyright (c) 2011 Robert Cole. All rights reserved.
//

#import "Database.h"

@implementation Database

@synthesize defaults = _defaults;
@synthesize drawingEngineFirstRun = _drawingEngineFirstRun;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        self.defaults = [[NSUserDefaults alloc]init];
        
        drawingEngineNotFirstRunKey = @"DrawingEngine Not First Run";
        
        bool drawingEngineNotFirstRun = [self.defaults boolForKey:drawingEngineNotFirstRunKey];
        
        if (drawingEngineNotFirstRun) {
            _drawingEngineFirstRun = NO;
        } else {
            _drawingEngineFirstRun = YES;
        }
    }
    
    return self;
}

#pragma mark - User Defaults

- (void)setDrawingEngineFirstRun:(_Bool)drawingEngineFirstRun {
    _drawingEngineFirstRun = drawingEngineFirstRun;
    
    bool drawingEngineNotFirstRun;
    
    if (self.drawingEngineFirstRun) {
        drawingEngineNotFirstRun = NO;
    } else {
        drawingEngineNotFirstRun = YES;
    }
    
    [self.defaults setBool:drawingEngineNotFirstRun forKey:drawingEngineNotFirstRunKey];
}

#pragma mark - Getting Presaved Files 

+ (UIImage *)getImageForFilename:(NSString *)filename {
    UIImage *image = nil;
    
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:filename];
    
    image = [[[UIImage alloc]initWithContentsOfFile:filePath] autorelease];
    
    return image;
}

#pragma mark - Help Methods

+ (NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

+ (NSString *)libraryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

+ (NSString *)generateUniqueID {
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

#pragma mark - GalleryItem Management

- (bool)saveGalleryItem:(NSObject <GalleryItem> *)galleryItem {
    NSError *error;
    bool success;
    
    success = [[NSFileManager defaultManager] createDirectoryAtPath:[galleryItem getFullPath] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (success) {
        NSString *dataPath = [[galleryItem getFullPath] stringByAppendingPathComponent:kGalleryItemDataFileName];
        NSLog(@"%@", dataPath);
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        
        [archiver encodeObject:galleryItem forKey:galleryItem.pathID];
        [archiver finishEncoding];
        
        success = [data writeToFile:dataPath options:NSDataWritingAtomic error:&error];
        
        [archiver release];
        [data release];
    }
    
    if (!success) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error userInfo: %@", [error userInfo]);
    }
    
    
    return success;
}

//TODO: Do this next! Need to figure out the best way to load gallery items, this may require using or changing the extentions
- (NSObject <GalleryItem> *)getRootGalleryItem {
    //build path to root stack
    Stack *rootStack;
    
    NSString *pathToRootFile = [Database libraryPath];
    
    NSString *rootFolder = kGalleryItemRoot;
    
    rootFolder = [rootFolder stringByAppendingPathExtension:[Stack extention]];
    
    pathToRootFile = [pathToRootFile stringByAppendingPathComponent:rootFolder];
    
    pathToRootFile = [pathToRootFile stringByAppendingPathComponent:kGalleryItemDataFileName];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:pathToRootFile]) {
        //load root file
        NSLog(@"root stack exists, loading it");
    } else {
        //create and save root stack
        NSLog(@"no root stack, creating one");
        
        rootStack = [[Stack alloc]initWithPathID:kGalleryItemRoot];
        
        bool succuess = [self saveGalleryItem:rootStack];
        
        if (succuess) {
            NSLog(@"success");
        } else {
            NSLog(@"failure");
        }
    }
    
    return rootStack;
}

- (bool)moveGalleryItem:(NSObject <GalleryItem> *)child intoGalleryItem:(NSObject <GalleryItem> *)parent {
    return nil;
}

- (bool)deleteGalleryItem:(NSObject <GalleryItem> *)galleryIten {
    return nil;
}

- (void)dealloc {
    [self.defaults release];
    
    [super dealloc];
}

@end