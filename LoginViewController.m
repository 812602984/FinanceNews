//
//  LoginViewController.m
//  FinanceNews
//
//  Created by qianfeng001 on 15-7-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LoginViewController.h"
#import "Define.h"

@interface LoginViewController ()
{
    UIWebView *_webView;
}
@end

@implementation LoginViewController

//返回
- (IBAction)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 55, kScreenSize.width, kScreenSize.height-55)];
    NSString *urlStr = @"https://reg.hexun.com/h5/login.aspx?client=android&fromhost=HX_Mobile_1003&top=n";
    NSURL *url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
