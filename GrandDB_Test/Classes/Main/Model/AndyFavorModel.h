//
//  AndyFavorModel.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AndyFavorBaseModel.h"
#import "AndyFavorResultModel.h"

@interface AndyFavorModel : AndyFavorBaseModel

@property (nonatomic, strong) AndyFavorResultModel *result;

@end
