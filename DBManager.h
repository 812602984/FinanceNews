//
//  DBManager.h
//  FinanceNews
//
//  Created by qianfeng on 15/6/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(DBManager *)sharedManager;

-(void)insertModel:(id)model;

-(NSArray *)readModelsWithTitle:(NSString *)title;

-(BOOL)isExistForTitle:(NSString *)title;

//-(NSInteger)getCountsFromText:(NSString *)text;

-(void)deleteByTitle:(NSString *)title;

@end
