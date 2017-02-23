//
//  AndyMainTableViewCell.h
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/14.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyFavorDBModel.h"

@class AndyUserModel;

@interface AndyMainTableViewCell : UITableViewCell

@property (nonatomic, strong) AndyUserModel *userModel;

@property (nonatomic, strong) AndyFavorDBModel *favorDBModel;

@end
