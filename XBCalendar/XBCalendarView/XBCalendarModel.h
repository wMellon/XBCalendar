//
//  XBCalendarModel.h
//  XBCalendar
//
//  Created by xxb on 2017/9/7.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBCalendarModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL isCurrent;//是否当前显示的月份的某一天
@property (nonatomic, assign) BOOL isPlanDate;//是否计划内的那一天
@property (nonatomic, assign) BOOL planOverDate;//计划内过期的时间

@end
