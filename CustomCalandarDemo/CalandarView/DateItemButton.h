//
//  DateItemButton.h
//  CustomCalandarDemo
//
//  Created by AD-iOS on 15/10/21.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  针对多利农庄项目添加
 */
typedef NS_ENUM(NSUInteger, DateItemSelectType){
    /**
     *  日期为当天时的选中的状态
     */
    DateItemSelectTypeToday,
    /**
     *  日期选中时的状态
     */
    DateItemSelectTypeChoose,
    /**
     *  日期为计划日期的时候的状态
     */
    DateItemSelectTypePlan,
};

@interface DateItemButton : UIButton

@property (assign, nonatomic) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger weekday;

- (void)configDateItemSelectType:(DateItemSelectType)type;

- (NSString*)getDateStr;

@end
