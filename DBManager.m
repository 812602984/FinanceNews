
//
//  DBManager.m
//  FinanceNews
//
//  Created by qianfeng on 15/6/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "MyModel.h"

@implementation DBManager
{
    FMDatabase *_database;
}

+(DBManager *)sharedManager{
    static DBManager *manager = nil;
    @synchronized(self){
        if(manager == nil){
            manager = [[self alloc] init];
        }
    }
    return manager;
}

-(id)init{
    if (self = [super init]) {
        NSString *filePath = [self getFileFullPathWithFileName:@"finance.db"];
        _database = [[FMDatabase alloc] initWithPath:filePath];
        
        if ([_database open]) {
            NSLog(@"数据库打开成功");
            [self creatTable];
        }
    }
    return self;
}

-(void)creatTable{
    NSString *sql = @"create table if not exists news(serial integer Primary Key Autoincrement, newsId Varchar(200),title Varchar(1024),time Varchar(100),imgUrl Varchar(1024))";
    BOOL isSuccess = [_database executeUpdate:sql];
    if (!isSuccess) {
        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
    }
}

-(NSString *)getFileFullPathWithFileName:(NSString *)fileName{
    NSString *docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSLog(@"1111:%@",docPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        return [docPath stringByAppendingFormat:@"/%@",fileName];
    }else{
        return nil;
    }
}

-(void)insertModel:(id)myModel{
    MyModel *model = (MyModel *)myModel;
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [df stringFromDate:date];
    
    if ([self isExistForTitle:model.title]) {
        return;
    }
    NSString *sql = @"insert into news(newsId,title,time,imgUrl) values(?,?,?,?)";
    BOOL isSuccess = [_database executeUpdate:sql,model.newsId,model.title,timeStr,model.imgUrl];
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}

-(BOOL)isExistForTitle:(NSString *)title{
    NSString *sql = @"select * from news where title = ?";
    FMResultSet *rs = [_database executeQuery:sql,title];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }
}

//返回数据库表中的记录数
-(NSInteger)getCountsFromTable:(NSString *)tableName{
    NSString *sql = @"select count(*) from ?";
    FMResultSet *rs = [_database executeQuery:sql,tableName];
    NSInteger count = [rs next];
    return count;
}

-(NSArray *)readModelsWithTitle:(NSString *)title{
    NSString *sql = @"select * from news";
   // NSString *sql = [NSString stringWithFormat:@"select * from news %@",str];
    
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next]) {
        MyModel *model = [[MyModel alloc] init];
        model.title = [rs stringForColumn:@"title"];
        model.abstract = [rs stringForColumn:@"time"];
        model.imgUrl = [rs stringForColumn:@"imgUrl"];
        model.newsId = [rs stringForColumn:@"newsId"];
        
        [arr addObject:model];
    }
    return arr;
}

-(void)deleteByTitle:(NSString *)newsTitle{
    NSString *sql = @"delete from news where title = ?";
    BOOL isSuccess = [_database executeUpdate:sql,newsTitle];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}


@end
