//
//  SHFriendTimeLineViewController.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHFriendTimeLineViewController.h"
#import "SHPublishViewController.h"
#import "SHFriendTimeLineTableViewCell.h"
#import "SHFriendTimeLineHeader.h"
#import "SHFriendHeadView.h"
#import "YYFPSLabel.h"
#import "SHPhotoBrowserViewController.h"
#import "XJJRefresh.h"
#import "MJRefresh.h"

//背景自己
#define kActionSheet_BackGroup_Me_Tag 1
//背景其他人
#define kActionSheet_BackGroup_Other_Tag 2
//删除评论
#define kActionSheet_Delete_Tag 3

@interface SHFriendTimeLineViewController ()
<SHFriendTimeLineDelegate,
SHFriendHeadViewDelegate,
UIActionSheetDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//界面数据
@property (nonatomic, strong) NSMutableArray <SHFriendTimeLineFrame *>*dataSoure;
//头部视图
@property (nonatomic, strong) SHFriendHeadView *headerView;
//FPS
@property (nonatomic, strong) YYFPSLabel *fpsLabel;

//删除评论暂存
@property (nonatomic, strong) NSDictionary *deleteDic;

@end

@implementation SHFriendTimeLineViewController

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -(44 + kStatusBarH), kSHWidth, kSHHeight + (44 + kStatusBarH)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关闭自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //设置下划线
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //配置数据
    [self setup];
    
    //设置FPS
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.y = 80;
    _fpsLabel.x = 0;
    _fpsLabel.width = 120;
    _fpsLabel.alpha = 0;
    self.navigationItem.titleView = _fpsLabel;
    
}

#pragma mark - 配置数据
- (void)setup{
    
    //配置导航栏
    [self setupNav];
    //配置头部
    [self setupHead];
    //配置内容
    [self setupContent];
    //配置刷新
    [self setRefresh];
}

#pragma mark 配置导航栏
- (void)setupNav{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = item;
    
}

#pragma mark 配置头部
- (void)setupHead{
    
    self.headerView = [[SHFriendHeadView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, 340)];
    self.headerView.userName = self.userInfo;
    self.headerView.userAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 4];
    self.headerView.backgroundUrl = [NSString stringWithFormat:@"pic%u.jpg",arc4random() % 8];
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark 配置内容
- (void)setupContent{
    
    self.dataSoure = [NSMutableArray arrayWithArray:[self getFriendDataWithNum:20]];
    
    [self.tableView reloadData];
}

#pragma mark - 配置刷新、加载
- (void)setRefresh{
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadOldData];
        });
    }];

    UIImageView *refreshView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    refreshView.image = [UIImage imageNamed:@"refresh_icon@2x.png"];
    
    XJJHolyCrazyHeader *crazyRefresh = [XJJHolyCrazyHeader holyCrazyCustomHeaderWithCustomContentView:refreshView];
    crazyRefresh.startPosition = CGPointMake(20, (44 + kStatusBarH) - 32);
    crazyRefresh.refreshingPosition = CGPointMake(20,150);
    
    __weak typeof(self) weakSelf = self;
    [self.tableView add_xjj_refreshHeader:crazyRefresh refreshBlock:^{
        
        [weakSelf.tableView setRefreshState:XJJRefreshStateIdle];
        
        [weakSelf.tableView replace_xjj_refreshBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf loadNewData];
            });
        }];
    }];
}

#pragma mark - 刷新数据
- (void)loadNewData{
    NSLog(@"刷新数据");
        
    NSArray *temp = [self getFriendDataWithNum:5];
    
    for (SHFriendTimeLineFrame *model in temp) {
        [self.dataSoure insertObject:model atIndex:0];
    }
    
    [self.tableView reloadData];
    
    [self.tableView end_xjj_refresh];
}

