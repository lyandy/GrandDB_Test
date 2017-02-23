//
//  XCTestCaseBase.h
//  VISI
//
//  Created by bomo on 2017/2/8.
//  Copyright © 2017年 ushareit. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCaseBase : XCTestCase

@property(nonatomic, strong, readonly) XCUIApplication *app;

@end
