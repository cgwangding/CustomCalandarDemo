//
//  UIView+Extension.m
//  CharmingWoman
//
//  Created by c on 15-1-26.
//  Copyright (c) 2015年 c. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

-(CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}


-(void)setBorderColor:(CGColorRef)borderColor
{
    self.layer.borderColor = borderColor;
    self.layer.borderWidth = 1;
}

-(CGColorRef)borderColor
{
    return self.layer.borderColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    if (self.layer.borderWidth != borderWidth) {
        self.layer.borderWidth = borderWidth;
    }
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}


-(void)setCornerRadius:(CGFloat)cornerRadius
{
    if (self.layer.cornerRadius != cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }
}

-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)setMaskToBounds:(BOOL)maskToBounds
{
    if (self.layer.masksToBounds != maskToBounds) {
        self.layer.masksToBounds = maskToBounds;
    }
}

- (BOOL)maskToBounds
{
    return self.layer.masksToBounds;
}

@end
