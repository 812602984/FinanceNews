//
//  CollectionViewController.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CollectionViewController.h"
#import "NewsCell.h"
#import "MyModel.h"
#import "DBManager.h"
#import "Define.h"
#import "DetailViewController.h"

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *removeArr;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataInit];
    [self createTableView];
}

-(void)dataInit{
    _dataArr = [NSMutableArray array];
    _dataArr = [NSMutableArray arrayWithArray:[[DBManager sharedManager] readModelsWithTitle:nil]];
    
    [self addButton];
    [self addEditButton];
}

//创建表格
-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height-20) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self hideExtraLine];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    
    [self addDeleteButton];
}

//懒加载
-(NSMutableArray *)removeArr{
    if (!_removeArr) {
        _removeArr = [[NSMutableArray alloc] init];
    }
    return _removeArr;
}

-(void)addButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5,25, 15, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addEditButton{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    [editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(kScreenSize.width-100,20, 40, 40);
    [editButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    editButton.tintColor = [UIColor clearColor];
    
    [self.view addSubview:editButton];
}

- (void)addDeleteButton {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(kScreenSize.width-50, 20, 35, 40);
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor whiteColor]];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setEnabled:NO];
    [deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    deleteButton.tag = 100;
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];

}

// 删除按钮被按下
- (void)delete:(id)sender {
    if ([self.tableView isEditing]) {

        for (MyModel *model in self.removeArr) {
            [[DBManager sharedManager] deleteByTitle:model.title];
        }
        
        // 删除数据源中对应的数据
        [self.dataArr removeObjectsInArray:self.removeArr];
        [self.removeArr removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (void)edit:(UIButton *)button {
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    btn.enabled = YES;
    button.selected = !button.selected;
    [self.tableView setEditing:button.selected animated:YES];
}

// 是否允许编辑，默认返回YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

//tableView开启多行选中的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

// 修改delete-->删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)hideExtraLine{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//选中一行时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        MyModel *model = [self.dataArr objectAtIndex:indexPath.row];
        if (![self.removeArr containsObject:model]) {
            [_removeArr addObject:model];
        }
    }else{
        MyModel *model = _dataArr[indexPath.row];
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.newsId = model.newsId;
        
        [self presentViewController:detail animated:YES completion:nil];
    }
}

//取消选中一行时
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        MyModel *model = [self.dataArr objectAtIndex:indexPath.row];
        if ([_removeArr containsObject:model]) {
            [_removeArr removeObject:model];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
