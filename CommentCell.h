//
//  CommentCell.h
//  FinanceNews
//
//  Created by qianfeng001 on 15-7-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell

-(void)showDataWithModel:(CommentModel *)model;

@end
