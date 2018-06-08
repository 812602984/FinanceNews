//  PicsRootViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PicsRootViewController.h"
#import "AFNetworking.h"
#import "Define.h"
#import "GDataXMLNode.h"
#import "PicModel.h"
#import "PicCell.h"
#import "PicDetailViewController.h"

@interface PicsRootViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
    {
        AFHTTPRequestOperationManager *_manager;
    }
    
    @property (nonatomic)UICollectionView *collectionView;
    @property (nonatomic)NSMutableArray *dataArr;
    @property (nonatomic,copy)NSString *pid;
    
    @property (nonatomic) BOOL isLoadMore;
    @property (nonatomic) BOOL isRefreshing;
    @property (nonatomic) NSInteger currentPage;
    
    @end

@implementation PicsRootViewController
    //@dynamic pid;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self dataInit];
    [self creatTopView];
    [self creatButtons];
    [self creatCollectionView];
    [self creatRefreshView];  //创建刷新视图
    
    [self loadData:@"126595066" page:_currentPage];
    
}
    
    //数据初始化
-(void)dataInit{
    self.isLoadMore = self.isRefreshing = NO;
    _currentPage = 1;
    _dataArr = [NSMutableArray array];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
    
    //创建刷新视图
-(void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    
    //下拉刷新
    [_collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 1;
        [weakSelf loadData:weakSelf.pid page:weakSelf.currentPage];
    }];
    
    //上拉加载更多
    [_collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage++;
        [weakSelf loadData:weakSelf.pid page:weakSelf.currentPage];
    }];
}
    
    //结束刷新
-(void)endRefresh{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [_collectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [_collectionView footerEndRefreshing];
    }
}
    
    //加topView
-(void)creatTopView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH, self.view.bounds.size.width, 40)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg.png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 5, 60, 30);
    [topView addSubview:button];
    [self.view addSubview:topView];
}
    
-(void)btnClick:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
    //创建按钮
-(void)creatButtons{
    NSArray *buttonTitles = @[@"新闻",@"股票",@"汽车",@"房产",@"理财"];
    CGFloat padding = kScreenSize.width/(buttonTitles.count+1);
    for (NSInteger i=0; i<buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor blackColor];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.frame = CGRectMake(17+i*padding, kStatusBarH + 40, padding, 30);
        button.tag = i+100;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}
    
    
-(void)titleClick:(UIButton *)btn{
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
    switch (btn.tag) {
        case 100:{//新闻
            
            [self loadDataByPid:@"126595066"];
            
        }
        break;
        case 101:{//股票
            
            [self loadDataByPid:@"132138528"];
            
        }
        break;
        case 102:{//汽车
            
            [self loadDataByPid:@"126595734"];
            
        }
        break;
        case 103:{//房产
            
            [self loadDataByPid:@"126649497"];
            
        }
        break;
        case 104:{//理财
            
            [self loadDataByPid:@"126599125"];
            
        }
        break;
        default:
        break;
    }
}
    
-(void)loadDataByPid:(NSString *)pid{
    self.pid = pid;
    [self loadData:pid page:_currentPage];
}
    
    //创建集合视图
-(void)creatCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(140, 120);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;   //设置滚动方向为垂直
    layout.minimumLineSpacing = 10;   //设置竖直方向cell的最小间隔
    layout.minimumInteritemSpacing = 10;   //设置cell之间的最小水平间隔
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarH+70, kScreenSize.width, kScreenSize.height-kStatusBarH-70) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PicCell" bundle:nil] forCellWithReuseIdentifier:@"PicCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
}
    
    //下载数据
-(void)loadData:(NSString *)pid page:(NSInteger)page{
    NSString *picUrl = [NSString stringWithFormat:kPicUrl,pid,page];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"数据下载" status:@"loading..."];
    
    __weak typeof(self) weakSelf = self;
    [_manager GET:picUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            //            if (page == 1) {
            //                [weakSelf.dataArr removeAllObjects];
            //
            //            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *newsArr = [doc nodesForXPath:@"//news" error:nil];
            
            for (GDataXMLElement *newsNode in newsArr) {
                PicModel *model = [[PicModel alloc] init];
                model.title = [newsNode stringValueByName:@"title"];
                
                NSString *imgStr = [newsNode stringValueByName:@"pics"];
                model.picsArr = (NSMutableArray *)[imgStr componentsSeparatedByString:@"|"];
                
                NSString *abstractStr = [newsNode stringValueByName:@"pics_abstract"];
                model.picsAbstractArr = (NSMutableArray *)[abstractStr componentsSeparatedByString:@"||"];
                [model.picsAbstractArr removeObjectAtIndex:0];
                
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.collectionView reloadData];  //刷新数据
            
            [MMProgressHUD dismissWithSuccess:@"下载成功" title:@"恭喜你"];
        }
        [weakSelf endRefresh];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载出错");
        [weakSelf endRefresh];
        [MMProgressHUD dismissWithError:@"下载失败" title:@"警告"];
    }];
}
    
#pragma mark - collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
    
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PicCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic_cell_bg.png"]];
    PicModel *model = self.dataArr[indexPath.row];
    
    [cell showCellWithModel:model];
    return cell;
}
    
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PicModel *model = _dataArr[indexPath.row];
    PicDetailViewController *picDetail = [[PicDetailViewController alloc] init];
    picDetail.model = model;
    picDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:picDetail animated:YES completion:nil];
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
