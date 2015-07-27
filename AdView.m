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

//下面是第二种方法中用
#define UISCREENWIDTH  self.bounds.size.width   //广告的宽度
#define UISCREENHEIGHT  self.bounds.size.height //广告的高度
#define HIGHT self.bounds.origin.y
static CGFloat const chageImageTime = 3.0;
static NSInteger currentImage = 1;   //记录中间图片的下标，开始总是1

@interface AdView() <UIScrollViewDelegate>{
    
}
@property (nonatomic) UIPageControl *pageControl;

@end
@implementation AdView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(3*UISCREENWIDTH, UISCREENHEIGHT);
        self.delegate = self;
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_leftImageView];
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_centerImageView];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        [self addSubview:_rightImageView];
        
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;
        
    }
    return self;
}

-(void)setUrlArr:(NSArray *)urlArr{
    _urlArr = urlArr;
    _leftUrl = _urlArr[0];
    _centerUrl = _urlArr[1];
    _rightUrl = _urlArr[2];
}

-(void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
    
    _leftImageView.tag = 100;
    _centerImageView.tag = 101;
    _rightImageView.tag = 102;
    
    //打开用户交互
    _leftImageView.userInteractionEnabled = YES;
    _centerImageView.userInteractionEnabled = YES;
    _rightImageView.userInteractionEnabled = YES;
    
    //给imageView加手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_leftImageView addGestureRecognizer:tap1];
    [_centerImageView addGestureRecognizer:tap2];
    [_rightImageView addGestureRecognizer:tap3];
    
    [self setPageControl];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{

    DetailViewController *detail = [[DetailViewController alloc] init];
    if (tap.view.tag == 100) {
        detail.url = _leftUrl;
    } else if(tap.view.tag == 101){
        detail.url = _centerUrl;
    }else{
        detail.url = _rightUrl;
    }
    [self.window.rootViewController presentViewController:detail animated:YES completion:nil];
}

-(void)setPageControl{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _imageArr.count;
    _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages,HIGHT + UISCREENHEIGHT-20, 20*_pageControl.numberOfPages, 20);
    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}

- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}


-(void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    _leftLabel = [[UILabel alloc]init];
    _centerLabel = [[UILabel alloc]init];
    _rightLabel = [[UILabel alloc]init];
    UIColor *labelColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
    _leftLabel.backgroundColor = _centerLabel.backgroundColor = _rightLabel.backgroundColor = labelColor;
    
    _leftLabel.frame = CGRectMake(0,self.bounds.size.height - 20, UISCREENWIDTH, 20);
    [_leftImageView addSubview:_leftLabel];
    _centerLabel.frame = CGRectMake(0, self.bounds.size.height - 20, UISCREENWIDTH, 20);
    [_centerImageView addSubview:_centerLabel];
    _rightLabel.frame = CGRectMake(0, self.bounds.size.height - 20, UISCREENWIDTH, 20);
    [_rightImageView addSubview:_rightLabel];
    _leftLabel.textAlignment =_centerLabel.textAlignment = _rightLabel.textAlignment = NSTextAlignmentLeft;
    
    UIFont *font = [UIFont fontWithName:nil size:13];
    UIColor *textColor = [UIColor whiteColor];
    _leftLabel.textColor = _centerLabel.textColor = _rightLabel.textColor = textColor;
    _leftLabel.font = _centerLabel.font = _rightLabel.font =font;
    _leftLabel.text = _titleArr[0];
    _centerLabel.text = _titleArr[1];
    _rightLabel.text = _titleArr[2];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.contentOffset.x == 0)
    {
        currentImage = (currentImage-1)%_imageArr.count;
        _pageControl.currentPage = (_pageControl.currentPage - 1)%_imageArr.count;
    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2)
    {
        currentImage = (currentImage+1)%_imageArr.count;
        _pageControl.currentPage = (_pageControl.currentPage + 1)%_imageArr.count;
    }
    else
    {
        return;
    }
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[(currentImage-1)%_imageArr.count]]];
    _leftLabel.text = [NSString stringWithFormat:@"  %@",_titleArr[(currentImage-1)%_imageArr.count]];
    
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[currentImage%_imageArr.count]]];
    _centerLabel.text = [NSString stringWithFormat:@"  %@",_titleArr[currentImage%_imageArr.count]];
    
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[(currentImage+1)%_imageArr.count]]];
    _rightLabel.text = [NSString stringWithFormat:@"  %@",_titleArr[(currentImage+1)%_imageArr.count]];
    
    _leftUrl = _urlArr[(currentImage-1)%_urlArr.count];
    _centerUrl = _urlArr[currentImage%_urlArr.count];
    _rightUrl = _urlArr[(currentImage+1)%_urlArr.count];

    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

@end
