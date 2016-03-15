//
//  CustomCalendarView.m
//  CustomCalandarDemo
//
//  Created by AD-iOS on 15/10/21.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "CustomCalendarView.h"
#import "DateItemButton.h"
#import "UIView+Extension.h"

#define RGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//日历顶部显示当前年份月份的view的高度
static CGFloat headerHeight = 35;

@interface CustomCalendarView ()
@property (strong, nonatomic) NSDateComponents *dateComponets;

@property (strong, nonatomic) NSDateComponents *currentComponents;
@property (assign, nonatomic) NSCalendarUnit calendarUnit;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *dateTitleLabel;

@property (strong, nonatomic) NSMutableArray *dateItemsArr;

@property (strong, nonatomic) NSArray *weekdayNamesArr;

@property (strong, nonatomic) DateItemButton *preSelectedItem;

@property (assign, nonatomic) CustomCalendarViewType type;

@property (copy, nonatomic) NSDateComponents *canChooseStartComponents;
@property (copy, nonatomic) NSDateComponents *canChooseEdnComponents;

@end

@implementation CustomCalendarView

- (instancetype)initWithFrame:(CGRect)frame type:(CustomCalendarViewType)type
{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self addSubview:self.headerView];
        self.currentComponents = self.dateComponets;
        [self buildWeekdayNames];
        [self updateDateTitle:self.dateComponets];
        //生成该月的时间item
        [self makeAndCalculateMonthDaysViewWithDateComponents:self.dateComponets];
        //重新布局
        [self rebuildDateItemAndAdd];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headerView];
        self.currentComponents = self.dateComponets;
        [self buildWeekdayNames];
        [self updateDateTitle:self.dateComponets];
        //生成该月的时间item
        [self makeAndCalculateMonthDaysViewWithDateComponents:self.dateComponets];
        //重新布局
        [self rebuildDateItemAndAdd];
    }
    return self;
}


#pragma mark - helper

//更新当前的年份以及月份
- (void)updateDateTitle:(NSDateComponents*)components
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月";
    
    NSDate *date = [components.calendar dateFromComponents:components];
    self.dateTitleLabel.text = [formatter stringFromDate:date];
}

//创建 日 、一、二、三、四、五、六  标签
- (void)buildWeekdayNames
{
    CGFloat width = self.bounds.size.width / self.weekdayNamesArr.count;
    for (NSString *name in self.weekdayNamesArr) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width * [self.weekdayNamesArr indexOfObject:name], CGRectGetMaxY(self.headerView.frame), width, 30)];
        label.font  = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = name;
        label.backgroundColor = RGBColor(248, 248, 248, 1.0);
        [self addSubview:label];
    }
    
}

