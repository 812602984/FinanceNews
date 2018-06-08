//
//  SearchViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SearchViewController.h"
#import "Define.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    [self addSearchBar];

}

-(void)addSearchBar{
    
    [self addBackButton];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, kStatusBarH + 44, kScreenSize.width, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入新闻关键词";
    
    [self.view addSubview:searchBar];
}

//自定义导航栏的返回按钮
-(void)addBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 20, 15, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:NO];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSString *url = [NSString stringWithFormat:kSearchUrl,[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    SearchResultViewController *resultVc = [[SearchResultViewController alloc] init];
    
    resultVc.searchUrl = url;
//    [self presentViewController:resultVc animated:YES completion:nil];
    [self.navigationController pushViewController:resultVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
