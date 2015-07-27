//
//  PicScrollView.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PicScrollView.h"
#import "UIImageView+WebCache.h"
#import "LZXHelper.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kFrameSize self.frame.size

@interface PicScrollView() <UIScrollViewDelegate>{
    UIScrollView *_scrollView;     //滚动视图
    UIPageControl *_pageControl;   //页码控制器
}

@end

@implementation PicScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(void)setImageNames:(NSMutableArray *)imageNames{
    UILabel *label;
    CGRect frame = CGRectMake(3, kFrameSize.height-135, kScreenSize.width-6, 0);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width,kFrameSize.height)];
    for (NSInteger i=0; i<self.textArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenSize.width, 20, kScreenSize.width, kFrameSize.height-150)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNames[i]]];
        //设置图片内容的显示模式（自适应模式）
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //显示当前页数的label
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -25, kScreenSize.width, 25)];
        pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",i+1,self.textArr.count];
        pageLabel.textColor = [UIColor whiteColor];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:pageLabel];
        
        //显示图片简介文字的label
        frame.size.height = [LZXHelper textHeightFromTextString:self.textArr[i] width:kScreenSize.width-6 fontSize:14];
        label = [[UILabel alloc] initWithFrame:frame];
        //label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:nil size:14];
        label.numberOfLines = 0;
        //label.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
        label.text = [NSString stringWithFormat:@"    %@",self.textArr[i]];
        label.textColor = [UIColor whiteColor];
        [imageView addSubview:label];
        
        _shareImage = [UIImage imageNamed:imageNames[i]];
        _shareLabel.text = label.text;
        
        [_scrollView addSubview:imageView];
    }
    //下面设置滚动视图
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;   //关闭弹簧
    _scrollView.contentSize = CGSizeMake(kScreenSize.width*self.textArr.count, kFrameSize.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

@end
