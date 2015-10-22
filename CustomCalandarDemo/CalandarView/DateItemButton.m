//
//  DateItemButton.m
//  CustomCalandarDemo
//
//  Created by AD-iOS on 15/10/21.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "DateItemButton.h"
#import "UIImage+Extension.h"

@interface DateItemButton ()

@property (assign, nonatomic) DateItemSelectType type;

@end

@implementation DateItemButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configDateItemSelectType:(DateItemSelectType)type
{
    self.type = type;
    switch (type) {
        case DateItemSelectTypeToday:
        {
            [self setTitleColor:[UIColor colorWithRed:252/255.0 green:180/255.0 blue:72/255.0 alpha:1.0] forState:UIControlStateNormal];
            //需要设置图片
            [self setImage:[UIImage imageWithColor:[UIColor colorWithRed:252/255.0 green:180/255.0 blue:72/255.0 alpha:1.0] size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
        }
            break;
        case DateItemSelectTypePlan:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:129/255.0 green:174/255.0 blue:52/255.0 alpha:1.0] size:CGSizeMake(35, 35)] forState:UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeZero] forState:UIControlStateNormal];
            
            [self setImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(12, 12)] forState:UIControlStateSelected];
            
        }
            break;
        case DateItemSelectTypeChoose:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:129/255.0 green:174/255.0 blue:52/255.0 alpha:1.0] size:CGSizeMake(35, 35)] forState:UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeZero] forState:UIControlStateNormal];
            
            [self setImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(0.1, 0.1)] forState:UIControlStateSelected];
        }
            break;
            
        default:
            break;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(0, 6, CGRectGetWidth(self.frame), 12);
    self.imageView.frame = CGRectMake(self.titleLabel.center.x - CGRectGetWidth(self.imageView.frame) / 2, CGRectGetMaxY(self.titleLabel.frame) + 2, CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
    if (self.type == DateItemSelectTypeChoose) {
        self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.imageView.frame = CGRectMake(self.titleLabel.center.x - CGRectGetWidth(self.imageView.frame) / 2, CGRectGetHeight(self.frame) - 5, CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
    }
    self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.frame) / 2.0;
    self.imageView.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0;
    self.layer.masksToBounds = YES;
}

@end
