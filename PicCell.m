//
//  PicCell.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PicCell.h"
#import "UIImageView+WebCache.h"

@implementation PicCell
@synthesize imageView = _imageView;

- (void)awakeFromNib {
    // Initialization code
}

-(void)showCellWithModel:(PicModel *)model{
    NSURL *url = [NSURL URLWithString:model.picsArr[0]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    UIImage *image = [UIImage imageWithData:data];
   // self.imageView.frame.size.height = self.imageView.frame.size.width/image.size.height*image.size.height;
    
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    self.picCountLabel.text = [NSString stringWithFormat:@"%ld",model.picsArr.count-1];
    self.titleLabel.text = model.title;
    
}
@end
