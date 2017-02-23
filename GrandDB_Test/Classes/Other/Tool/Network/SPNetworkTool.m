//
//  SPNetworkTool.m
//  SPLICEit
//
//  Created by 李扬 on 16/8/16.
//  Copyright © 2016年 andyshare. All rights reserved.
//

#import "SPNetworkTool.h"
#import "Reachability.h"

@interface SPNetworkTool ()

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation SPNetworkTool

SingletonM(NetworkTool);

// 实时监控网络状态
- (void)checkNetworkStates
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetworkStates) name:kReachabilityChangedNotification object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    [self.reachability startNotifier];
}

- (NetworkStates)getNetworkStates
{
    NetworkStates states = NetworkStatesNone;
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == ReachableViaWiFi)
    {
        states = NetworkStatesWIFI;
//        AndyLog(@"是wifi");
    }
    else if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN)
    {
        states = NetworkStatesCellular;
//        AndyLog(@"是手机自带网络");
    }
    else
    {
        states = NetworkStatesNone;
//        AndyLog(@"网络有问题");
    }
    return states;
}

//- (void)networkChange
//{
//    NSString *tips = nil;
//    NetworkStates currentStates = [SPNetworkTool getNetworkStates];
////    if (currentStates == self.preStatus)
////    {
////        return;
////    }
////    _preStatus = currentStates;
//    switch (currentStates) {
//        case NetworkStatesNone:
//            tips = @"当前无网络, 请检查您的网络状态";
//            break;
//        case NetworkStatesCellular:
//            tips = @"切换到了手机蜂窝网络";
//            break;
//        case NetworkStatesWIFI:
//            tips = nil;
//            break;
//        default:
//            break;
//    }
//    
//    if (tips.length != 0)
//    {
//        [[[UIAlertView alloc] initWithTitle:@"SPLICEit" message:tips delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
//    }
//}

//// 判断网络类型
//- (NetworkStates)getNetworkStates
//{
////    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
////    // 保存网络状态
////    NetworkStates states = NetworkStatesNone;
////    for (id child in subviews) {
////        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
////            //获取到状态栏码
////            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
////            switch (networkType) {
////                case 0:
////                    states = NetworkStatesNone;
////                    //无网模式
////                    break;
////                case 1:
////                    states = NetworkStates2G;
////                    break;
////                case 2:
////                    states = NetworkStates3G;
////                    break;
////                case 3:
////                    states = NetworkStates4G;
////                    break;
////                case 5:
////                {
////                    states = NetworkStatesWIFI;
////                }
////                    break;
////                default:
////                    break;
////            }
////        }
////    }
////    //根据状态选择
////    return states;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.reachability stopNotifier];
    self.reachability = nil;
}

@end
