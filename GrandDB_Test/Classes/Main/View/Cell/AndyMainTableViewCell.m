//
//  AndyMainTableViewCell.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/14.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyMainTableViewCell.h"
#import "AndyUserModel.h"
#import "AndyMainViewModel.h"
#import "AndyFavorListResultModel.h"
#import "AndyFavorResultModel.h"

#import <POP/POP.h>

@interface AndyMainTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *favorInfoLabel;


@end

@implementation AndyMainTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupInit];
    
    [self setupRAC];
}

- (void)setupInit
{
    
}

- (void)setupRAC
{
    @weakify(self)
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    
    [tapGesture.rac_gestureSignal subscribeNext:^(id x) {
        
        NSInteger curId = [(NSNumber *)[[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0] integerValue];
        
        if (curId == 0)
        {
            [SVProgressHUD andy_showErrorWithStatus:@"请先登录"];
        }
        else
        {
            if ([SPNetworkToolInstance getNetworkStates] == NetworkStatesNone)
            {
                [SVProgressHUD andy_showErrorWithStatus:@"网络错误，请稍后重试"];
            }
            else
            {
                [SVProgressHUD andy_showLoadingWithStatus:@"请稍后..."];

                NSArray *parameterArr = @[@(self.userModel.Id), @(self.favorDBModel.isFavored)];
                
                [[[[AndyMainViewModel sharedMainViewModel].favorCommand execute:parameterArr] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSArray *arr) {
                    
                    [SVProgressHUD andy_dismiss];
                    
                    if (arr != nil)
                    {
                        if ([[arr lastObject] integerValue] == self.userModel.Id)
                        {
                            AndyFavorResultModel *resultModel = [arr firstObject];
                            
                            AndyFavorDBModel *favorDBModel = [[AndyFavorDBModel alloc] init];
                            favorDBModel.Id = resultModel.favoredId;
                            favorDBModel.favoredCount = resultModel.favoredCount;
                            favorDBModel.favored = !self.favorDBModel.isFavored;
                            
                            self.favorDBModel = favorDBModel;
                            
                            if (self.favorDBModel.isFavored)
                            {
                                [self.favorImageView andy_addBounceInSpringAnimation];
                            }
                            
                            //存入数据库
                            [self saveFavorInfoToDB:favorDBModel];
                        }
                    }
                }];
            }
        }
    }];
    [self addGestureRecognizer:tapGesture];
    
    
    [[[AndyNotificationCenter rac_addObserverForName:FAVOR_LIST_RESULT_TO_CELL_NOTIFICATION object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * notification) {
        
        @strongify(self);
        
        NSArray *arr = notification.object;
        if (arr != nil)
        {
            NSArray<NSString *> *str = [[arr lastObject] componentsSeparatedByString:@","];
            if ([str containsObject:[NSString stringWithFormat:@"%zd", self.userModel.Id]])
            {
                AndyFavorListResultModel *resultModel = [arr firstObject];
                
                AndyFavorDBModel *favorDBModel = [[AndyFavorDBModel alloc] init];
                
                favorDBModel.Id = self.userModel.Id;
                
                favorDBModel.favored = [resultModel.favoredArr containsObject:@(self.userModel.Id)];
                
                favorDBModel.favoredCount = [[resultModel.favoredDict objectForKey:[NSString stringWithFormat:@"%zd", self.userModel.Id]] integerValue];
                
                self.favorDBModel = favorDBModel;
                
                [self saveFavorInfoToDB:favorDBModel];
            }
        }
    }];
}

- (void)setupAutoLayouts
{
    CGFloat commonMargin = 9.0;
    
    [self.userLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.andy_Height - 2 * commonMargin);
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(2 * commonMargin);
    }];
    
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLogoImageView.right).offset(2 * commonMargin);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top).offset(commonMargin);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIdLabel.left);
        make.right.equalTo(self.userIdLabel.right);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.favorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIdLabel.left);
        make.bottom.equalTo(self.bottom).offset(-commonMargin);
        make.size.equalTo(CGSizeMake(25, 25));
    }];
    
    [self.favorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favorImageView.right).offset(commonMargin / 2.0);
        make.centerY.equalTo(self.favorImageView.centerY);
        make.right.equalTo(self.right);
    }];
}

- (void)setUserModel:(AndyUserModel *)userModel
{
    _userModel = userModel;
    
    self.userIdLabel.text = [NSString stringWithFormat:@"用户ID %zd", userModel.Id];
    self.userNameLabel.text = userModel.name;
    
    self.userLogoImageView.yy_imageURL = [NSURL URLWithString:userModel.logo];
    
//    [self.contentView andy_addFlipInXSpringAnimation];
}

- (void)setFavorDBModel:(AndyFavorDBModel *)favorDBModel
{
    _favorDBModel = favorDBModel;
    
    [AndyGCDQueue executeInMainQueue:^{
        self.favorImageView.image = [UIImage imageNamed:(favorDBModel.isFavored ? @"favor" : @"unFavor")];
        self.favorInfoLabel.text = [NSString stringWithFormat:@"一共有 %zd 人赞过", favorDBModel.favoredCount];
    }];
}

- (void)saveFavorInfoToDB:(AndyFavorDBModel *)favorDBModel
{
    //存入数据库
    [AndyGCDQueue executeInGlobalQueue:^{
        [favorDBModel andy_db_saveObjectSuccess:nil failure:^(id error) {
            NSAssert(NO, @"用户id为 %zd 赞信息数据库存入失败", favorDBModel.Id);
        }];
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    //离开请求缓存池
    [[AndyFavorInfoCacheTool sharedFavorInfoCacheTool] removeId:@(self.userModel.Id)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupAutoLayouts];
}

@end
