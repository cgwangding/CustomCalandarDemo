//
//  CustomCalandarView.m
//  CustomCalandar
//
//  Created by AD-iOS on 15/12/17.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "CustomCalandarView.h"
#import "BaseItem.h"

//日历顶部显示当前年份月份的view的高度
static CGFloat headerHeight = 42;
static CGFloat spaceLR = 15;

@interface CustomCalandarView ()

@property (strong, nonatomic) UIButton *preButton;
@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *dateTitleLabel;

@property (strong, nonatomic) NSMutableArray *itemArr;

@property (strong, nonatomic) BaseItem *preSelItem;

@property (copy, nonatomic) DidSelectedItemBlock block;

@property (copy, nonatomic) DidChangedHeightBlock heightBlock;

@property (strong, nonatomic) BaseItem *currentSelectedItem;

@end

@implementation CustomCalandarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
        [self addSubview:self.headerView];
        [self updateTitleDate];
        [self setupWidget];
    }
    return self;
}

- (void)onSelectedItemBlock:(DidSelectedItemBlock)block
{
    self.block = block;
}

- (void)onHeightDidChangedBlock:(DidChangedHeightBlock)block
{
    self.heightBlock = block;
}

- (void)validDateFormDateComponents:(NSDateComponents *)startDateComp toDateComponents:(NSDateComponents *)endDateComp andWeekdayValid:(BOOL)valid
{
    [super validDateFormDateComponents:startDateComp toDateComponents:endDateComp andWeekdayValid:valid];
//    [self rebulitItem];
    if (self.itemArr.count) {
        [self rebulitItem];
    }
}

