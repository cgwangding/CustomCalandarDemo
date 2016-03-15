//
//  CustomCalandarView.h
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "BaseCalandarView.h"
#import "BaseItem.h"

typedef void(^DidSelectedItemBlock)(BaseItem *item);
typedef void(^DidChangedHeightBlock)(CGFloat tHeight);

@interface CustomCalandarView : BaseCalandarView

- (void)onSelectedItemBlock:(DidSelectedItemBlock)block;

- (void)onHeightDidChangedBlock:(DidChangedHeightBlock)block;

@end
