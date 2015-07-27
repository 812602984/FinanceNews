//
//  AdView.h
//  FinanceNews
//
//  Created by qianfeng on 15-6-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdView : UIScrollView
{
    NSTimer *_moveTime;  //循环滚动的周期时间
    BOOL _isTimeUp;
    
}

//循环滚动的三个视图
@property (nonatomic) UIImageView *leftImageView;
@property (nonatomic) UIImageView *centerImageView;
@property (nonatomic) UIImageView *rightImageView;

//3个label
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *centerLabel;
@property (nonatomic) UILabel *rightLabel;

//3个url
@property (nonatomic) NSString *leftUrl;
@property (nonatomic) NSString *centerUrl;
@property (nonatomic) NSString *rightUrl;


@property (nonatomic) NSArray *imageArr;
@property (nonatomic) NSArray *titleArr;
@property (nonatomic) NSArray *urlArr;
//循环滚动的周期时间

-(instancetype)initWithFrame:(CGRect)frame;

@end
