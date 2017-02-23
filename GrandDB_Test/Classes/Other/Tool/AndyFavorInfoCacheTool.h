//
//  AndyFavorInfoCacheTool.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/21.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyFavorInfoCacheTool : NSObject

SingletonH(FavorInfoCacheTool)

- (void)addId:(NSNumber *)Id;

- (void)removeId:(NSNumber *)Id;

- (void)clearCache;

@end
