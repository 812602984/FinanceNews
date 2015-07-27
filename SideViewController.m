//
//  SideViewController.m
//  侧边栏特效
//
//  Created by qianfeng on 15-6-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SideViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SideViewController ()<UIGestureRecognizerDelegate>{
UIView *_baseView;//目前是_baseView
UIView *_currentView;//其实就是rootViewController.view

UIPanGestureRecognizer *_panGestureRecognizer;

CGPoint _startPanPoint;
CGPoint _lastPanPoint;
BOOL _panMovingRightOrLeft;//true是向右，false是向左

UIButton *_coverButton;

BOOL _isInit;//是否是初始化
}

@end

@implementation SideViewController
//加按钮，点击后可以出现侧边栏
-(void)addButton{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg.png"]];
    
    [self.rootViewController.view addSubview:view];
    
    //用于弹出左边栏的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 0, 30, 30);
    
    [button setBackgroundImage:[UIImage imageNamed:@"left_toggle.png"] forState:UIControlStateNormal];
    button.tag = 100;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"财经快讯";
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, view.bounds.size.width, 30);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    //用于弹出右侧边栏的按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(view.frame.size.width-50, 0, 30, 30);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"right_user.png"] forState:UIControlStateNormal];
    rightButton.tag = 101;
    [rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightButton];
  
  
}

-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        [self showLeftViewController:YES];

    }else{
        [self showRightViewController:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftViewShowWidth = 267;
        _rightViewShowWidth = 267;

        _animationDuration = 0.35;
        _showBoundsShadow = true;
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [_panGestureRecognizer setDelegate:self];
        
        _panMovingRightOrLeft = false;
        _lastPanPoint = CGPointZero;
        
        _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_coverButton addTarget:self action:@selector(hideSideViewController) forControlEvents:UIControlEventTouchUpInside];
        
        _isInit = true;
    }
    return self;
}

