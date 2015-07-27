//
//  MyModel.h
//  FinanceNews
//
//  Created by qianfeng on 15-6-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *abstract;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *newsId;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
