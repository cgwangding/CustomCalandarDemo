//
//  BaseCalandarView.h
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateModel.h"

@interface BaseCalandarView : UIView

@property (strong, nonatomic, readonly) NSMutableArray<DateModel*>*dateArr;

@property (strong, nonatomic) NSDateComponents *currentComponents;

/**
 *  是否将周末计算入有效期，默认YES。
 */
@property (assign, nonatomic,readonly) BOOL isWeekdayValid;

- (void)validDateFormDateComponents:(NSDateComponents*)startDateComp toDateComponents:(NSDateComponents*)endDateComp andWeekdayValid:(BOOL)valid;

- (void)nextMonth;
- (void)previewMonth;

@end
