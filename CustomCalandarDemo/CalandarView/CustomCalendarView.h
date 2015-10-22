//
//  CustomCalendarView.h
//  CustomCalandarDemo
//
//  Created by AD-iOS on 15/10/21.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomCalendarViewType) {
    CustomCalendarViewTypeDefault,
    CustomCalendarViewTypePreviewPlan,
};

@interface CustomCalendarView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(CustomCalendarViewType)type;

@end
