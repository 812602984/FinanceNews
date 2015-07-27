//
//  SearchResultViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Define.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "MyModel.h"
#import "GDataXMLNode.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic)AFHTTPRequestOperationManager *manager;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"搜索结果";
    
    [self dataInit];
    [self createTableView];
    [self loadData];
}

-(void)dataInit{
    _dataArr = [NSMutableArray array];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self addButton];
}

-(void)addButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 20, 30, 30);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//创建表格
-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kScreenSize.width , kScreenSize.height-20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self hideExtraLine];
    [self.view addSubview:self.tableView];
}

//隐藏多余的分割线
-(void)hideExtraLine{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
}

-(void)loadData{
    __block typeof(self) weakSelf = self;
    [_manager GET:self.searchUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *arr = [doc nodesForXPath:@"//data" error:nil];
            for (GDataXMLElement *dataNode in arr) {
                MyModel *model = [[MyModel alloc] init];
                model.title = [dataNode stringValueByName:@"title"];
                model.abstract = [dataNode stringValueByName:@"time"];
                model.newsId = [dataNode stringValueByName:@"id"];
                [weakSelf.dataArr addObject:model];
            }
            if(_dataArr.count == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"没有您要的内容" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                
                [alert show];
            }else{
                [weakSelf.tableView reloadData];
            }
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}

#pragma  mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    MyModel *model = _dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.abstract;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyModel *model = _dataArr[indexPath.row];
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    detailVc.newsId = model.newsId;
    [self presentViewController:detailVc animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
