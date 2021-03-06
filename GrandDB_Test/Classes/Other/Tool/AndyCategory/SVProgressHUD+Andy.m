//
//  SVProgressHUD+Andy.m
//  AndyCategory_Test
//
//  Created by 李扬 on 16/8/5.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "SVProgressHUD+Andy.h"

@implementation SVProgressHUD (Andy)

+ (void)setCustomStyle
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.65]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)andy_showLoadingWithStatus:(NSString *)status
{
    [self setCustomStyle];
    
    [SVProgressHUD setMinimumDismissTimeInterval:MAXFLOAT];
    [SVProgressHUD showWithStatus:status];
}

+ (void)andy_showInfoWithStatus:(NSString *)status
{
    [self setCustomStyle];
    
    [SVProgressHUD setMinimumDismissTimeInterval:((float)status.length * 0.06 + 0.5)];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)andy_showErrorWithStatus:(NSString *)status
{
    [self setCustomStyle];
    
    [SVProgressHUD setMinimumDismissTimeInterval:((float)status.length * 0.06 + 0.5)];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)andy_showSuccessWithStatus:(NSString *)status
{
    [self setCustomStyle];
    
    [SVProgressHUD setMinimumDismissTimeInterval:((float)status.length * 0.06 + 0.5)];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)andy_dismiss
{
    [SVProgressHUD dismiss];
}

@end
