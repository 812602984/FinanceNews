//
//  CommentViewController.m
//  FinanceNews
//
//  Created by qianfeng001 on 15-7-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CommentViewController.h"
#import "AFNetworking.h"
#import "Define.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "JHRefresh.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
    
    @property (nonatomic,strong) UITableView *tableView;
    @property (nonatomic,strong) NSMutableArray *dataArr;
    @property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
    @property (nonatomic)BOOL isLoadMore;
    
    @end

@implementation CommentViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    [self dataInit];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    //数据初始化
-(void)dataInit{
    _dataArr = [NSMutableArray array];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _isLoadMore = NO;
    
    [self addBackButton];
    [self createTableView];
    //[self createRefreshView];
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
    
    ////下拉刷新
    //-(void)createRefreshView{
    //    __weak typeof(self) weakSelf = self;
    //
    //    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
    //        if (weakSelf.isLoadMore) {
    //            return;
    //        }
    //        weakSelf.isLoadMore = YES;
    //
    //        [weakSelf loadDataWithPage];
    //    }];
    //}
    
    //结束下拉加载
-(void)endRefresh{
    if(self.isLoadMore){
        self.isLoadMore = NO;
        [_tableView footerEndRefreshing];
    }
}
    
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];    //注册cell
    [self hideExtraLine];
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self loadDataWithPage];
}
    
-(void)hideExtraLine{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = view;
}
    
-(void)loadDataWithPage{
    __weak typeof(self) weakSelf = self;
    
    [_manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) { //数据下载成功
        if (responseObject) { //下载成功，解析数据
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (![jsonDict[@"revdata"][@"articledata"] isKindOfClass:[NSNull class]]) {
                NSArray *articleArr = jsonDict[@"revdata"][@"articledata"];
                for (NSDictionary *dataDict in articleArr) {
                    CommentModel *model = [[CommentModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    [weakSelf.dataArr addObject:model];
                }
                
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  //数据下载失败
        NSLog(@"没有数据");
        [weakSelf endRefresh];
        return;
    }];
}
    
#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    CommentModel *model = _dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
    
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
    
    @end
