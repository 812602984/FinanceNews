//
//  RightViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RightViewController.h"
#import "CollectionViewController.h"
#import "SearchViewController.h"
#import "SDImageCache.h"
#import "LoginViewController.h"

@interface RightViewController ()<UIActionSheetDelegate>

@end

@implementation RightViewController

//登陆
- (IBAction)loginClick {
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    loginVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;   //水平翻转
//    loginVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   //交叉溶解
//    loginVc.modalTransitionStyle = UIModalTransitionStylePartialCurl;   //翻页
    [self presentViewController:loginVc animated:YES completion:nil];
   
}

//搜索
- (IBAction)searchClick:(id)sender {
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:searchVc animated:YES];
}

//收藏
- (IBAction)collectionClick:(id)sender {
    CollectionViewController *collection = [[CollectionViewController alloc] init];
    collection.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:collection animated:YES completion:nil];
}

//清除缓存
- (IBAction)clearCache:(id)sender {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"共有%.3fM缓存",[self getCacheSize]] preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"清理" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[SDImageCache sharedImageCache] clearDisk];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
}

-(CGFloat)getCacheSize{
    //获得图片缓存大小
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    
    CGFloat totalSize = ((CGFloat)imageCacheSize)/1024/1024;
    return totalSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
