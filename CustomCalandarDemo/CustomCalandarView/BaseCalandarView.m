//
//  BaseCalandarView.m
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "BaseCalandarView.h"

@interface BaseCalandarView ()

@property (strong, nonatomic) NSDateComponents *dateComponets;


@property (assign, nonatomic) NSCalendarUnit calendarUnit;

@property (copy, nonatomic) NSDateComponents *fromComponents;
@property (copy, nonatomic) NSDateComponents *toComponents;

@end

@implementation BaseCalandarView
@synthesize dateArr = _dateArr;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.currentComponents = self.dateComponets;
        self.isWeekdayValid = YES;
         [self setupDateModel];
    }
    return self;
}

- (void)setupDateModel
{
    //时间按照1-周日 ，2-周一，3-周二，4-周三，5-周四，6-周五，7-周六排布
    
    //计算当月第一天是周几
    NSDateComponents *currentDateCompnents = [self.currentComponents copy];
    
    //计算当月有多少天
    NSInteger currentMonthDays = [currentDateCompnents.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDateCompnents.date].length;
    
    currentDateCompnents.day = 1;
    
    //1-周日 ，2-周一，3-周二，4-周三，5-周四，6-周五，7-周六
    NSInteger firstDayOfWeekday = [currentDateCompnents.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:currentDateCompnents.date];
    
    //计算最后一天是周几
    currentDateCompnents.day = currentMonthDays;
    
    NSInteger lastDayOfWeekday = [currentDateCompnents.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:currentDateCompnents.date];
    
    
    //生成当月的时间
    NSInteger preWeekday = firstDayOfWeekday;
    for (int i = 1 ; i <= currentMonthDays; i++) {
        NSInteger weekday = 1;
        //计算该天是周几
        if (i == 1) {
            weekday = firstDayOfWeekday;
        }else{
            preWeekday++;
            weekday = preWeekday;
            if (preWeekday > 7) {
                weekday = preWeekday - 7;
                preWeekday = weekday;
            }
        }
        DateModel *model = [[DateModel alloc]init];
        [model configModelWithYear:currentDateCompnents.year month:currentDateCompnents.month day:i weekday:weekday];
        if (i == self.dateComponets.day && currentDateCompnents.year == self.dateComponets.year && currentDateCompnents.month == self.dateComponets.month) {
            //是今天
            model.isToday = YES;
        }
        model.isCurrentMonth = YES;
        [self.dateArr addObject:model];
    }
    
    //生成上月的时间
    if (firstDayOfWeekday != 1) {
        //只有当第一天不是周日时才生成上个月的时间
        //计算上月的总天数
        currentDateCompnents.month = self.currentComponents.month - 1;
        if (currentDateCompnents.month < 1) {
            //已经到到达了去年
            currentDateCompnents.month = 12;
            currentDateCompnents.year = self.currentComponents.year - 1;
        }
        currentDateCompnents.day = 1;
        //计算当月有多少天
        NSInteger preDaysOfMonth = [currentDateCompnents.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDateCompnents.date].length;
        for (int i = (int)(firstDayOfWeekday - 1); i > 0; i--) {
            DateModel *model = [[DateModel alloc]init];
            [model configModelWithYear:currentDateCompnents.year month:currentDateCompnents.month day:preDaysOfMonth weekday:i];
            model.isCurrentMonth = NO;
            [self.dateArr insertObject:model atIndex:0];
            preDaysOfMonth--;
        }
    }
    
    //生成下月的时间
    if (lastDayOfWeekday != 7) {
        //只有当最后一天不是周六时才生成下个月的
        currentDateCompnents.year = self.currentComponents.year;
        currentDateCompnents.month = self.currentComponents.month + 1;
        if (currentDateCompnents.month > 12) {
            //月份置一，年份加一
            currentDateCompnents.month = 1;
            currentDateCompnents.year = self.currentComponents.year + 1;
        }
        NSInteger day = 1;
        for (int i = (int)(lastDayOfWeekday + 1); i <= 7; i++) {
            DateModel *model = [[DateModel alloc]init];
            [model configModelWithYear:currentDateCompnents.year month:currentDateCompnents.month day:day weekday:i];
            model.isCurrentMonth = NO;
            [self.dateArr addObject:model];
            day++;
        }
    }
    [self validDateFormDateComponents:self.fromComponents toDateComponents:self.toComponents andWeekdayValid:self.isWeekdayValid];
}

