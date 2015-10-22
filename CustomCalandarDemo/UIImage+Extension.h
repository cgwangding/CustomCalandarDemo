//
//  UIImage+Extension.h
//  PaiPaiDai
//
//  Created by c on 14-12-5.
//  Copyright (c) 2014年 adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)resizableImage:(NSString *)name;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
/*调整button的image的位置**/
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;

@end
