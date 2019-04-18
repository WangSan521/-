//
//  WZHQuestion.m
//  搞笑选择题
//
//  Created by 三哥哥 on 2019/4/11.
//  Copyright © 2019年 三哥哥. All rights reserved.
//

#import "WZHQuestion.h"

@implementation WZHQuestion
-(instancetype)initwithdict:(NSDictionary *)dict{
    if(self == [super init]){
        self.answer =dict[@"answer"];
        self.title =dict[@"title"];
        self.icon =dict[@"icon"];
        self.options=dict[@"options"];
    }
    return self;
}
+(instancetype)questionwithdict:(NSDictionary *)dict{
    return [[self alloc]initwithdict:dict];
}
@end
