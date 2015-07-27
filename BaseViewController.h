//
//  BaseViewController.h
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRefresh.h"
#import "GDataXMLNode.h"
#import "AFNetworking.h"
#import "AppListViewController.h"

@interface BaseViewController : UIViewController

@property (nonatomic,copy) NSString *pid;   //根据这个来区分页面
@property (nonatomic,strong)SideViewController *side;

@end
