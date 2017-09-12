//
//  ViewController.m
//  XBCalendar
//
//  Created by xxb on 2017/9/6.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "ViewController.h"
#import "XBCalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)show:(id)sender {
    XBCalendarView *view = [[XBCalendarView alloc] initWithDate:[NSDate date]];
    [view show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
