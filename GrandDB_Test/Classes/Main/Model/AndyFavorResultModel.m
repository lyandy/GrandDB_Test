//
//  AndyFavorResultModel.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyFavorResultModel.h"

@implementation AndyFavorResultModel

+ (NSDictionary *)andy_replacedKeyFromPropertyName
{
    return @{@"favoredId" : @"id", @"favoredCount" : @"num"};
}

@end
