//
//  SPNetworkTool.h
//  SPLICEit
//
//  Created by 李扬 on 16/8/16.
//  Copyright © 2016年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AndySingleton.h"

#define SPNetworkToolInstance [SPNetworkTool sharedNetworkTool]

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
//    NetworkStates2G, // 2G
//    NetworkStates3G, // 3G
//    NetworkStates4G, // 4G
    NetworkStatesCellular, //手机网络
    NetworkStatesWIFI // WIFI
};

@interface SPNetworkTool : NSObject

SingletonH(NetworkTool);

// 实时监控网络状态
- (void)checkNetworkStates;

// 判断网络类型
- (NetworkStates)getNetworkStates;

@end
