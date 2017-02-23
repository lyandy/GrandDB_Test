//
//  AndyMainViewModel.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyMainViewModel.h"
#import "AndyFavorListModel.h"
#import "AndyFavorListResultModel.h"
#import "AndyFavorModel.h"

@implementation AndyMainViewModel

SingletonM(MainViewModel);

- (RACCommand *)getFavorListCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id pids) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //当前登录用的用户 id
            id curUid = [[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0];
            
//            MBProgressHUD *mbHUD = [MBProgressHUD andy_showMessage:@"正在获取赞消息..."];
            
            AndyLog(@"请求参数：%@", pids);
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:@"https://ssl.scorplot.com/test3/is_zan.php" parameters:@{@"pids": pids, @"uid" : curUid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                AndyFavorListModel *listModel = [AndyFavorListModel andy_objectWithKeyValues:responseObject];
                
                if (listModel.code == AndyFavorCodeSuccess)
                {
                    NSArray *arr = @[listModel.result, pids];
                    
                    [subscriber sendNext:arr];
                }
                else
                {
                    [subscriber sendNext:nil];
                }
                
                dispatch_group_leave(group);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendNext:nil];
                
                dispatch_group_leave(group);
            }];
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
//                [mbHUD hideAnimated:YES];
                [subscriber sendCompleted];
            });
            
            return [RACDisposable disposableWithBlock:^{
                //AndyLog(@"getFavorListCommand 信号释放");
            }];
        }];
        
        return signal;
    }];
}

- (RACCommand *)favorCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSArray *parameterArr) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //当前登录用的用户 id
            id curUid = [[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0];
            
            //取得要操作的用户的pid
            id pid = [parameterArr firstObject];
            //取得要操作的用户当前被赞的状态
            BOOL isFavored = [[parameterArr lastObject] boolValue];
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:[NSString stringWithFormat:@"https://ssl.scorplot.com/test3/%@.php", isFavored ? @"unzan" : @"zan"] parameters:@{@"pid": pid, @"uid" : curUid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                AndyFavorModel *favorModel = [AndyFavorModel andy_objectWithKeyValues:responseObject];
                if (favorModel.code == AndyFavorCodeSuccess)
                {
                    NSArray *arr = @[favorModel.result, pid];
                    [subscriber sendNext:arr];
                }
                else
                {
                    [subscriber sendNext:nil];
                }
                
                dispatch_group_leave(group);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendNext:nil];
                
                dispatch_group_leave(group);
            }];
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [subscriber sendCompleted];
            });
            
            return [RACDisposable disposableWithBlock:^{
                AndyLog(@"favorCommand 信号释放");
            }];
        }];
        
        return signal;
    }];
}

@end
