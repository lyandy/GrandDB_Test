//
//  AndyFavorDBModel.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyFavorDBModel.h"

@implementation AndyFavorDBModel

+ (NSString *)andy_db_dbName
{
    return [NSString stringWithFormat:@"favorDB_%zd", [(NSNumber *)[[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0] integerValue]];
}

+ (NSString *)andy_db_tableName
{
    return @"favor";
}

+ (NSDictionary *)andy_db_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

+ (NSString *)andy_db_primaryKey
{
    return @"Id";
}

+ (NSString *)andy_db_fullPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%zd",documentsDirectory, [(NSNumber *)[[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0] integerValue]];
    
    BOOL isDirectoryExist =[fileManager fileExistsAtPath:directoryPath];
    if (!isDirectoryExist)
    {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *dbFullPath = [directoryPath stringByAppendingPathComponent:[[self andy_db_dbName] stringByAppendingPathExtension:@"db"]];
    
    BOOL isDBExist = [fileManager fileExistsAtPath:dbFullPath];
    
    if (!isDBExist)
    {
        [fileManager createFileAtPath:dbFullPath contents:nil attributes:nil];
    }
    
    return dbFullPath;
}

+ (NSArray *)andy_db_persistentProperties
{
    static NSArray *properties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        properties = @[
                       @"Id",
                       @"favoredCount",
                       @"favored",
                       ];
    });
    return properties;
}

//+ (GYCacheLevel)andy_db_cacheLevel
//{
//    return GYCacheLevelNoCache;
//}

@end
