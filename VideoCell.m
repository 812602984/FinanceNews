//
//  VideoCell.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"
#import "VideoDetailViewController.h"
#import "Define.h"

@interface VideoCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,copy)NSString *newsId;

@end

@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)playClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillPlay object:nil userInfo:@{@"newsId":self.newsId}];
}


-(void)showCellWithModel:(MyModel *)model newsId:(NSString *)newsId{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"videobg.png"]];
    self.newsId = newsId;
    self.titleLabel.text = model.title;
}

@end
