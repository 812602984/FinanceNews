//
//  DetailViewController.h
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

#define kDetailUrl @"http://wapi.hexun.com/Api_newsDetail.cc?newsId=%@"

@interface DetailViewController : UIViewController

@property (nonatomic,copy) NSString *newsId;
@property (nonatomic,copy) NSString *url;
@property (nonatomic) MyModel *model;
@property (nonatomic)NSInteger currentPage;

@end