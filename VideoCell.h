//
//  VideoCell.h
//  FinanceNews
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

@interface VideoCell : UICollectionViewCell

-(void)showCellWithModel:(MyModel *)model newsId:(NSString *)newsId;

@end
