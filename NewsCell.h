//
//  NewsCell.h
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

@interface NewsCell : UITableViewCell

//填充cell
-(void)showDataWithModel:(MyModel *)model;

@end
