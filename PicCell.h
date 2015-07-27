//
//  PicCell.h
//  FinanceNews
//
//  Created by qianfeng on 15/6/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicModel.h"

@interface PicCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *picCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//填充cell
-(void)showCellWithModel:(PicModel *)model;

@end