#pragma mark - 加载数据
- (void)loadOldData{
    NSLog(@"加载数据");
    
    NSArray *temp = [self getFriendDataWithNum:5];
    
    for (SHFriendTimeLineFrame *model in temp) {
        
        [self.dataSoure addObject:model];
    }
    
    [self.tableView reloadData];
    
    //滚动到指定位置
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSoure.count - temp.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 导航栏点击
- (void)rightClick{
    
    SHPublishViewController *view = [[SHPublishViewController alloc]init];
    view.block = ^(SHFriendTimeLine *message){
        if (message) {
            SHFriendTimeLineFrame *messageFrame = [[SHFriendTimeLineFrame alloc]init];
            messageFrame.message = message;
            [self.dataSoure insertObject:messageFrame atIndex:0];
            //进行刷新
            [self.tableView reloadData];
        }
    };
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 获取数据
- (NSArray *)getFriendDataWithNum:(NSInteger)num{
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i = 0; i < num; i++) {
        
        SHFriendTimeLine *message = [self getFriendDataWithIndex:arc4random() % 9];
        SHFriendTimeLineFrame *messageFrame = [[SHFriendTimeLineFrame alloc]init];
        messageFrame.message = message;
        
        [temp addObject:messageFrame];
    }
    return temp;
}

- (SHFriendTimeLine *)getFriendDataWithIndex:(NSInteger )index{
    
    SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];

    NSInteger imageNum = arc4random() % 10;
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < imageNum; i++) {
        NSInteger pic = arc4random() % 9;
        if (pic == 8) {
            [imageArr addObject:@"http://mvimg2.meitudata.com/55713dd0165c89055.jpg"];
        }else{
            [imageArr addObject:[NSString stringWithFormat:@"pic%u.jpg",arc4random() % 8]];
        }
    }
    
    model.messageImageArr = imageArr;
    
    switch (index) {
        case 0:
        {
            model.friendNick = @"妈妈";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"5分钟前";
            model.messageContent = @"回家吃饭！！！！！";

            SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
            comment.comment = @"小红";
            comment.content = @"我就看看";

            model.commentArr = @[comment];
        }
            break;
        case 1:
        {
            model.friendNick = @"爸爸";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"15分钟前";
        }
            break;
        case 2:
        {
            model.friendNick = @"小红";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"不回去。。。。";
            model.likeListArr = @[@"那啥",@"小红"];
        }
            break;
        case 3:
        {
            model.friendNick = @"小紫";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"今天天气不错";
            model.likeListArr = @[@"那啥",@"小红"];
        }
            break;
        case 4:
        {
            model.friendNick = @"那啥";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"test=====2345678654了圣诞节阿弗莱克就撒；来得快计费；拉萨肯德基菲利克斯敬爱的浪费空间撒即可好吧";
            model.likeListArr = @[@"1",@"2",@"3",@"4",@"5"];
        }
            break;
        case 5:
        {
            model.friendNick = @"公安局";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"女孩失踪15年后变残疾街头卖唱？警方:正在核实";
            model.likeListArr = @[@"那啥",@"小红",@"快乐的返回来看撒娇的恢复了空间撒谎对方立刻就杀掉了开发计",@"sdfghjkhgfdsa",@"skt"];
            
            SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
            comment.comment = @"小红";
            comment.content = @"http://www.jianshu.com/u/787eb6539a62";
            
            SHFriendTimeLineComment *comment2 = [[SHFriendTimeLineComment alloc]init];
            comment2.comment = @"小明";
            comment2.replier = @"小红";
            comment2.content = @"你看啥";
            
            SHFriendTimeLineComment *comment3 = [[SHFriendTimeLineComment alloc]init];
            comment3.comment = @"小明";
            comment3.replier = @"小红";
            comment3.content = @"你看啥";
            
            SHFriendTimeLineComment *comment4 = [[SHFriendTimeLineComment alloc]init];
            comment4.comment = @"小明";
            comment4.replier = @"小红";
            comment4.content = @"看看这个http://www.jianshu.com/u/787eb6539a62";
            
            model.commentArr = @[comment2,comment,comment3,comment4];
        }
            break;
        case 6:
        {
            model.friendNick = @"新闻";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"丹麦垂死老人夕阳下抽烟喝酒 安然迎接死亡";
            model.likeListArr = @[@"那啥",@"小红",@"快乐的返回来看撒娇的恢复了空间撒谎对方立刻就杀掉了开发计",@"sdfghjkhgfdsa",@"skt"];
            
            SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
            comment.comment = @"小红";
            comment.content = @"😯？";
            
            SHFriendTimeLineComment *comment2 = [[SHFriendTimeLineComment alloc]init];
            comment2.comment = @"小明";
            comment2.replier = @"小红";
            comment2.content = @"。。。。。";
            
            model.commentArr = @[comment2,comment];
        }
            break;
        case 7:
        {
            model.friendNick = @"那啥";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"测试=====http://www.jianshu.com/u/787eb6539a62";
            model.likeListArr = @[@"那啥",@"小红",@"skt"];
            
            SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
            comment.comment = @"小明";
            comment.content = @"不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！";
            model.commentArr = @[comment];
        }
            break;
        case 8:
        {
            model.friendNick = @"呵呵";
            model.friendAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 5];
            model.messageTime = @"2016-1-1";
            model.messageContent = @"测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网";
            model.likeListArr = @[@"那啥",@"小红",@"skt",@"213456787654324567865432"];
            
            SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
            comment.comment = @"小明";
            comment.replier = @"那啥";
            comment.content = @"不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！不错啊！";
            model.commentArr = @[comment];
        }
            break;
            
        default:
            break;
    }
    
    //图片和文字必须有一个
    if (!(model.messageContent.length || model.messageImageArr.count)) {
        model.messageContent = @"我就看看还有谁";
    }
    
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SHFriendTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[SHFriendTimeLineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.delegate = self;
    }
    
    cell.messageFrame = self.dataSoure[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.dataSoure[indexPath.row].cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //移除点赞
    [[SHTimeLineMenu shareSHTimeLineMenu] removeFromSuperview];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (actionSheet.tag) {
        case kActionSheet_BackGroup_Me_Tag://自己背景
        {
            switch (buttonIndex) {
                    case 0://相册
                {
                    NSLog(@"点击了==相册");
                }
                    break;
                    case 1://相机
                {
                    NSLog(@"点击了==相机");
                }
                    
                default:
                    break;
            }
        }
            break;
        case kActionSheet_BackGroup_Other_Tag://别人背景
        {
            switch (buttonIndex) {
                    case 0://保存到相册
                {
                    NSLog(@"点击了==保存到相册");
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
        case kActionSheet_Delete_Tag://删除评论
        {
            switch (buttonIndex) {
                case 0://删除
                {
                    //点击位置
                    NSInteger index = [self.dataSoure indexOfObject:self.deleteDic[@"all"]];
                    //拿出原始数据
                    SHFriendTimeLineFrame *messageFrame = self.deleteDic[@"all"];
                    
                    //重新设置内容
                    SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];
                    model = messageFrame.message;
                    
                    //构建消息内容
                    NSMutableArray <SHFriendTimeLineComment *>*messageArr = [NSMutableArray arrayWithArray:messageFrame.message.commentArr];
                    
                    //删除评论
                    [messageArr removeObject:self.deleteDic[@"delete"]];
                    
                    model.commentArr = messageArr;
                    
                    //添加内容
                    messageFrame.message = model;
                    [self.dataSoure replaceObjectAtIndex:index withObject:messageFrame];
                    //进行刷新
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    self.deleteDic = nil;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - SHFriendHeadViewDelegate
- (void)headClick:(SHFriendHeadView *)view ClickType:(SHFriendHeadClickType)clickType{
    switch (clickType) {
        case SHFriendHeadClickType_Avatar://头像
        {
            NSLog(@"头部视图===头像点击");
            [self messageUserClick:nil message:UserName];
        }
            break;
        case SHFriendHeadClickType_Background://背景
            NSLog(@"头部视图===背景点击");
        {
            UIActionSheet *sheet;
            if ([self.userInfo isEqualToString:UserName]) {//自己
                
                sheet = [[UIActionSheet alloc] initWithTitle:@"更换背景" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
                sheet.tag = kActionSheet_BackGroup_Me_Tag;
                
            }else{//其他人
                
                sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
                sheet.tag = kActionSheet_BackGroup_Other_Tag;
            }
            [sheet showInView:self.view];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SHFriendTimeLineDelegate
#pragma mark 消息体功能点击
- (void)messageClick:(SHFriendTimeLineTableViewCell *)cell type:(SHFriendTimeLineClickType)type{
    
    //移除菜单
    [[SHTimeLineMenu shareSHTimeLineMenu] removeFromSuperview];
    
    switch (type) {
        case SHFriendTimeLineClickType_fold://展开
        {
            NSLog(@"点击了====折叠");
            //取出数据
            SHFriendTimeLine *message = cell.messageFrame.message;
            message.isFold = !message.isFold;
            SHFriendTimeLineFrame *messageFrame = cell.messageFrame;
            messageFrame.message = message;
            
            NSIndexPath *index = [self.tableView indexPathForCell:cell];
            [self.dataSoure replaceObjectAtIndex:index.row withObject:messageFrame];
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case SHFriendTimeLineClickType_delete://删除
        {
            NSLog(@"点击了====删除");
            [self.dataSoure removeObject:cell.messageFrame];
            NSIndexPath *index = [self.tableView indexPathForCell:cell];
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case SHFriendTimeLineClickType_menu://菜单
        {
            NSLog(@"点击了====菜单");
            
            __block BOOL isLike = NO;
            
            //查看点赞列表是否有自己
            for (NSString *obj in cell.messageFrame.message.likeListArr) {
                if ([obj isEqualToString:UserName]) {//存在自己
                    isLike = YES;
                    break;
                }
            }
            
            //点击位置
            NSInteger index = [self.dataSoure indexOfObject:cell.messageFrame];
            
            SHTimeLineMenu *menu = [SHTimeLineMenu shareSHTimeLineMenu];
            menu.center = CGPointMake(0, cell.menuBtn.centerY);
            menu.x = CGRectGetMidX(cell.messageFrame.menuF) - menu.width - 15;
            [cell.contentView addSubview:menu];
            WeakSelf;
            [menu showMenuIsLike:isLike block:^(NSInteger type) {
                
                //重新设置内容
                SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];
                model = cell.messageFrame.message;
                
                switch (type) {
                    case 1:
                    {
                        NSLog(@"点赞");
                        //构建消息内容
                        NSMutableArray *messageArr = [NSMutableArray arrayWithArray:cell.messageFrame.message.likeListArr];
                        
                        if (isLike) {//点过赞了
                            [messageArr removeObject:UserName];
                        }else{
                            
                            [messageArr addObject:UserName];
                        }
                        
                        model.likeListArr = messageArr;
                        
                        //更新数据
                        SHFriendTimeLineFrame *messgerFrame = [[SHFriendTimeLineFrame alloc]init];
                        messgerFrame.message = model;
                        [weakSelf.dataSoure replaceObjectAtIndex:index withObject:messgerFrame];
                        //进行刷新
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    }
                        break;
                    case 2:
                    {
                        UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"用户点击" message:@"点击了正文评论" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        [ale show];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark 用户点击
- (void)messageUserClick:(SHFriendTimeLineTableViewCell *)cell message:(NSString *)message{
    
    //移除点赞
    [[SHTimeLineMenu shareSHTimeLineMenu] removeFromSuperview];
    
    UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"用户点击" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [ale show];
}

#pragma mark 回复点击
- (void)messageCommentClick:(SHFriendTimeLineTableViewCell *)cell message:(SHFriendTimeLineComment *)message{
    
    //移除点赞
    [[SHTimeLineMenu shareSHTimeLineMenu] removeFromSuperview];

    //拿出原始数据
    SHFriendTimeLineFrame *messageFrame = cell.messageFrame;
    
    //判断是否为自己
    if ([message.comment isEqualToString:UserName]) {//是自己
        
        self.deleteDic = @{@"all":messageFrame,@"delete":message};
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"删除评论?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        sheet.tag = kActionSheet_Delete_Tag;
        [sheet showInView:self.view];
        
    }else{
        UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"用户点击" message:@"点击了内容评论" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [ale show];
    }
}

#pragma mark 图片点击
- (void)imageClick:(SHFriendTimeLineTableViewCell *)cell message:(SHFriendTimeLineFrame *)message index:(NSInteger)index{
    
    NSLog(@"点击了====图片%ld",(long)index);
    //移除点赞
    [[SHTimeLineMenu shareSHTimeLineMenu] removeFromSuperview];
    
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    
    [message.message.messageImageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {

        SHPhotoBrowserModel *model = [[SHPhotoBrowserModel alloc]init];
        model.obj = obj;
        [imageArr addObject:model];
    }];

    // 图片游览器
    SHPhotoBrowserViewController *pickerBrowser = [[SHPhotoBrowserViewController alloc] init];
    // 动画效果
    pickerBrowser.status = SHPhotoBrowserAnimationAnimationStatus_Fade;
    // 图片数组
    pickerBrowser.photos = imageArr;
    // 当前选中的值
    pickerBrowser.currentIndex = index;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

#pragma mark - VC界面周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

@end
