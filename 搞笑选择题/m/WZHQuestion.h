//
//  WZHQuestion.h
//  搞笑选择题
//
//  Created by 三哥哥 on 2019/4/11.
//  Copyright © 2019年 三哥哥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZHQuestion : NSObject
@property (nonatomic,strong) NSString *answer,*icon,*title;
@property (nonatomic,strong) NSArray *options;

-(instancetype)initwithdict:(NSDictionary *)dict;
+(instancetype)questionwithdict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
