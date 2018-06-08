//
//  Define.h
//  FinanceNews
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#ifndef FinanceNews_Define_h
#define FinanceNews_Define_h

#define kScreenSize [UIScreen mainScreen].bounds.size

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kRGB(r, g , b)     [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1];

#define kStatusBarH (KIsiPhoneX ? 44 : 20)


//图片url
#define kPicUrl @"http://wapi.hexun.com/Api_picList.cc?pid=%@&pn=%ld&pc=20"
//视频url
#define kVideoUrl @"http://wapi.hexun.com/Api_videoList.cc?pid=%@&pn=%ld&pc=20"
//视频详情url
#define kVideoDetailUrl @"http://wapi.hexun.com/Api_videoDetail.cc?newsId=%@"

//搜索url
#define kSearchUrl @"http://wiapi.hexun.com/news/search.php?pid=&kw=%@&pc=20&pn=1"
#define kWillPlay @"kWillPlay"

//评论url
#define kCommentUrl @"http://comment.tool.hexun.com/Comment/GetCommentNext.do?articleid=%@&pagesize=10&maxcommentid=&commentsource=2&articlesource=1"

#import "MMProgressHUD.h"

#endif
