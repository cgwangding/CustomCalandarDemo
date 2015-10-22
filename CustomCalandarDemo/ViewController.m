//
//  ViewController.m
//  CustomCalandarDemo
//
//  Created by AD-iOS on 15/10/21.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "ViewController.h"
#import "CustomCalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CustomCalendarView *calendarView = [[CustomCalendarView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 300)];
    [self.view addSubview:calendarView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
