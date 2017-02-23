//
//  AndyFavorDBModel.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyFavorDBModel : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, assign) NSInteger favoredCount;

@property (nonatomic, assign, getter = isFavored) BOOL favored;

@end
