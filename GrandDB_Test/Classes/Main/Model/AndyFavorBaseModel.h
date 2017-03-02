//
//  AndyFavorBaseModel.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AndyFavorCode) {
    AndyFavorCodeSuccess = (1UL << 0),
    AndyFavorCodeFailure,
    AndyFavorCodeUnknown
};

@interface AndyFavorBaseModel : NSObject

@property (nonatomic, assign) AndyFavorCode code;

@property (nonatomic, copy) NSString *msg;

@end
