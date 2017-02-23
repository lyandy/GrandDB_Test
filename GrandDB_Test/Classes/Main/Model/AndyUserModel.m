//
//  AndyUserModel.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/13.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyUserModel.h"

@implementation AndyUserModel

+ (NSString *)andy_db_dbName
{
    return @"test";
}

+ (NSString *)andy_db_tableName
{
    return @"user";
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:[[self andy_db_dbName] stringByAppendingPathExtension:@"db"]];
}

+ (NSArray *)andy_db_persistentProperties
{
    static NSArray *properties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        properties = @[
                       @"Id",
                       @"name",
                       @"logo",
                       ];
    });
    return properties;
}

//+ (GYCacheLevel)andy_db_cacheLevel
//{
//    return GYCacheLevelNoCache;
//}

@end
