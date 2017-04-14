//
//  SHFriendTimeLineTableViewController.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHFriendTimeLineTableViewController.h"
#import "SHPublishViewController.h"
#import "SHFriendTimeLineTableViewCell.h"
#import "SHFriendTimeLineHeader.h"
#import "SHFriendHeadView.h"
#import "YYFPSLabel.h"
#import "SHPhotoBrowserViewController.h"

@interface SHFriendTimeLineTableViewController ()<SHFriendTimeLineCellDelegate,SHFriendHeadViewDelegate>

//界面数据
@property (nonatomic, strong) NSMutableArray <SHFriendTimeLineFrame *>*dataSoure;
//FPS
@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation SHFriendTimeLineTableViewController

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
}

#pragma mark 配置导航栏
- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
}

#pragma mark 配置头部
- (void)setupHead{
    
    SHFriendHeadView *headerView = [[SHFriendHeadView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, 340)];
    headerView.userName = UserName;
    headerView.userAvatar = [NSString stringWithFormat:@"icon%u.jpg",arc4random() % 4];
    headerView.backgroundUrl = @"pic0.jpg";
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark 配置内容
- (void)setupContent{
    
    self.dataSoure = [NSMutableArray arrayWithArray:[self getFriendDataWithNum:20]];
    
    [self.tableView reloadData];
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
        [temp addObject:[self addFriendDataWithIndex:arc4random() % 9]];
    }
    return temp;
}

- (SHFriendTimeLineFrame *)addFriendDataWithIndex:(NSInteger )index{
    
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
            model.friendNick = @"爱谁谁";
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
            model.friendNick = @"哈哈";
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
            model.messageContent = @"测试asdf空间撒谎对方立刻就杀掉了开发计划来刷卡单交话费了空间撒谎的弗兰克季后赛度凤凰网";
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
    
    SHFriendTimeLineFrame *message = [[SHFriendTimeLineFrame alloc]init];
    message.message = model;
    
    return message;
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
    [[SHLikeAndCommentView shareSHLikeAndCommentView] removeFromSuperview];
}

#pragma mark - SHFriendHeadViewDelegate
- (void)headClick:(SHFriendHeadView *)view ClickType:(SHFriendHeadClickType)clickType{
    switch (clickType) {
        case SHFriendHeadClickType_Avatar://头像
            NSLog(@"头部视图===头像点击");
            break;
        case SHFriendHeadClickType_Background://背景
            NSLog(@"头部视图===背景点击");
            
            break;
        default:
            break;
    }
}

