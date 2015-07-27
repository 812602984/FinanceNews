//
//  SingleView.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SingleView.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size

@implementation SingleView
{
    UIScrollView *_scrollView;     //滚动视图
    UIPageControl *_pageControl;   //页码控制器
    
}

-(void)setImageNames:(NSMutableArray *)imageNames{
    UILabel *label;
    CGRect frame = CGRectMake(0, 150, kScreenSize.width, 20);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width,170)];
    for (int i=0; i<imageNames.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenSize.width, 0, kScreenSize.width, 170)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNames[i]]];
      
        //添加点击手势
        imageView.userInteractionEnabled = YES;
        imageView.tag = 300 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
        
        label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:nil size:14];
        label.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
        label.text = [NSString stringWithFormat:@"  %@",self.textArr[i]];
        label.textColor = [UIColor whiteColor];
        [imageView addSubview:label];
        
        [_scrollView addSubview:imageView];
    }
    //下面设置滚动视图
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;   //关闭弹簧
    _scrollView.contentSize = CGSizeMake(kScreenSize.width*imageNames.count, 170);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
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

-(void)tapClick:(UITapGestureRecognizer *)tap{
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.url = _urlArr[tap.view.tag-300];
    [self.window.rootViewController presentViewController:detail animated:YES completion:nil];
}

- (void)pageClick:(UIPageControl *)page {
    //修改滚动视图的偏移量
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*page.currentPage, 0) animated:YES];
}
//减速停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //修改页码
    CGPoint offset = _scrollView.contentOffset;
    _pageControl.currentPage = offset.x/_scrollView.bounds.size.width;
}

@end
