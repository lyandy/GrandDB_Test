//
//  AndyMainVCTests.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/16.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyMainVCTests.h"

@interface AndyMainVCTests ()

@property (nonatomic, strong)XCUIElement *userTableView;

@end

@implementation AndyMainVCTests

- (XCUIElement *)userTableView
{
    return self.app.tables[@"userTableView"];
}

- (void)testScroll
{
    [self.userTableView swipeUp];
}

@end
