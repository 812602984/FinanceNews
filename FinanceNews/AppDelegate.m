//
//  AppDelegate.m
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "ContainerViewController.h"
#import "SideViewController.h"
#import "LeftViewController.h"    
#import "RightViewController.h"
#import "AppListViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 
    [UMSocialData setAppKey:@"55923a8767e58e5ab60023ff"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104763488" appKey:@"w8yAXmbrjWcaqVo3" url:@"http://www.umeng.com/social"];
    
    //用数组来存储控制器的名字
    NSArray *vcNames = @[@"HeadlineViewController",@"FinancialViewController",@"DiscussViewController",@"EachgoldViewController",@"AbroadViewController",@"InsureViewController",@"BankViewController"];
    NSArray *titles = @[@"头条",@"理财",@"评论",@"资讯",@"海外",@"保险",@"银行"];
    //数组存储pid
    NSMutableArray *pidArr = [NSMutableArray arrayWithArray:@[@"100234721",@"100228599",@"101002114",@"100012296",@"173398673",@"101710721",@"101710894"]];
    //数组来存储控制器对象
    NSMutableArray *vcArr = [NSMutableArray array];
    for(NSInteger i=0; i<vcNames.count; i++){  //创建视图控制器
        Class vcClass = NSClassFromString(vcNames[i]);
        BaseViewController *vc = [[vcClass alloc] init];
        //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.title = titles[i];
        vc.pid = pidArr[i];
        [vcArr addObject:vc];
    }
    
    ContainerViewController *containerController = [[ContainerViewController alloc] init];
    containerController.viewControllers          = vcArr;
    
    LeftViewController *left = [[LeftViewController alloc] init];     //左侧边栏控制器
    RightViewController *right = [[RightViewController alloc] init];  //右侧边栏控制器
    SideViewController *side = [[SideViewController alloc] init];
    [side setRootViewController:containerController];
    [side setLeftViewController:left];    //设置左侧边栏
    [side setRightViewController:right];  //设置右侧边栏
    left.side = side;

    self.window.rootViewController = side;
        
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

@end