#pragma mark - SHFriendTimeLineCellDelegate
#pragma mark 消息体功能点击
- (void)messageClick:(SHFriendTimeLineTableViewCell *)cell Message:(SHFriendTimeLineFrame *)message ClickType:(SHFriendTimeLineClickType)clickType{
    //移除点赞
    [[SHLikeAndCommentView shareSHLikeAndCommentView] removeFromSuperview];
    
    switch (clickType) {
        case SHFriendTimeLineClickType_Open://展开
        {
            NSLog(@"点击了====展开");
        }
            break;
        case SHFriendTimeLineClickType_LikeANDComment://点赞
        {
            NSLog(@"点击了====点赞");
            
            __block BOOL isLike = NO;
            
            //查看点赞列表是否有自己
            for (NSString *obj in message.message.likeListArr) {
                if ([obj isEqualToString:UserName]) {//存在自己
                    isLike = YES;
                    break;
                }
            }
            
            //点击位置
            NSInteger index = [self.dataSoure indexOfObject:message];
            
            WeakSelf;
            [[SHLikeAndCommentView shareSHLikeAndCommentView] showSHLikeAndCommentWithSupVc:cell Frame:message.likeF isLike:isLike Block:^(NSInteger type) {
                
                //重新设置内容
                SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];
                model = message.message;
                
                switch (type) {
                    case 1:
                    {
                        NSLog(@"点赞");
                
                        //构建消息内容
                        NSMutableArray *messageArr = [NSMutableArray arrayWithArray:message.message.likeListArr];
                        
                        if (isLike) {//点过赞了
                            
                            [messageArr removeObject:UserName];
                        }else{
                            
                            [messageArr addObject:UserName];
                        }
                        
                        model.likeListArr = messageArr;
                        
                    }
                        break;
                    case 2:
                    {
                        NSLog(@"评论");
                        //构建消息内容
                        NSMutableArray <SHFriendTimeLineComment *>*messageArr = [NSMutableArray arrayWithArray:message.message.commentArr];
                        //添加评论
                        SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
                        comment.comment = UserName;
                        comment.content = @"我是自动评论！！！！http://www.jianshu.com/u/787eb6539a62";
                        [messageArr addObject:comment];
                        
                        model.commentArr = messageArr;
                    }
                        break;
                    default:
                        break;
                }
                
                //添加内容
                message.message = model;
                [weakSelf.dataSoure replaceObjectAtIndex:index withObject:message];
                //进行刷新
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
            break;
        case SHFriendTimeLineClickType_Comment://评论
        {
            //点击位置
            NSInteger index = [self.dataSoure indexOfObject:message];
            
            //重新设置内容
            SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];
            model = message.message;
            
            
            //构建消息内容
            NSMutableArray <SHFriendTimeLineComment *>*messageArr = [NSMutableArray arrayWithArray:message.message.commentArr];
            //添加评论
            SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
            comment.comment = UserName;
            comment.content = @"我是自动评论！！！！http://www.jianshu.com/u/787eb6539a62";
            [messageArr addObject:comment];
            
            //添加内容
            message.message = model;
            [self.dataSoure replaceObjectAtIndex:index withObject:message];
            //进行刷新
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        default:
            break;
    }
}

#pragma mark 用户点击
- (void)messageUserClick:(SHFriendTimeLineTableViewCell *)cell Message:(NSString *)message{
    
    UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"点击了用户:%@",message] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [ale show];
}

#pragma maek 回复点击
- (void)messageCommentClick:(SHFriendTimeLineTableViewCell *)cell Message:(SHFriendTimeLineComment *)message{
    
    //移除点赞
    [[SHLikeAndCommentView shareSHLikeAndCommentView] removeFromSuperview];
    
    //点击位置
    NSInteger index = [self.dataSoure indexOfObject:cell.messageFrame];
    //拿出原始数据
    SHFriendTimeLineFrame *messageFrame = cell.messageFrame;
    
    //重新设置内容
    SHFriendTimeLine *model = [[SHFriendTimeLine alloc]init];
    model = messageFrame.message;
    
    //构建消息内容
    NSMutableArray <SHFriendTimeLineComment *>*messageArr = [NSMutableArray arrayWithArray:messageFrame.message.commentArr];
    //判断是否为自己
    if ([message.comment isEqualToString:UserName]) {//是自己
        
        //删除评论
        [messageArr removeObject:message];
    }else{
        //添加评论
        SHFriendTimeLineComment *comment = [[SHFriendTimeLineComment alloc]init];
        comment.comment = UserName;
        comment.replier = message.comment;
        comment.content = @"我是自动评论！！！！http://www.jianshu.com/u/787eb6539a62";
        [messageArr addObject:comment];
    }

    model.commentArr = messageArr;
    
    //添加内容
    messageFrame.message = model;
    [self.dataSoure replaceObjectAtIndex:index withObject:messageFrame];
    //进行刷新
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 图片点击
- (void)imageClick:(SHFriendTimeLineTableViewCell *)cell Message:(SHFriendTimeLineFrame *)message Index:(NSInteger)index{
    
    NSLog(@"点击了====图片%ld",(long)index);
    //移除点赞
    [[SHLikeAndCommentView shareSHLikeAndCommentView] removeFromSuperview];
    
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
