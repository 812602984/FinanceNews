//  LeftViewController.m
//  侧边栏特效
//
//  Created by qianfeng on 15-6-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LeftViewController.h"
#import "BaseViewController.h"
#import "PicsRootViewController.h"
#import "VideoViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
}

@property (nonatomic)UITableView *tableView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftviewbg.jpg"]];
    
    [self dataInit];
    [self tableViewInit];
    [self hideExtraLine];
}

-(void)dataInit{
    _dataArr = [NSMutableArray arrayWithArray:@[@"新闻",@"图片",@"行情",@"杂志",@"视频"]];
}

-(void)tableViewInit{
    CGRect frame = self.view.bounds;
    frame.origin.y = 60;
    //self.tableView.frame = frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.tableView setSeparatorColor:[UIColor purpleColor]];   //设置tableViewCell间的分割线的颜色
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftCell"];
}

//隐藏多余的分割线
-(void)hideExtraLine{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"left-%ld",indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font =[UIFont fontWithName:nil size:16];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            [self.side hideSideViewController:YES];   //侧边栏退去，恢复正常状态
        }
            break;
        case 1:{
            PicsRootViewController *picsRoot = [[PicsRootViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picsRoot];
//            nav.navigationBarHidden = YES;
//            [self presentViewController:nav animated:YES completion:nil];
            picsRoot.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:picsRoot animated:YES completion:nil];

        }
        case 4:{
            VideoViewController *video = [[VideoViewController alloc] init];
            video.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:video animated:YES completion:nil];
            
        }
        default:
            break;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
