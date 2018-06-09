//
//  PicNewsViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PicDetailViewController.h"
#import "PicScrollView.h"
#import "Define.h"
//#import "UMSocial.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface PicDetailViewController ()
//<UMSocialUIDelegate>
{
    PicScrollView *_scrollView;
}

@end

@implementation PicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addView];
    [self addTopView];
    [self addScrollView];
}

//设置状态条背景为黑色
-(void)addView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

//加顶部视图
-(void)addTopView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, 35)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topviewbg.png"]];
    [self.view addSubview:view];
    
    //加按钮
    NSArray *titleArr = @[@"返回",@"下载",@"分享",@"评论"];
    CGRect frame = CGRectMake(5, 0, 40, 30);
    for (NSInteger i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.tag = 200 + i;
        if (i == 0) {
            button.frame = frame;
        }else{
            frame.origin.x = 180 + i*45;
            button.frame = frame;
        }
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:nil size:15];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        
    }
}

-(void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 200:
        {   //返回
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 201:
        {   //下载
            UIImageWriteToSavedPhotosAlbum(_scrollView.shareImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            
        }
            break;
        case 202:
        {   //分享
//            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55923a8767e58e5ab60023ff" shareText:_scrollView.shareLabel.text shareImage:_scrollView.shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, UMShareToWechatTimeline,UMShareToEmail,UMShareToSms,UMShareToQQ,UMShareToQzone,nil] delegate:self];

        }
            break;
        case 203:
        {   //评论
            
        }
            break;
        default:
            break;
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

//加滚动视图
-(void)addScrollView{
    
    _scrollView = [[PicScrollView alloc] initWithFrame:CGRectMake(0, 100, kScreenSize.width, kScreenSize.height-100)];
    _scrollView.textArr = self.model.picsAbstractArr;
    _scrollView.imageNames = self.model.picsArr;
    
    [self.view addSubview:_scrollView];
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
