//
//  AdView.m
//  FinanceNews
//
//  Created by qianfeng on 15-6-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AdView.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@implementation AdView
{
    UIScrollView *_scrollView;     //滚动视图
    UIPageControl *_pageControl;   //页码控制器
    
}
    
-(void)setImageNames:(NSMutableArray *)imageNames{
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label;
    CGRect frame = CGRectMake(0, 150, kScreenSize.width, 20);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width,170)];
    for (int i=0; i<imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenSize.width, 0, kScreenSize.width, 170)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNames[i]]];
        imageView.tag = 200 + i;
        
        //给imageView添加手势点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        label.alpha = 0.5;
        label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        //[label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"label_bg"]]];  //设置背景
        label.alpha = 0.5;
        label.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.3 alpha:0.9];
        
        
        label.text = self.textArr[i];
        label.textColor = [UIColor whiteColor];
        
        [imageView addSubview:label];
        [_scrollView addSubview:imageView];
    }
    //下面设置滚动视图
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreenSize.width*imageNames.count, 170);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    //页码器
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenSize.width-65, 170-20, 65, 20)];
    if (imageNames.count > 1) {
        _pageControl.numberOfPages = imageNames.count;
    }
    
    [_pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}
    
- (void)pageClick:(UIPageControl *)page {
    //修改滚动视图的偏移量
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*page.currentPage, 0) animated:YES];
}
    
    //imageView手势点击事件
- (void)tapClick:(UITapGestureRecognizer *)tap
    {        
        NSInteger tag = tap.view.tag;
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.url = self.urlArr[tag-200];
        [self.window.rootViewController presentViewController:detail animated:YES completion:nil];
    }
    
    //减速停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //修改页码
    CGPoint offset = _scrollView.contentOffset;
    _pageControl.currentPage = offset.x/_scrollView.bounds.size.width;
}
    
    @end