- (void)setupWidget
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame ) - CGRectGetHeight(self.headerView.frame))];
    
    view.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    
    CGFloat itemWidth = (CGRectGetWidth(self.frame) - spaceLR * 2)/7.0;
    NSArray *weekdayTitleArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    for (int i = 0; i < weekdayTitleArr.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(spaceLR +  i * itemWidth, 0, itemWidth, 32)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        label.text = weekdayTitleArr[i];
        [view addSubview:label];
    }
    
    
    
    NSInteger column = 7;
    NSInteger row = self.dateArr.count / column;
    if (self.dateArr.count % column) {
        row += 1;
    }
    
    UIView *itemBgView = [[UIView alloc]initWithFrame:CGRectMake(spaceLR, 32, CGRectGetWidth(view.frame) - spaceLR * 2, itemWidth * row)];
    itemBgView.layer.borderWidth = 1;
    itemBgView.layer.borderColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0].CGColor;
    [view addSubview:itemBgView];
    
    for (int i = 0; i < row ; i++) {
        for (int j = 0; j < column; j++) {
            BaseItem *item = [BaseItem buttonWithType:UIButtonTypeCustom];
            [item setFrame:CGRectMake(j * itemWidth, i  * itemWidth, itemWidth, itemWidth)];
            item.model = self.dateArr[i * column + j];
            [item addTarget:self action:@selector(dateItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [itemBgView addSubview:item];
            [self.itemArr addObject:item];
        }
    }
    
    //由于时间最多有42个，如果不够42个，那么再创建几个,后面复用
    if (self.itemArr.count < 42) {
        NSInteger itemCount = self.itemArr.count;
        for (int i = 0; i <= (42 - itemCount); i++) {
            BaseItem *item = [BaseItem buttonWithType:UIButtonTypeCustom];
            [item setFrame:CGRectMake(0, 0, 0, 0)];
            [item addTarget:self action:@selector(dateItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.itemArr addObject:item];
        }
    }
    
    
    [self addSubview:view];
    
    CGFloat currentHeight = 32 + 42 + itemWidth * row + 42;
    if (self.heightBlock) {
        self.heightBlock(currentHeight);
    }
    
}

- (void)rebulitItem
{
    CGFloat itemWidth = (CGRectGetWidth(self.frame) - spaceLR * 2)/7.0;
    
    UIView *itemBgView = [[self.itemArr firstObject] superview];
    
    [self.itemArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger column = 7;
    NSInteger row = self.dateArr.count / column;
    if (self.dateArr.count % column) {
        row += 1;
    }
    
    CGRect frame = itemBgView.frame;
    frame.size.height = itemWidth * row;
    itemBgView.frame = frame;
    
    for (int i = 0; i < row ; i++) {
        for (int j = 0; j < column; j++) {
            BaseItem *item = self.itemArr[i * column + j];
            [item setFrame:CGRectMake(j * itemWidth, i  * itemWidth, itemWidth, itemWidth)];
            item.model = self.dateArr[i * column + j];
            [itemBgView addSubview:item];
            
            if (self.currentSelectedItem != nil && [item isEqualToItem:self.currentSelectedItem] && item.model.isBetweenValidDate) {
                item.itemType = BaseItemTypeSelect;
                self.preSelItem = item;
            }else{
                item.model = self.dateArr[i * column + j];
            }
        }
    }
    
    CGFloat currentHeight = 32 + 42 + itemWidth * row + 42;
    if (self.heightBlock) {
        self.heightBlock(currentHeight);
    }
    
    
}

- (void)previewMonthButtonClicked:(UIButton*)button
{
    self.preSelItem = nil;
//    for (BaseItem *item in self.itemArr) {
//        item.titleLabel.textColor = [UIColor blackColor];
//    }
    [self previewMonth];
    [self updateTitleDate];
//    [self rebulitItem];
}

- (void)nextMonthButtonClicked:(UIButton*)button
{
    self.preSelItem = nil;
//    for (BaseItem *item in self.itemArr) {
//        item.titleLabel.textColor = [UIColor blackColor];
//    }
    [self nextMonth];
    [self updateTitleDate];
//    [self rebulitItem];
}

- (void)updateTitleDate
{
    NSString *dateStr = [NSString stringWithFormat:@"%lu年%lu月",(long)self.currentComponents.year,self.currentComponents.month];
    self.dateTitleLabel.text = dateStr;
}

#pragma mark - button action

- (void)dateItemButtonClicked:(BaseItem*)item
{
    if (self.preSelItem == nil) {
        self.preSelItem = item;
        if (item.selected == NO) {
            item.selected =YES;
            self.currentSelectedItem = item;
            item.itemType = BaseItemTypeSelect;
            if (self.block) {
                self.block(item);
            }
        }
        
    }else if (self.preSelItem && ![item isEqual:self.preSelItem]){
        self.preSelItem.selected = NO;
        self.preSelItem.itemType = BaseItemTypeNone;
        item.selected = YES;
        //记录当前选中
        self.currentSelectedItem = item;
        if (self.block) {
            self.block(item);
        }
        item.itemType = BaseItemTypeSelect;
        self.preSelItem = item;
    }
    
}

#pragma mark -

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), headerHeight)];
        _headerView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:247/255.0 alpha:1.0];
        //添加日期显示的标签
        [_headerView addSubview:self.dateTitleLabel];
        [self.dateTitleLabel setFrame:CGRectMake(CGRectGetWidth(_headerView.frame) / 2.0 - 75, 0, 75 * 2, CGRectGetHeight(_headerView.frame))];
        
        //添加切换的按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 35, CGRectGetHeight(_headerView.frame))];
        [leftButton setImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        leftButton.transform = CGAffineTransformMakeRotation(M_PI);
        leftButton.tintColor = [UIColor grayColor];
        [leftButton addTarget:self action:@selector(previewMonthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:leftButton];
        
        //添加切换的按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(CGRectGetWidth(_headerView.frame) - 35, 0, 35, CGRectGetHeight(_headerView.frame))];
        [rightButton setImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        rightButton.tintColor = [UIColor grayColor];
        [rightButton addTarget:self action:@selector(nextMonthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:rightButton];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(_headerView.frame) - 1, CGRectGetWidth(_headerView.frame), 1)];
        lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [_headerView addSubview:lineView];
    }
    return _headerView;
}

- (UILabel *)dateTitleLabel
{
    if (_dateTitleLabel == nil) {
        _dateTitleLabel = [[UILabel alloc]init];
        _dateTitleLabel.textAlignment = NSTextAlignmentCenter;
        _dateTitleLabel.textColor = [UIColor colorWithRed:58/255.0 green:75/255.0 blue:118/255.0 alpha:1.0];
        _dateTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateTitleLabel;
}

- (NSMutableArray *)itemArr
{
    if (_itemArr == nil) {
        _itemArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemArr;
}

@end
