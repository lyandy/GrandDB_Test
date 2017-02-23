//
//  XCTestCaseBase.m
//  VISI
//
//  Created by bomo on 2017/2/8.
//  Copyright © 2017年 ushareit. All rights reserved.
//

#import "XCTestCaseBase.h"

@implementation XCTestCaseBase

- (XCUIApplication *)app
{
    static XCUIApplication *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XCUIApplication alloc] init];
    });
    
    return instance;
}


- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [self.app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
