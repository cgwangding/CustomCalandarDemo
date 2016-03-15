//
//  DateModel.h
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
//1-周日 ，2-周一，3-周二，4-周三，5-周四，6-周五，7-周六
@property (assign, nonatomic) NSInteger weekday;

/**
 *  是否是当月
 */
@property (assign, nonatomic) BOOL isCurrentMonth;

/**
 *  是否是今天
 */
@property (assign, nonatomic) BOOL isToday;

/**
 *  用于标记该天是否在设置的有效时间内，默认为NO。
 */
@property (assign, nonatomic) BOOL isBetweenValidDate;

- (void)configModelWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day weekday:(NSInteger)weekday;

- (NSString*)dateStr;


@end