- (id)init{
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _baseView              = self.view;
    [_baseView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:1]];
    self.needSwipeShowMenu = true;
   
    [self addButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.rootViewController) {
        NSAssert(false, @"you must set rootViewController!!");
    }
    if (_isInit) {
        [self resetCurrentViewToRootViewController];
        _isInit=false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置主页面
- (void)setRootViewController:(UIViewController *)rootViewController{
    if (_rootViewController!=rootViewController) {
        if (_rootViewController) {
            [_rootViewController removeFromParentViewController];
        }
        _rootViewController=rootViewController;
        if (_rootViewController) {
            [self addChildViewController:_rootViewController];
            
        }
        if (!_isInit) {
            [self resetCurrentViewToRootViewController];
        }
        
    }
    //设置主视图控制器的状态栏为黑底白字
    _rootViewController.view.backgroundColor = [UIColor blackColor];
}

////设置左导航
-(void)setLeftViewController:(UIViewController *)leftViewController{
    if (_leftViewController!=leftViewController) {
        if (_leftViewController) {
            [_leftViewController removeFromParentViewController];
        }
        _leftViewController=leftViewController;
        if (_leftViewController) {
            [self addChildViewController:_leftViewController];
        }
    }
}

//设置右导航
-(void)setRightViewController:(UIViewController *)rightViewController{
    if (_rightViewController!=rightViewController) {
        if (_rightViewController) {
            [_rightViewController removeFromParentViewController];
        }
        _rightViewController=rightViewController;
        if (_rightViewController) {
            [self addChildViewController:_rightViewController];
        }
    }
}

- (void)setNeedSwipeShowMenu:(BOOL)needSwipeShowMenu{
    _needSwipeShowMenu = needSwipeShowMenu;
    if (needSwipeShowMenu) {
        [_baseView addGestureRecognizer:_panGestureRecognizer];
    }else{
        [_baseView removeGestureRecognizer:_panGestureRecognizer];
    }
}

- (void)showShadow:(BOOL)show{
    _currentView.layer.shadowOpacity    = show ? 0.8f : 0.0f;
    if (show) {
        _currentView.layer.cornerRadius = 4.0f;
        _currentView.layer.shadowOffset = CGSizeZero;
        _currentView.layer.shadowRadius = 4.0f;
        _currentView.layer.shadowPath   = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
}

-(void)resetCurrentViewToRootViewController{
    if (_currentView!=_rootViewController.view) {
        CGRect frame = CGRectZero;
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (!_currentView) {
            frame = _baseView.bounds;
        }else{
            frame=_currentView.frame;
            transform = _currentView.transform;
        }
        
        [_currentView removeFromSuperview];
        _currentView = _rootViewController.view;
        [_baseView addSubview:_currentView];
        _currentView.transform=transform;
        _currentView.frame = frame;
        if (_leftViewController.view.superview||_rightViewController.view.superview) {
            [_currentView addSubview:_coverButton];
            [self showShadow:_showBoundsShadow];
        }
        
    }
}

#pragma mark  ShowOrHideTheView
- (void)willShowLeftViewController{
    if (!_leftViewController || _leftViewController.view.superview) {
        return;
    }
    _leftViewController.view.frame=_baseView.bounds;
    [_baseView insertSubview:_leftViewController.view belowSubview:_currentView];
    if (_rightViewController && _rightViewController.view.superview) {
        [_rightViewController.view removeFromSuperview];
    }
}
- (void)willShowRightViewController{
    if (!_rightViewController || _rightViewController.view.superview) {
        return;
    }
    _rightViewController.view.frame=_baseView.bounds;
    [_baseView insertSubview:_rightViewController.view belowSubview:_currentView];
    if (_leftViewController && _leftViewController.view.superview) {
        [_leftViewController.view removeFromSuperview];
    }
}

//展示左边栏
- (void)showLeftViewController:(BOOL)animated{
    if (!_leftViewController) {
        return;
    }
    [self willShowLeftViewController];
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime = ABS(_leftViewShowWidth - _currentView.frame.origin.x) / _leftViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:_leftViewShowWidth];
        [_currentView addSubview:_coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}

//展示右边栏
- (void)showRightViewController:(BOOL)animated{
    if (!_rightViewController) {
        return;
    }
    [self willShowRightViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_rightViewShowWidth + _currentView.frame.origin.x) / _rightViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:-_rightViewShowWidth];
        [_currentView addSubview:_coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}
- (void)hideSideViewController:(BOOL)animated{
    [self showShadow:false];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_currentView.frame.origin.x / (_currentView.frame.origin.x>0?_leftViewShowWidth:_rightViewShowWidth)) * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:0];
    } completion:^(BOOL finished) {
        [_coverButton removeFromSuperview];
        [_leftViewController.view removeFromSuperview];
        [_rightViewController.view removeFromSuperview];
    }];
}
- (void)hideSideViewController{
    [self hideSideViewController:true];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Check for horizontal pan gesture
    if (gestureRecognizer == _panGestureRecognizer) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:_baseView];
        if ([panGesture velocityInView:_baseView].x < 600 && ABS(translation.x)/ABS(translation.y)>1) {
            return YES;
        }
        return NO;
    }
    return YES;
}
- (void)pan:(UIPanGestureRecognizer*)pan{
    if (_panGestureRecognizer.state==UIGestureRecognizerStateBegan) {
        _startPanPoint=_currentView.frame.origin;
        if (_currentView.frame.origin.x==0) {
            [self showShadow:_showBoundsShadow];
        }
        CGPoint velocity=[pan velocityInView:_baseView];
        if(velocity.x>0){
            if (_currentView.frame.origin.x>=0 && _leftViewController && !_leftViewController.view.superview) {
                [self willShowLeftViewController];
            }
        }else if (velocity.x<0) {
            if (_currentView.frame.origin.x<=0 && _rightViewController && !_rightViewController.view.superview) {
                [self willShowRightViewController];
            }
        }
        return;
    }
    CGPoint currentPostion = [pan translationInView:_baseView];
    CGFloat xoffset = _startPanPoint.x + currentPostion.x;
    if (xoffset>0) {//向右滑
        if (_leftViewController && _leftViewController.view.superview) {
            xoffset = xoffset>_leftViewShowWidth?_leftViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }else if(xoffset<0){//向左滑
        if (_rightViewController && _rightViewController.view.superview) {
            xoffset = xoffset<-_rightViewShowWidth?-_rightViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }
    if (xoffset!=_currentView.frame.origin.x) {
        [self layoutCurrentViewWithOffset:xoffset];
    }
    if (_panGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        if (_currentView.frame.origin.x==0) {
            [self showShadow:false];
        }else{
            if (_panMovingRightOrLeft && _currentView.frame.origin.x>20) {
                [self showLeftViewController:true];
            }else if(!_panMovingRightOrLeft && _currentView.frame.origin.x<-20){
                [self showRightViewController:true];
            }else{
                [self hideSideViewController];
            }
        }
        _lastPanPoint = CGPointZero;
    }else{
        CGPoint velocity = [pan velocityInView:_baseView];
        if (velocity.x>0) {
            _panMovingRightOrLeft = true;
        }else if(velocity.x<0){
            _panMovingRightOrLeft = false;
        }
    }
}

//重写此方法可以改变动画效果,PS._currentView就是RootViewController.view
- (void)layoutCurrentViewWithOffset:(CGFloat)xoffset{
    if (_showBoundsShadow) {
        _currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
    if (self.rootViewMoveBlock) {//如果有自定义动画，使用自定义的效果
        self.rootViewMoveBlock(_currentView,_baseView.bounds,xoffset);
        return;
    }
    /*平移的动画
     [_currentView setFrame:CGRectMake(xoffset, _baseView.bounds.origin.y, _baseView.frame.size.width, _baseView.frame.size.height)];
     return;
     //*/
    
    //    /*平移带缩放效果的动画
    static CGFloat h2w = 0;
    if (h2w==0) {
        h2w = _baseView.frame.size.height/_baseView.frame.size.width;
    }
    CGFloat scale = ABS(600 - ABS(xoffset)) / 600;
    scale = MAX(0.8, scale);
    _currentView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat totalWidth=_baseView.frame.size.width;
    CGFloat totalHeight=_baseView.frame.size.height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        totalHeight=_baseView.frame.size.width;
        totalWidth=_baseView.frame.size.height;
    }
    
    if (xoffset>0) {//向右滑的
        [_currentView setFrame:CGRectMake(xoffset-150, _baseView.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale)];
    }else{//向左滑的
//        [_currentView setFrame:CGRectMake(_baseView.frame.size.width * (1 - scale) + xoffset, _baseView.bounds.origin.y + (totalHeight*(1 - scale) / 2), totalWidth * scale, totalHeight * scale)];
        [_currentView setFrame:CGRectMake(_baseView.frame.size.width * (1 - scale) + xoffset, 0, totalWidth * scale, SCREEN_HEIGHT)];

    }
    //*/
}

//下面2个方法让状态栏显示黑低白字
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
