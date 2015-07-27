//
//  SingleView.h
//  FinanceNews
//
//  Created by qianfeng on 15/6/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *imageNames;  //可变数组，用来存储滚动图片的名字
@property (nonatomic,strong) NSMutableArray *textArr;
@property (nonatomic,strong) NSMutableArray *urlArr;

@end
