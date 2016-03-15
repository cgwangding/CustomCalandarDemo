//
//  BaseItem.h
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateModel.h"

typedef NS_ENUM(NSUInteger, BaseItemType) {
    BaseItemTypeNone,
    BaseItemTypeNotCurrentMonth,
    BaseItemTypeInvalid,
    BaseItemTypeSelect,
};

@interface BaseItem : UIButton

@property (strong, nonatomic) DateModel *model;

@property (assign, nonatomic) BaseItemType itemType;

- (BOOL)isEqualToItem:(BaseItem*)item;

@end