- (void)previewMonth
{
    NSDateComponents *preDateComponents = [self.currentComponents copy];
    preDateComponents.month = self.currentComponents.month - 1 < 1?12:self.currentComponents.month - 1;
    preDateComponents.year = self.currentComponents.month - 1 < 1?self.currentComponents.year - 1:self.currentComponents.year;
    preDateComponents.day = 1;
    self.currentComponents = preDateComponents;
    
    [self.dateArr removeAllObjects];
    [self setupDateModel];
    
}

- (void)nextMonth
{
    NSDateComponents *nexDateComponents = [self.currentComponents copy];
    nexDateComponents.month = self.currentComponents.month + 1 > 12?1:self.currentComponents.month + 1;
    nexDateComponents.year = self.currentComponents.month + 1 > 12?self.currentComponents.year + 1:self.currentComponents.year;
    nexDateComponents.day = 1;
    self.currentComponents = nexDateComponents;
    
    [self.dateArr removeAllObjects];
    [self setupDateModel];
}

- (void)validDateFormDateComponents:(NSDateComponents *)startDateComp toDateComponents:(NSDateComponents *)endDateComp andWeekdayValid:(BOOL)valid
{
    self.fromComponents = startDateComp;
    self.toComponents = endDateComp;
    self.isWeekdayValid = valid;
    if (self.fromComponents == nil || self.toComponents == nil) {
        return;
    }
    if (startDateComp.year > endDateComp.year) {
        NSAssert2(NO, @"起始时间%@不能大于结束时间%@", startDateComp, endDateComp);
        return;
    }
    if (startDateComp.year == endDateComp.year && startDateComp.month > endDateComp.month) {
        NSAssert2(NO, @"起始时间%@不能大于结束时间%@", startDateComp, endDateComp);
        return;
    }
    
    for (DateModel *model in self.dateArr) {
        //计算是否在有效的时间内
        if (startDateComp.year < endDateComp.year) {
            //当不在一年的时候
            if (model.year > startDateComp.year && model.year < endDateComp.year) {
                //如果在这个年份范围内，不要判断，是可用的日期
                model.isBetweenValidDate = YES;
            }else{
                model.isBetweenValidDate = NO;
            }
            if (model.year == startDateComp.year) {
                
                if (model.month > startDateComp.month) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
                
                if (model.month == startDateComp.month && model.day >= startDateComp.day) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
            }
            if (model.year == endDateComp.year) {
                if (model.month < endDateComp.month) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
                if (model.month == endDateComp.month && model.day <= endDateComp.day) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
            }
            
        }else if (startDateComp.year == endDateComp.year){
            if (model.month < endDateComp.month && model.month > startDateComp.month) {
                model.isBetweenValidDate = YES;
            }else if(model.month == endDateComp.month && model.month == startDateComp.month){
                if (model.day >= startDateComp.day && model.day <= endDateComp.day) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
            }else if (model.month == startDateComp.month){
                if (model.day >= startDateComp.day) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
            }else if (model.month == endDateComp.month){
                if (model.day <= endDateComp.day) {
                    model.isBetweenValidDate = YES;
                }else{
                    model.isBetweenValidDate = NO;
                }
            }else{
                model.isBetweenValidDate = NO;
            }
                
        }else{
            model.isBetweenValidDate = NO;
        }
        
        if (valid == NO) {
            if (model.weekday == 1 || model.weekday == 7) {
                model.isBetweenValidDate = NO;
            }
        }
    }
}

#pragma mark - getter and setter

- (void)setIsWeekdayValid:(BOOL)isWeekdayValid
{
    _isWeekdayValid = isWeekdayValid;
}


- (void)setDateArr:(NSMutableArray<DateModel *> *)dateArr
{
    _dateArr = dateArr;
}

- (NSMutableArray<DateModel *> *)dateArr
{
    if (_dateArr == nil) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

- (NSCalendarUnit)calendarUnit
{
    return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar;
}

- (NSDateComponents *)dateComponets
{
    if (_dateComponets == nil) {
        _dateComponets = [[NSCalendar currentCalendar]components:self.calendarUnit fromDate:[NSDate date]];
        _dateComponets.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    }
    return _dateComponets;
}



@end
