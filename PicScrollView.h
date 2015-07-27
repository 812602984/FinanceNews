//
//  PicScrollView.h
//  FinanceNews
//
//  Created by qianfeng on 15/6/28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicScrollView : UIScrollView

@property (nonatomic,strong) NSMutableArray *imageNames;  //可变数组，用来存储滚动图片的名字
@property (nonatomic,strong) NSMutableArray *textArr;

@property (nonatomic)UILabel *shareLabel;
@property (nonatomic)UIImage *shareImage;

-(instancetype)initWithFrame:(CGRect)frame;

@end