- (void)makeAndCalculateMonthDaysViewWithDateComponents:(NSDateComponents*)components
{
    [self.dateItemsArr removeAllObjects];
    
    //计算当月第一天是周几
    NSDateComponents *firstDayComponents = [components copy];
    
    //计算当月有多少天
    NSInteger daysOfMonth = [firstDayComponents.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayComponents.date].length;
    
    firstDayComponents.day = 1;
    //1-周日 ，2-周一，3-周二，4-周三，5-周四，6-周五，7-周六
    NSInteger firstDayOfWeekday = [firstDayComponents.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayComponents.date];
    
    //计算最后一天是周几
    firstDayComponents.day = daysOfMonth;
    
    NSInteger lastDayOfWeekday = [firstDayComponents.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayComponents.date];
    
    //生成当月的时间item
    NSInteger preWeekday = firstDayOfWeekday;
    for (int i = 1; i <= daysOfMonth; i++) {
        NSInteger weekday = 1;
        //计算该天是周几
        if (i == 1) {
            weekday = firstDayOfWeekday;
        }else{
            preWeekday++;
            if (preWeekday > 7) {
                weekday = preWeekday - 7;
                preWeekday = weekday;
            }
        }
        DateItemButton *item = [self makeDateItemWithYear:firstDayComponents.year month:firstDayComponents.month day:i weekday:weekday];
        /*
         //在今天之前的都设置为灰色
         if (firstDayComponents.month == self.dateComponets.month) {
         if (i < components.day) {
         [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
         item.userInteractionEnabled = NO;
         }else {
         if (i == self.dateComponets.day){
         //是今天
         [item configDateItemSelectType:DateItemSelectTypeToday];
         }else{
         [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         }
         
         }
         }else{
         [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         }
         */
        //
        if (self.type == CustomCalendarViewTypeDefault) {
            
        }else{
            //预览
            [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
            item.userInteractionEnabled = NO;
            if (firstDayComponents.month == self.dateComponets.month) {
                if (i == components.day) {
                    //是今天
                    [item configDateItemSelectType:DateItemSelectTypeToday];
                }
            }
            
            NSDateComponents *tempComponents = [components copy];
            [tempComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
            tempComponents.day = i;
            NSDate *date = [tempComponents.date copy];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter stringFromDate:date];
            if ([self.planDatesArr containsObject:dateStr]) {
                [item configDateItemSelectType:DateItemSelectTypePlan];
            }
            
        }
        
        
        [item configDateItemSelectType:DateItemSelectTypeChoose];
        [item addTarget:self action:@selector(dateItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.dateItemsArr addObject:item];
    }
    
    
    //生成上月的时间item
    if(firstDayOfWeekday != 1){
        //只有当第一天不是周日时才生成上个月的
        //计算上月的总天数
        firstDayComponents.month = components.month - 1;
        if (firstDayComponents.month < 1) {
            //月份置一，年份减一
            firstDayComponents.month = 12;
            firstDayComponents.year = components.year - 1;
        }
        firstDayComponents.day = 1;
        //计算当月有多少天
        NSInteger preDaysOfMonth = [firstDayComponents.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayComponents.date].length;
        
        for (int i = (int)(firstDayOfWeekday - 1); i > 0; i--) {
            DateItemButton *item = [self makeDateItemWithYear:firstDayComponents.year month:firstDayComponents.month day:preDaysOfMonth weekday:i];
            [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
            item.userInteractionEnabled = NO;
            [item configDateItemSelectType:DateItemSelectTypeChoose];
            [self.dateItemsArr insertObject:item atIndex:0];
            if (self.type == CustomCalendarViewTypePreviewPlan) {
                NSDateComponents *tempComponents = [components copy];
                [tempComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
                tempComponents.day = i;
                NSDate *date = [tempComponents.date copy];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr = [formatter stringFromDate:date];
                if ([self.planDatesArr containsObject:dateStr]) {
                    [item configDateItemSelectType:DateItemSelectTypePlan];
                }
                
            }
            preDaysOfMonth--;
        }
    }
    
    
    //生成下月的时间item
    if (lastDayOfWeekday != 7) {
        //只有当最后一天不是周六时才生成下个月的
        firstDayComponents.year = components.year;
        firstDayComponents.month = components.month + 1;
        if (firstDayComponents.month > 12) {
            //月份置一，年份加一
            firstDayComponents.month = 1;
            firstDayComponents.year = components.year + 1;
        }
        NSInteger day = 1;
        for (int i = (int)(lastDayOfWeekday + 1); i <= 7; i++) {
            DateItemButton *item = [self makeDateItemWithYear:firstDayComponents.year month:firstDayComponents.month day:day weekday:i];
            [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
            item.userInteractionEnabled = NO;
            [self.dateItemsArr addObject:item];
            if (self.type == CustomCalendarViewTypePreviewPlan) {
                NSDateComponents *tempComponents = [components copy];
                [tempComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
                tempComponents.day = i;
                NSDate *date = [tempComponents.date copy];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr = [formatter stringFromDate:date];
                if ([self.planDatesArr containsObject:dateStr]) {
                    [item configDateItemSelectType:DateItemSelectTypePlan];
                }
            }
            day++;
        }
    }
    
    [self configDateItemWithStartComponents:self.canChooseStartComponents endComponents:self.canChooseEdnComponents];
    
    
}

- (DateItemButton*)makeDateItemWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day weekday:(NSInteger)weekday
{
    DateItemButton *dateItem = [DateItemButton buttonWithType:UIButtonTypeCustom];
    [dateItem setTitle:[NSString stringWithFormat:@"%lu",day] forState:UIControlStateNormal];
    dateItem.year = year;
    dateItem.month = month;
    dateItem.day = day;
    dateItem.weekday = weekday;
    return dateItem;
}

//设置每个item的frame并且添加到self上
- (void)rebuildDateItemAndAdd
{
    CGFloat itemWidth = 35 * self.bounds.size.width / 320.0;
    CGFloat lineSpace = 8;
    CGFloat centerX = (self.bounds.size.width / 7.0) / 2.0;
    
    NSInteger lines = self.dateItemsArr.count / 7;
    if (self.dateItemsArr.count % 7 > 0) {
        lines++;
    }
    //开始计算
    for (int i  = 0;i < lines ; i++) {
        for (int j = 0; j < 7; j++) {
            DateItemButton *item = self.dateItemsArr[i * 7 + j];
            [item setFrame:CGRectMake(centerX * (j * 2 + 1) - itemWidth / 2.0, self.headerView.frame.size.height + 30 + lineSpace * (i + 1) + itemWidth * i, itemWidth, itemWidth)];
            if (self.type == CustomCalendarViewTypePreviewPlan) {
                [item configDateItemSelectType:DateItemSelectTypePlan];
                //当为预览配送计划时，所有的都不可点
                item.userInteractionEnabled = NO;
            }else{
                [item configDateItemSelectType:DateItemSelectTypeChoose];
            }
            
            [self addSubview:item];
        }
    }
    //重新计算self的高度
    CGRect frame = self.frame;
    frame.size.height = ((DateItemButton*)[self.dateItemsArr lastObject]).maxY + 10;
    self.frame = frame;
    
}

- (void)configPlanedItem
{
    if (self.type == CustomCalendarViewTypePreviewPlan) {
        for (DateItemButton *item in self.dateItemsArr) {
            NSString *dateStr = [item getDateStr];
            if ([self.planDatesArr containsObject:dateStr]) {
                [item configDateItemSelectType:DateItemSelectTypePlan];
            }else{
                [item configDateItemSelectType:DateItemSelectTypeNone];
            }
        }
    }
}

- (void)configDateItemWithStartComponents:(NSDateComponents *)startComponents endComponents:(NSDateComponents *)endComponents
{
    self.canChooseStartComponents = startComponents;
    self.canChooseEdnComponents = endComponents;
    if (self.type == CustomCalendarViewTypeDefault && startComponents && endComponents) {
        
        for (DateItemButton *item in self.dateItemsArr) {
            //不是今年当月
            if (item.year == self.currentComponents.year && item.month == self.currentComponents.month) {
                if (item.year >= startComponents.year && item.month <= endComponents.year) {
                    //当月是否有时间在时间范围之内
                    //需要点亮的都是在本月的时间，如果不是本月的，即使在时间范围内，仍是灰色的
                    //有两种情况1、结束时间和开始时间在同一月2、结束时间和开始时间不在同一月、
                    if (startComponents.month == endComponents.month && startComponents.month == item.month) {
                        if (item.day >= startComponents.day && item.day <= endComponents.day) {
                            //在可选的天的范围内，可点
                            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            item.userInteractionEnabled = YES;
                        }else{
                            //不是在可选的天的范围内，都不可点
                            [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
                            item.userInteractionEnabled = NO;
                        }
                    }else if ((startComponents.month < endComponents.month || startComponents.year < endComponents.year) && (item.month == startComponents.month || item.month == endComponents.month)){
                        if (item.month == startComponents.month) {
                            if (item.day >= startComponents.day) {
                                //在可选的天的范围内，可点
                                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                item.userInteractionEnabled = YES;
                            }else{
                                //不是在可选的天的范围内，都不可点
                                [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
                                item.userInteractionEnabled = NO;
                            }
                        }else if (item.month == endComponents.month){
                            if (item.day <= endComponents.day) {
                                //在可选的天的范围内，可点
                                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                item.userInteractionEnabled = YES;
                            }else{
                                //不是在可选的天的范围内，都不可点
                                [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
                                item.userInteractionEnabled = NO;
                            }
                        }
                    }else{
                        //不是在可选的天的范围内，都不可点
                        [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
                        item.userInteractionEnabled = NO;
                    }
                }else{
                    //不是在可选的年的范围内，都不可点
                    [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
                    item.userInteractionEnabled = NO;
                }
                
                
            }else{
                //不是当月的都不可点
                [item setTitleColor:RGBColor(190, 190, 190, 1.0) forState:UIControlStateNormal];
                item.userInteractionEnabled = NO;
            }
            
            if (item.year == self.dateComponets.year && item.month == self.dateComponets.month && item.day == self.dateComponets.day) {
                //今天
                [item configDateItemSelectType:DateItemSelectTypeChoose];
                [item configDateItemSelectType:DateItemSelectTypeToday];
            }
        }
        
    }
    
    
}

#pragma mark - button action
//上一月
- (void)previewMonthButtonClicked:(UIButton*)button
{
    NSDateComponents *preDateComponents = [self.currentComponents copy];
    preDateComponents.month = self.currentComponents.month - 1 < 1?12:self.currentComponents.month - 1;
    preDateComponents.year = self.currentComponents.month - 1 < 1?self.currentComponents.year - 1:self.currentComponents.year;
    preDateComponents.day = 1;
    self.currentComponents = preDateComponents;
    for (DateItemButton *item in self.dateItemsArr) {
        [item removeFromSuperview];
    }
    [self makeAndCalculateMonthDaysViewWithDateComponents:preDateComponents];
    [self rebuildDateItemAndAdd];
    
    [self updateDateTitle:preDateComponents];
    [self configPlanedItem];
    self.preSelectedItem = nil;
}

//下一月
- (void)nextMonthButtonClicked:(UIButton*)button
{
    NSDateComponents *nexDateComponents = [self.currentComponents copy];
    nexDateComponents.month = self.currentComponents.month + 1 > 12?1:self.currentComponents.month + 1;
    nexDateComponents.year = self.currentComponents.month + 1 > 12?self.currentComponents.year + 1:self.currentComponents.year;
    nexDateComponents.day = 1;
    self.currentComponents = nexDateComponents;
    for (DateItemButton *item in self.dateItemsArr) {
        [item removeFromSuperview];
    }
    [self makeAndCalculateMonthDaysViewWithDateComponents:nexDateComponents];
    [self rebuildDateItemAndAdd];
    
    [self updateDateTitle:nexDateComponents];
    [self configPlanedItem];
    
    self.preSelectedItem = nil;
}


- (void)dateItemButtonClicked:(DateItemButton*)item
{
    item.selected = !item.selected;
    if (self.preSelectedItem == nil) {
        self.preSelectedItem = item;
    }else if(self.preSelectedItem != item){
        self.preSelectedItem.selected = NO;
        self.preSelectedItem = item;
    }
    if ([self.delegate respondsToSelector:@selector(customCalendarView:didSelectedDate:)]) {
        [self.delegate customCalendarView:self didSelectedDate:[item getDateStr]];
    }
}

#pragma mark - setter

- (void)setPlanDatesArr:(NSArray *)planDatesArr
{
    _planDatesArr = [planDatesArr copy];
    [self configPlanedItem];
}

#pragma mark - getter

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

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), headerHeight)];
        _headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        //添加日期显示的标签
        [_headerView addSubview:self.dateTitleLabel];
        [self.dateTitleLabel setFrame:CGRectMake(CGRectGetWidth(_headerView.frame) / 2.0 - 75, 0, 75 * 2, CGRectGetHeight(_headerView.frame))];
        
        //添加切换的按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(10, 0, 35, CGRectGetHeight(_headerView.frame))];
        [leftButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(previewMonthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:leftButton];
        
        //添加切换的按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(CGRectGetWidth(_headerView.frame) - 10 - 35, 0, 35, CGRectGetHeight(_headerView.frame))];
        [rightButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(nextMonthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:rightButton];
    }
    return _headerView;
}

- (UILabel *)dateTitleLabel
{
    if (_dateTitleLabel == nil) {
        _dateTitleLabel = [[UILabel alloc]init];
        _dateTitleLabel.textAlignment = NSTextAlignmentCenter;
        _dateTitleLabel.textColor = [UIColor colorWithRed:129/255.0 green:174/255.0 blue:52/255.0 alpha:1.0];
        _dateTitleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateTitleLabel;
}

- (NSMutableArray *)dateItemsArr
{
    if (_dateItemsArr == nil) {
        _dateItemsArr = [NSMutableArray array];
    }
    return _dateItemsArr;
}

- (NSArray *)weekdayNamesArr
{
    if (_weekdayNamesArr == nil) {
        _weekdayNamesArr = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _weekdayNamesArr;
}

@end
