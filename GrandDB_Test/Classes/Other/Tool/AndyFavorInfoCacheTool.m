//
//  AndyFavorInfoCacheTool.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/21.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyFavorInfoCacheTool.h"
#import "AndyMainViewModel.h"
#import "AndyFavorListResultModel.h"

@interface AndyFavorInfoCacheTool ()

@property (nonatomic, strong) NSMutableSet<NSNumber *> *idSetM;

@property (nonatomic, assign) NSUInteger itemsCount;

@property (nonatomic, strong) AndyGCDTimer *timer;

@end

@implementation AndyFavorInfoCacheTool

SingletonM(FavorInfoCacheTool)

- (NSMutableSet<NSNumber *> *)idSetM
{
    if (_idSetM== nil)
    {
        _idSetM = [NSMutableSet set];
    }
    return _idSetM;
}

- (AndyGCDTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [[AndyGCDTimer alloc] init];
    }
    return _timer;
}

- (void)addId:(NSNumber *)Id
{
//    AndyLog(@"%进来 %@",Id);
    
    [self.idSetM addObject:Id];
    
    self.itemsCount = self.idSetM.count;
}

- (void)removeId:(NSNumber *)Id
{
    [self.idSetM removeObject:Id];
    
    //AndyLog(@"出去 %@", Id);
    
    self.itemsCount = self.idSetM.count;
}

- (void)setItemsCount:(NSUInteger)itemsCount
{
    _itemsCount = itemsCount;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getFavorInfoOnline];
    });
}

- (void)getFavorInfoOnline
{
    @weakify(self);
    
    [self.timer timerExecute:^{
        
        @strongify(self);
        
        if ([SPNetworkToolInstance getNetworkStates] != NetworkStatesNone)
        {
            if (self.itemsCount != 0)
            {
                NSString *str = [[[self.idSetM copy] allObjects] componentsJoinedByString:@","];
                
                //立刻清空缓存
                [self clearCache];
                
                [[[AndyMainViewModel sharedMainViewModel].getFavorListCommand execute:str] subscribeNext:^(id x) {
                    if (x != nil)
                    {
                        //AndyLog(@"请求结果%@", resultModel.favoredDict);
                        [AndyNotificationCenter postNotificationName:FAVOR_LIST_RESULT_TO_CELL_NOTIFICATION object:x];
                    }
                }];
            }
            else
            {
                //AndyLog(@"0 个元素不请求");
            }
        }
        
    } timeIntervalWithSecs:0.5 delaySecs:0.5];
    
    [self.timer start];
    AndyLog(@"self.timer 启动");
}

- (void)clearCache
{
    //回到主线程处理，防止多线程问题
    [AndyGCDQueue executeInMainQueue:^{
        [self.idSetM removeAllObjects];
        self.itemsCount = self.idSetM.count;
        self.idSetM = nil;
    }];
}

@end
