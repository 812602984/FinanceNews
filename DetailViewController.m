//
//  DetailViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "DBManager.h"
#import "UMSocial.h"
#import "Define.h"
#import "CommentViewController.h"

@interface DetailViewController ()<UMSocialUIDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    NSMutableArray *_dataArr;
    NSString *_sharedtext;
}
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController
//返回
- (IBAction)BackClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}

//字号修改
- (IBAction)fontSizeClick:(id)sender {
    //弹出修改字号的alertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置内容字号" message:@"fontSize" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

//收藏
- (IBAction)collectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"已收藏" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:nil size:14];
    [[DBManager sharedManager] insertModel:self.model];
}

//分享
- (IBAction)shareClick:(id)sender {
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55923a8767e58e5ab60023ff" shareText:_sharedtext shareImage:@"Icon.png" shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, UMShareToWechatTimeline,UMShareToEmail,UMShareToSms,UMShareToQQ,UMShareToQzone,nil] delegate:self];
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self setButton];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if(self.newsId){
        [self loadData];
    }
    if (self.url) {
        [self loadRequest];
    }
    [self addCommentView];
}

//评论模块
-(void)addCommentView{
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"查看评论" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:nil size:13];
    button.frame = CGRectMake(_webView.frame.size.width-80, _webView.frame.size.height-40, 70, 30);
    [button addTarget:self action:@selector(scanComment) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:button];
}

//跳转到评论页面，查看
-(void)scanComment{
    CommentViewController *commentVc = [[CommentViewController alloc] init];
    commentVc.url = [NSString stringWithFormat:kCommentUrl,self.newsId];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentVc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)setButton{
    BOOL isExist = [[DBManager sharedManager] isExistForTitle:self.model.title];
    if (isExist) {
        self.collectButton.enabled = NO;
        [self.collectButton setTitle:@"已收藏" forState:UIControlStateDisabled];
        self.collectButton.titleLabel.font = [UIFont fontWithName:nil size:12];
    }else{
        self.collectButton.enabled = YES;
        [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    }
}

-(void)loadRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
}

#pragma mark - 加载数据
-(void)loadData{
    //获取url
    NSString *url = [NSString stringWithFormat:kDetailUrl,self.newsId];
    
    //af get请求下载
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //responseObject 是下载下来的数据，现在是二进制格式
        if (responseObject) {
            //xml 按照xml解析 用第三方库GData
            //1.创建文档数据
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            //2.用xPath找到文档树下的所有frame节点
            NSArray *newsArr = [doc nodesForXPath:@"//news" error:nil];
            //3.遍历数组
            
            NSString *titleStr = [newsArr[0] stringValueByName:@"title"];
            NSString *timeStr= [NSString stringWithFormat:@"%@ 来源:%@",[newsArr[0] stringValueByName:@"date"],[newsArr[0] stringValueByName:@"media"]];
            NSString *str1 = [NSString stringWithFormat:@"<div><center><b><font size=4>%@</font></b></center></div>",titleStr];
            NSString *str2 = [NSString stringWithFormat:@"<div><center><font size=2>%@</font></center></div>",timeStr];
            NSString *str3 = [str1 stringByAppendingString:str2];
            
            /*改变图片src 未成功
            [_webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
                "script.type = 'text/javascript';"
                "script.text = \"function changeImage(){"
                "document.getElementsByTagName('img').src='http://a.hiphotos.baidu.com/image/pic/item/9213b07eca806538fcc3e71295dda144ad348282.jpg';"
             "}\";"
             "document.getElementsByTagName('head')[0].appendChild(script);"
             ];
            
            [_webView stringByEvaluatingJavaScriptFromString:@"changeImage();"];
             */
            
            NSString *htmlStr = [str3 stringByAppendingString:[newsArr[0] stringValueByName:@"content"]];
            NSString *str = [htmlStr componentsSeparatedByString:@"<span"][0];
    
            _sharedtext = url;
            [_webView loadHTMLString:str baseURL:nil];
            [self addCommentView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载error");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        
        //修改字号
        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%@'",tf.text];
        [_webView stringByEvaluatingJavaScriptFromString:str];
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

#pragma mark - webView delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (kScreenSize.width == 320) {
        NSString *str = @"document.getElementByTagName('body')[0].style.webkitTextSizeAdjust='85%'";
        [_webView stringByEvaluatingJavaScriptFromString:str];
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth;"
         "var maxwidth=300;" //缩放系数
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "oldwidth = myimg.width;"
         "myimg.width = maxwidth;"
         "myimg.height = myimg.height * (maxwidth/oldwidth)+120;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    }else if (kScreenSize.width == 375) {
        NSString * srt = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '95%'";
        [_webView stringByEvaluatingJavaScriptFromString:srt];
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth;"
         "var maxwidth=360;" //缩放系数
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "oldwidth = myimg.width;"
         "myimg.width = maxwidth;"
         "myimg.height = myimg.height * (maxwidth/oldwidth)+160;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    }
    [self.view addSubview:_webView];
}

@end
