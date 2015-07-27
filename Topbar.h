//
//  Topbar.h
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTopbarHeight 30
typedef void (^ButtonClickHandler)(NSInteger currentPage);

@interface Topbar : UIScrollView

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) ButtonClickHandler blockHandler;
@end
