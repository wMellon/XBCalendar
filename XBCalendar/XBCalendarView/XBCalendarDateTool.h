//
//  XBCalendarDateTool.h
//  XBCalendar
//
//  Created by xxb on 2017/9/7.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBCalendarDateTool : NSObject

/**
 获取

 @param date date description
 @return 天
 */
+(NSInteger)getDayOfMonth:(NSDate*)date;

/**
 获取

 @param date date description
 @return 上个月
 */
+(NSInteger)getLastMonth:(NSDate*)date;

/**
 获取合法（不超过当前月份的）

 @param date date description
 @return return value description
 */
+(NSInteger)getValidNextMonth:(NSDate*)date;

/**
 获取指定日期偏移指定月份的日期

 @param date date description
 @return return value description
 */
+(NSDate*)getDateByDate:(NSDate*)date andMonthOffset:(NSInteger)offset;

/**
 获取

 @param date date description
 @return yyyy年mm月
 */
+(NSString*)getYearMonth:(NSDate*)date;

/**
 两个日期的比较，只拿年月日进行比较

 @param date1 date1 description
 @param date2 date2 description
 @return return value description
 */
+(NSInteger)dayCompareBetween:(NSDate*)date1 and:(NSDate*)date2;

/**
 是否同一天

 @param date1 date1 description
 @param date2 date2 description
 @return return value description
 */
+(BOOL)isSameDate:(NSDate*)date1 and:(NSDate*)date2;

/**
 是否同一个月

 @param date1 date1 description
 @param date2 date2 description
 @return return value description
 */
+(BOOL)isSameMonth:(NSDate*)date1 and:(NSDate*)date2;

/**
 获取月份

 @param date date description
 @return return value description
 */
+(NSInteger)getMonthOfDate:(NSDate*)date;

@end
