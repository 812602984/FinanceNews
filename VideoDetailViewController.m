//
//  VideoDetailViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "Define.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoDetailViewController ()
{
    AFHTTPRequestOperationManager *_manager;
    NSString *_playUrl;
    MPMoviePlayerViewController *_mp;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VideoDetailViewController
//返回按钮
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//字号
- (IBAction)aujustFont:(id)sender {
    
}

//收藏
- (IBAction)collectionClick:(id)sender {
    
}

//分享
- (IBAction)shareClick:(id)sender {
    
}

//播放按钮
- (IBAction)playClick:(id)sender {
    _mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:_playUrl]];
    _mp.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    [self.view addSubview:_mp.view];
    [_mp.moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)playBack:(NSNotification *)nf{
    NSDictionary *dict = nf.userInfo;
    
    //获取播放返回的原因
    NSInteger type = [dict[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    //type 的值 1.自动播放完毕 2.点击Done 按钮  3.播放有异常
    switch (type) {
        case 1:
        {
            NSLog(@"自动播放完毕");
        }
            break;
        case 2:
        {
            //点击Done
            [_mp.moviePlayer stop];
            //界面跳转
            [_mp.view removeFromSuperview];
            
        }
            break;
        case 3:
        {
            NSLog(@"播放有异常");
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    [self dataInit];
    [self loadData];
}

-(void)dataInit{
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];

}

//设置状态条背景为黑色
-(void)addView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

//下载并解析数据
-(void)loadData{
    NSString *detailUrl = [NSString stringWithFormat:kVideoDetailUrl,self.pid];
    
    [_manager GET:detailUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *newsArr = [doc nodesForXPath:@"//news" error:nil];
            for (GDataXMLElement *newsNode in newsArr) {
                self.titleLabel.text = [newsNode stringValueByName:@"title"];
                self.timeLabel.text = [newsNode stringValueByName:@"date"];
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:[newsNode stringValueByName:@"picture"]]];
                [self.webView loadHTMLString:[newsNode stringValueByName:@"content"] baseURL:nil];
                _playUrl = [newsNode stringValueByName:@"mvideo"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
