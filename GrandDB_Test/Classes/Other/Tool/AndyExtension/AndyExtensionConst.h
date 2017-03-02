//
//  AndyExtensionConst.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/23.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANDYEXTENSION_EXTERN UIKIT_EXTERN

#define AndyExtensionAssert(condition, desc, ...)  NSAssert(condition, desc, ##__VA_ARGS__)

#define AndyExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

/**
 *  类型（属性类型）
 */
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeInt;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeShort;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeFloat;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeDouble;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeLong;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeLongLong;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeChar;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeBOOL1;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeBOOL2;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypePointer;

ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeIvar;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeMethod;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeBlock;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeClass;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeSEL;
ANDYEXTENSION_EXTERN NSString *const AndyPropertyTypeId;
