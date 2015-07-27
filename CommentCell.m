//
//  CommentCell.m
//  FinanceNews
//
//  Created by qianfeng001 on 15-7-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "LZXHelper.h"

@interface CommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *userameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *posttimeLabel;

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showDataWithModel:(CommentModel *)model{
    [self.logo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"default"]];
    self.userameLabel.text = model.username;
    self.commentLabel.text = model.content;
    
    //时间转换
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *timeStr = [numberFormatter stringFromNumber:model.posttime];
    double t = [timeStr doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd日 HH:mm";
    
    self.posttimeLabel.text = [df stringFromDate:date];
}

@end
