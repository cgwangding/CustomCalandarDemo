//
//  UIView+Extension.h
//  CharmingWoman
//
//  Created by c on 15-1-26.
//  Copyright (c) 2015年 c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGColorRef borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL maskToBounds;

@end
