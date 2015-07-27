//
//  VideoViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VideoViewController.h"
#import "Define.h"
#import "VideoCell.h"
#import "AFNetworking.h"
#import "VideoModel.h"
#import "GDataXMLNode.h"
#import "VideoDetailViewController.h"

@interface VideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic)UICollectionView *collectionView;   //集合视图
@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic,copy)NSString *pid;

@property (nonatomic) BOOL isLoadMore;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) NSInteger currentPage;

/*
 Auto property synthesis will not synthesize property 'pid'; it will be implemented by its superclass, use @dynamic to acknowledge intention
 
 这是说编译器自动给属性title合成getter和setter的时候将会在它的父类上实现,也就是说坑爹的xcode6.3升级后ios8.3版本的UIViewController里有一个title属性,现在它不知道到底是哪一个pid.
 
 这不是我们想要的,所以添加 @dynamic告诉编译器这个属性是动态的,动态的意思是等你编译的时候就知道了它只在本类合成;
 */

@end

@implementation VideoViewController
//@dynamic pid;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self dataInit];
    [self creatTopView];
    [self creatButtons];
    [self creatCollectionView];
    [self creatRefreshView];
    [self loadData:@"175702721" page:0];
}

//数据初始化
-(void)dataInit{
    self.isLoadMore = self.isRefreshing = NO;
    _currentPage = 0;
    _dataArr = [NSMutableArray array];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
}

//加topView
-(void)creatTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg.png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(8, 0, 40, 30);
    [topView addSubview:button];
    [self.view addSubview:topView];
}

////创建刷新视图
-(void)creatRefreshView{
    __block typeof(self) weakSelf = self;
    
    //下拉刷新
    [_collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
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
        [self.collectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.collectionView footerEndRefreshing];
    }
}

-(void)btnClick:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//创建按钮
-(void)creatButtons{
    NSArray *buttonTitles = @[@"热点",@"证券",@"投资",@"学堂",@"生活"];
    CGFloat padding = kScreenSize.width/(buttonTitles.count+1);
    for (NSInteger i=0; i<buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(17+i*padding, 50, padding, 30);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)titleClick:(UIButton *)btn{
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
    switch (btn.tag) {
        case 100:{//热点
            [self loadDataByPid:@"175702721"];
        }
        break;
        case 101:{
            [self loadDataByPid:@"175702545"];
        }
            break;
        case 102:{
            [self loadDataByPid:@"175702689"];
        }
            break;
        case 103:{
            [self loadDataByPid:@"175702707"];
        }
            break;
        case 104:{
            [self loadDataByPid:@"175702744"];
        }
            break;
        default:
            break;
    }
}

-(void)loadDataByPid:(NSString *)pid{
    self.pid = pid;
    [self loadData:pid page:self.currentPage];
}

//创建集合视图
-(void)creatCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenSize.width/2-20, 140);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;   //设置滚动方向为垂直
    layout.minimumLineSpacing = 10;   //设置竖直方向cell的最小间隔
    layout.minimumInteritemSpacing = 10;   //设置cell之间的最小水平间隔
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, kScreenSize.width, kScreenSize.height-80) collectionViewLayout:layout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCell"];
    
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPlay:) name:kWillPlay object:nil];
}

//监听事件
-(void)willPlay:(NSNotification *)notify{
    VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
    detail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    detail.pid = notify.userInfo[@"newsId"];
    [self presentViewController:detail animated:YES completion:nil];
}

//下载数据
-(void)loadData:(NSString *)pid page:(NSInteger)page{
    NSString *videoUrl = [NSString stringWithFormat:kVideoUrl,pid];
    
    __weak typeof(self) weakSelf = self;
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"正在下载" status:@"loading..."];
    
    [_manager GET:videoUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
//            if (page == 0) {
//                [weakSelf.dataArr removeAllObjects];
//            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
            NSArray *newsArr = [doc nodesForXPath:@"//news" error:nil];
            
            for (GDataXMLElement *newsNode in newsArr) {
                MyModel *model = [[MyModel alloc] init];
                model.title = [newsNode stringValueByName:@"title"];
                model.imgUrl = [newsNode stringValueByName:@"img"];
                model.newsId = [newsNode stringValueByName:@"id"];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.collectionView reloadData];  //刷新数据
        }
        [MMProgressHUD dismissWithSuccess:@"下载成功" title:@"恭喜你"];
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf endRefresh];
        [MMProgressHUD dismissWithError:@"下载出错" title:@"警告"];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic_cell_bg.png"]];
    MyModel *model = self.dataArr[indexPath.row];
   
    [cell showCellWithModel:model newsId:model.newsId];
    return cell;
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
