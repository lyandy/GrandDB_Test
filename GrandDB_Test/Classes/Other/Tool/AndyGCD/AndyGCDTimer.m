//
//  AndyGCDTimer.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyGCDTimer.h"
#import "AndyGCDQueue.h"
#import "AndyGCDConst.h"

@implementation AndyGCDTimer

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    
    return self;
}

- (instancetype)initInQueue:(AndyGCDQueue *)queue
{
    self = [super init];
    
    if (self)
    {
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue);
    }
    
    return self;
}

- (void)timerExecute:(dispatch_block_t)block timeInterval:(uint64_t)interval
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)timerExecute:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delay), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)timerExecute:(dispatch_block_t)block timeIntervalWithSecs:(float)secs
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)timerExecute:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)start
{
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_resume(self.dispatchSource);
}

- (void)destroy
{
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_cancel(self.dispatchSource);
}

@end
