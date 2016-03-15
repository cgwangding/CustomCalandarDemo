//
//  DateModel.m
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "DateModel.h"

@implementation DateModel

- (void)configModelWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day weekday:(NSInteger)weekday
{
    self.year = year;
    self.month = month;
    self.day = day;
    self.weekday = weekday;
}

- (NSString *)dateStr
{
    NSString *year = [NSString stringWithFormat:@"%lu",self.year];
    NSString *month = nil;
    NSString *day = nil;
    if (self.month < 10) {
        month = [NSString stringWithFormat:@"0%lu",self.month];
    }else{
        month = [NSString stringWithFormat:@"%lu",self.month];
    }
    
    if (self.day < 10) {
        day = [NSString stringWithFormat:@"0%lu",self.day];
    }else{
        day = [NSString stringWithFormat:@"%lu",self.day];
    }
    
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

- (NSString *)description
{
    return [self dateStr];
}

@end
