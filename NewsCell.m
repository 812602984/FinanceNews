//
//  NewsCell.m
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"

@interface NewsCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
}

//填充cell
-(void)showDataWithModel:(MyModel *)model{
    self.titleLabel.text = model.title;
    self.abstractLabel.text = model.abstract;
    
    //使用SDWebImage第三方库
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"default.png"]];
}

@end
