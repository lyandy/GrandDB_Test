//
//  AndyMainViewModel.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/20.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyMainViewModel : NSObject

SingletonH(MainViewModel)

@property(nonatomic, strong, readonly) RACCommand *getFavorListCommand;

@property(nonatomic, strong, readonly) RACCommand *favorCommand;

//@property(nonatomic, strong, readonly) RACCommand *unFavorCommand;

@end
