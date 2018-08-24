//
//  ViewController.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/1/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHFriendTimeLineHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进入朋友圈
- (IBAction)btnClick:(id)sender {
    SHFriendTimeLineViewController *view = [[SHFriendTimeLineViewController alloc]init];
    view.userInfo = @"那啥";
    [self.navigationController pushViewController:view animated:YES];
}

@end
