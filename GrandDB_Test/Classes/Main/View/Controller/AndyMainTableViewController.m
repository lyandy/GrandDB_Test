//
//  AndyMainTableViewController.m
//  GrandDB_Test
//
//  Created by 李扬 on 2017/2/13.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyMainTableViewController.h"
#import "AndyUserModel.h"
#import "AndyMainTableViewCell.h"
#import "AndyFavorDBModel.h"
#import "AndyMainViewModel.h"
#import "AndyFavorListResultModel.h"

@interface AndyMainTableViewController ()<UIAlertViewDelegate>

/** 暂时无用 */
@property (nonatomic, strong) NSMutableArray<AndyUserModel *> *usersArrM;

/** 数据库总记录数 */
@property (nonatomic, assign) NSUInteger allCountNum;

//根据步长偏移量，所期望的展示行数
@property (nonatomic, assign) NSUInteger nowCountNum;

//自动测试计时器
@property (nonatomic, strong) AndyGCDTimer *timer;

@property (nonatomic, strong) AndyMainViewModel *mainVM;

@end

@implementation AndyMainTableViewController

static NSString * const mainTableViewCellId = @"mainTableViewCellId";
static NSUInteger const usersFromDBOffsetCount = 2000;

- (NSMutableArray<AndyUserModel *> *)usersArrM
{
    if (_usersArrM == nil)
    {
        _usersArrM = [NSMutableArray array];
    }
    return _usersArrM;
}

- (AndyGCDTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [[AndyGCDTimer alloc] init];
    }
    return _timer;
}

- (AndyMainViewModel *)mainVM
{
    if (_mainVM == nil)
    {
        _mainVM = [[AndyMainViewModel alloc] init];
    }
    return _mainVM;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupInit];

    [self setupAsyncDataWithStartIndex:0];

    [self setupNavBar];
    
    //自动测试
    //[self setupAutoTest];
}

- (void)setupInit
{
    //用于UI测试
    self.tableView.accessibilityIdentifier = @"userTableView";
    
    self.tableView.rowHeight = 90;
    
    [self initUserDatabase];
    
    self.allCountNum = [[AndyUserModel andy_db_aggregate:@"count(1)" where:nil arguments:nil] integerValue];
    
    //https://github.com/rs/SDWebImage/issues/1375
    //SDWebImageManager.sharedManager.imageDownloader.maxConcurrentDownloads = 2;
}

- (void)initUserDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:[[AndyUserModel andy_db_dbName] stringByAppendingPathExtension:@"db"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *srcPath = [bundle pathForResource:[AndyUserModel andy_db_dbName] ofType:@"db"];
        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dbPath error:nil];
    }
}

- (void)setupAsyncDataWithStartIndex:(NSUInteger)startIndex
{
    self.nowCountNum = startIndex + usersFromDBOffsetCount;
    
    AndyLog(@"期望总行数 %zd", self.nowCountNum);
    
    [AndyGCDQueue executeInGlobalQueue:^{
        
        NSString *limitStr = [NSString stringWithFormat:@"limit %zd, %zd", startIndex, usersFromDBOffsetCount];
        
        AndyLog(@"%@", limitStr);
        
        //将指定范围的数据读取到 数据库 cache
        [AndyUserModel andy_db_objectsWhere:limitStr arguments:nil];
    }];
}

- (void)setupAutoTest
{
    //滚动偏移的行数位置
    __block NSUInteger offset = 0;
    
    @weakify(self);
    
    [self.timer timerExecute:^{
        
        @strongify(self);
        
        //一次滚动8000行
        offset += 8000;
        //如果已经达到最大行数，则销毁计时器，停止滚动
        if (offset >= self.allCountNum)
        {
            offset = self.allCountNum - 1;
            
            [self.timer destroy];
        }
        
        //超过200万行则模拟内存警告
        if (offset > 2000000)
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self simulateMemoryWarning];
            });
        }
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:offset inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    } timeInterval:NSEC_PER_SEC * 0.5 delay:NSEC_PER_SEC * 3];
    
    [self.timer start];
}

/**
 模拟内存警告 私有API
 */
- (void)simulateMemoryWarning
{
    
#ifdef DEBUG
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    //http://www.jianshu.com/p/3c7a4feaee16
    //http://stackoverflow.com/questions/8410901/is-there-a-way-to-send-memory-warning-to-iphone-device-manually
    [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];
    
#pragma clang diagnostic pop
    
#endif
    
}

- (void)setupNavBar
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem andy_itemWithTitle:@"切换用户" style:UIBarButtonItemStylePlain actionBlock:^(id sender) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"登录模拟"
                                                             message:@"输入用户id，模拟登录。输入0, 模拟注销" delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        alertView.delegate = self;
        
        [alertView.rac_buttonClickedSignal subscribeNext:^(id x) {
            if ([x integerValue] == 1)
            {
                //更新持久化存储
                [[AndyUserDefaultsStore sharedUserDefaultsStore] setOrUpdateValue:[alertView textFieldAtIndex:0].text ForKey:CUR_LOGIN_USER_ID];
                
                //更改标题显示
                self.navigationItem.title = [NSString stringWithFormat:@"当前用户id %zd",  [(NSNumber *)[[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0] integerValue]];
                
                //在这里拉取新数据
                [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof AndyMainTableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
                    [[AndyFavorInfoCacheTool sharedFavorInfoCacheTool] addId:@(cell.userModel.Id)];
                }];
            }
        }];
        
        UITextField * textField = [alertView textFieldAtIndex:0];
        textField.placeholder = @"请输入用户id";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        [alertView show];
    }];
    
    self.navigationItem.title = [NSString stringWithFormat:@"当前用户id %zd",  [(NSNumber *)[[AndyUserDefaultsStore sharedUserDefaultsStore] getValueForKey:CUR_LOGIN_USER_ID DefaultValue:@0] integerValue]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allCountNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AndyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCellId];
    if (cell == nil)
    {
        cell = [AndyMainTableViewCell andy_viewFromXib];
    }
    
    //如果数据库cache有，则直接取出，加快数据读取速度，如果没有则从数据库中读取
    cell.userModel = [AndyUserModel andy_db_objectForId:@(indexPath.row + 1)];

    //从数据库获取 favor信息
    cell.favorDBModel = [AndyFavorDBModel andy_db_objectForId:@(cell.userModel.Id)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //为了防止读到某一条的时候再去显示哪一条，则制定当要显示最后几条的时候，重新更新下数据库 cache。但有个问题这个方法当tableView滑动非常非常快的时候就无法命中。也就是说tableView快速滑动的时候，行数索引 indexPath.row 变化是不连续的
    if (indexPath.row == self.nowCountNum  - 3)
    {
        AndyLog(@"到达加载阈值: %zd", indexPath.row);
        
        [self setupAsyncDataWithStartIndex:self.nowCountNum];
    }
    
    //进入请求缓存池
    [[AndyFavorInfoCacheTool sharedFavorInfoCacheTool] addId:@(((AndyMainTableViewCell *)cell).userModel.Id)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    AndyLog(@"收到内存警告");
    
    //"AndyDataCenter" 库也会收到内存警告事件，清空数据库 cache 中不在界面上展示的元素
    
    //http://www.cnblogs.com/ziip/p/4664234.html
    //[[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

@end
