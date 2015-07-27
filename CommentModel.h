//
//  CommentModel.h
//  FinanceNews
//
//  Created by qianfeng001 on 15-7-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *username;
@property (nonatomic) NSNumber *userid;
@property (nonatomic) NSNumber *parentid;
@property (nonatomic) NSNumber *parentuserid;
@property (nonatomic,copy) NSString *postip;
@property (nonatomic,copy) NSString *poststr;
@property (nonatomic) NSNumber *posttime;
@property (nonatomic) NSNumber *praisecount;
@property (nonatomic,copy) NSString *parentusername;
@property (nonatomic,copy) NSString *logo;
@property (nonatomic) NSNumber *ispraise;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
