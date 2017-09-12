//
//  XBCalendarView.h
//  XBCalendar
//
//  Created by xxb on 2017/9/6.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XBCalendarViewDelegate <NSObject>

-(void)selectDate:(NSDate*)date;

@end

@interface XBCalendarView : UIView

@property (nonatomic, weak) id<XBCalendarViewDelegate> delegate;
@property (nonatomic, strong) UIButton *historyBtn;
/**
 传入要展示的日期（展示月份的某一个日期都可以）

 @param date date description
 @return return value description
 */
-(instancetype)initWithDate:(NSDate*)date;

-(void)show;

/**
 回今天
 */
-(void)toToday;

@end
