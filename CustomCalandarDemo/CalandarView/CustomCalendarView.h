//
//  CustomCalendarView.h
//  CustomCalandarDemo
//
//  Created by AD-iOS on 15/10/21.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomCalendarViewType) {
    CustomCalendarViewTypeDefault = 1,
    CustomCalendarViewTypePreviewPlan,
};

@protocol  CustomCalendarViewDelegate;

@interface CustomCalendarView : UIView

@property (weak, nonatomic) id<CustomCalendarViewDelegate>delegate;

@property (copy, nonatomic) NSArray *planDatesArr;



- (instancetype)initWithFrame:(CGRect)frame type:(CustomCalendarViewType)type;

- (void)configDateItemWithStartComponents:(NSDateComponents*)startComponents endComponents:(NSDateComponents*)endComponents;

@end

@protocol  CustomCalendarViewDelegate<NSObject>

@optional

- (void)customCalendarView:(CustomCalendarView*)calendarView didSelectedDate:(NSString*)dateStr;

@end