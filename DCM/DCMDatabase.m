//
//  DCMDatabase.m
//  DCM
//
//  Created by Benjamin Ragheb on 5/13/12.
//  Copyright (c) 2012 Heroic Software Inc. All rights reserved.
//

#include <sys/xattr.h>

#import "DCMDatabase.h"

NSString * const DCMDatabaseWillChangeNotification = @"DCMDatabaseWillChange";
NSString * const DCMDatabaseDidChangeNotification = @"DCMDatabaseDidChange";

@implementation DCMDatabase

+ (DCMDatabase *)sharedDatabase
{
    static DCMDatabase *database = nil;
    
    if (database == nil) {
        database = [[DCMDatabase alloc] init];
    }
    return database;
}

@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectContext = __managedObjectContext;

- (void)deleteStore
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:DCMDatabaseWillChangeNotification object:self];
    __managedObjectContext = nil;
    __persistentStoreCoordinator = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:nil];
}

- (NSURL *)storeURL
{
    NSURL *documentsURL = [[[NSFileManager defaultManager]
                            URLsForDirectory:NSDocumentDirectory
                            inDomains:NSUserDomainMask] lastObject];
    return [NSURL URLWithString:@"dcm.sqlite" relativeToURL:documentsURL];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char *filePath = [[URL path] fileSystemRepresentation];    
    const char *attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel) return managedObjectModel;

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DCM" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator) return __persistentStoreCoordinator;

    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [self storeURL];
    NSError *error;
    [__persistentStoreCoordinator
     addPersistentStoreWithType:NSSQLiteStoreType
     configuration:nil
     URL:storeURL
     options:nil
     error:&error];
    [self addSkipBackupAttributeToItemAtURL:storeURL];
    return __persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext) return __managedObjectContext;

    __managedObjectContext = [[NSManagedObjectContext alloc]
                              initWithConcurrencyType:NSMainQueueConcurrencyType];
    __managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return __managedObjectContext;
}

- (NSUInteger)numberOfShows
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Show"];
    [request setResultType:NSCountResultType];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext
                        executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Warning: %@", [error localizedDescription]);
    }
    return [[results lastObject] unsignedIntegerValue];
}

@end
