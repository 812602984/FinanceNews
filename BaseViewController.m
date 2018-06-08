//
//  BaseViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BaseViewController.h"
#import "MyModel.h"
#import "NewsCell.h"
#import "DetailViewController.h"
#import "AdView.h"
#import "SingleView.h"
#import <Masonry.h>
#import <MJRefresh.h>

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kUrl @"https://wapi.hexun.com/Api_newsXml_v1.cc?appId=1&pid=%@&pc=20&pn=%ld"

@interface BaseViewController ()<UITableViewDataSource,UITableViewDelegate>
    {
        UITableView *_tableView;   //表格视图
        NSMutableArray *_dataArr;  //数据源数组
        AFHTTPRequestOperationManager *_manager;   //请求任务管理器
        NSMutableArray *_imageNames;   //存储滚动视图对象（图片名）
        
    }
    @property (nonatomic,strong) NSMutableArray *dataArr; //数据源数组
    @property (nonatomic,assign) BOOL isLoadMore;    //记录是否正在加载更多
    @property (nonatomic,assign) BOOL isRefreshing;      //记录是否正在刷新
    @property (nonatomic,assign) NSInteger currentPage;  //记录当前页
    @property (nonatomic,strong) NSMutableArray *textArr;   //存储滚动视图上 label 的文字
    @property (nonatomic,strong) NSMutableArray *urlArr;
    
    @end

@implementation BaseViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //夜间模式
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.title = @"财经新闻";
    [self initData];          //数据初始化
    [self creatTableView];    //创建表格
    [self creatRefreshView];  //创建刷新视图
    [self creatHttpRequest];  //创建连接请求
    [self loadDataPage:0 count:10];   //按页加载数据
}
    
#pragma mark - 数据初始化
-(void)initData{
    self.isLoadMore = self.isRefreshing = NO;
    _currentPage = 0;
    _urlArr = [NSMutableArray array];
    _imageNames = [[NSMutableArray alloc] init];  //初始化广告数组
    _textArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];   //初始化数据源
    
}
    
#pragma mark - 加滚动新闻
-(void)addAdView{
    
    AdView *adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 170)];
    
    adView.urlArr = self.urlArr;
    adView.textArr = self.textArr;
    adView.imageNames = _imageNames;
    _tableView.tableHeaderView = adView;
}
    
-(void)addSingleView:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr{
    SingleView *singleView = [[SingleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 170)];
    singleView.urlArr = _urlArr;
    singleView.textArr = titleArr;
    singleView.imageNames = imageArr;
    _tableView.tableHeaderView = singleView;
}
    
#pragma mark - 创建表格
-(void)creatTableView{
    CGRect frame = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80.f;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NewsCell"];
    
    //去掉cell左侧15像素的空白线
    [self fullLine:_tableView];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
}
    
    //去掉cell左侧15像素的空白
-(void)fullLine:(id)obj{
    if ([obj respondsToSelector:@selector(setSeparatorInset:)]) {
        [obj setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([obj respondsToSelector:@selector(setLayoutMargins:)]) {
        [obj setLayoutMargins:UIEdgeInsetsZero];
    }
}
    
#pragma mark - 创建请求连接
-(void)creatHttpRequest{
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];  //不让af自动解析
    
}
    
#pragma mark - 刷新
-(void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    
    //下拉刷新
    //    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
    //        if (weakSelf.isRefreshing) {  //如果正在刷新
    //            return;
    //        }
    //        weakSelf.isRefreshing = YES;
    //        weakSelf.currentPage = 0;
    //        [weakSelf loadDataPage:weakSelf.currentPage count:10];
    //
    //    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefreshing) {  //如果正在刷新
            return;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        [weakSelf loadDataPage:weakSelf.currentPage count:10];
    }];
    
    //上拉加载更多
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage++;
        [weakSelf loadDataPage:weakSelf.currentPage count:10];
    }];
}
    
#pragma mark - 结束刷新
-(void)endRefresh{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        //        [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        [_tableView.mj_header endRefreshing];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        //        [_tableView footerEndRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}
    
#pragma mark - 按页加载数据
-(void)loadDataPage:(NSInteger)page count:(NSInteger)count{
    //获取url
    NSString *url = [NSString stringWithFormat:kUrl,self.pid,page];
    
    __block typeof(self) weakSelf = self;
    //af get请求下载
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //responseObject 是下载下来的数据，现在是二进制格式
        if (responseObject) {
            
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects];
                [_imageNames removeAllObjects];
            }
            //xml 按照xml解析 用第三方库GData
            //1.创建文档数据
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            
            //用xPath找到文档树下的所有frame节点
            NSArray *frameArr = [doc nodesForXPath:@"//frame" error:nil];
            for (GDataXMLElement *frameNode in frameArr) {
                
                NSString *imgUrl = [frameNode stringValueByName:@"img"];
                [_imageNames addObject:imgUrl];
                
                if ([weakSelf.pid isEqualToString:@"100234721"] || [weakSelf.pid isEqualToString:@"100228599"] || [weakSelf.pid isEqualToString:@"100012296"]) {
                    
                    NSString *urlStr = [frameNode stringValueByName:@"url"];
                    [weakSelf.urlArr addObject:urlStr];
                }
                
                NSString *title = [frameNode stringValueByName:@"title"];
                [weakSelf.textArr addObject:title];
                
            }
            if (![weakSelf.pid isEqualToString:@"101002114"]){
                if (_urlArr.count>2) {
                    [weakSelf addAdView];
                }else if(_urlArr.count == 1){
                    [weakSelf addSingleView:_imageNames titleArr:weakSelf.textArr];
                }
            }
            if ([weakSelf.pid isEqualToString:@"173398673"]|| [weakSelf.pid isEqualToString:@"101710721"] || [weakSelf.pid isEqualToString:@"101710894"]) {
                _tableView.tableHeaderView = nil;
            }
            
            //2.用xPath找到文档树下的所有news节点
            NSArray *newsArr = [doc nodesForXPath:@"//news" error:nil];
            //3.遍历数组
            for (GDataXMLElement *newsNode in newsArr) {
                MyModel *model = [[MyModel alloc] init];
                model.title = [newsNode stringValueByName:@"title"];
                model.abstract = [newsNode stringValueByName:@"abstract"];
                model.imgUrl = [newsNode stringValueByName:@"img"];
                model.url = [newsNode stringValueByName:@"url"];
                model.newsId = [newsNode stringValueByName:@"id"];
                
                [_dataArr addObject:model];
            }
            [_tableView reloadData];   //下载完成后刷新表格
        }
        [weakSelf endRefresh];   //结束刷新
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载error");
        [weakSelf endRefresh];   //结束刷新
    }];
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
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    MyModel *model = _dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
    
    //-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 80;
    //}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyModel *model = _dataArr[indexPath.row];
    //模态跳转
    DetailViewController *detailCtl = [[DetailViewController alloc] init];
    //把newsId传过去
    detailCtl.model = model;
    detailCtl.newsId = model.newsId;
    detailCtl.currentPage = self.currentPage;
    
    [self.view.window.rootViewController presentViewController:detailCtl animated:YES completion:nil];
    //[self.navigationController pushViewController:detailCtl animated:YES];
}
    
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self fullLine:cell];
}
    
    @end
