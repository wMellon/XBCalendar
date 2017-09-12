//
//  XBCalendarDateTool.m
//  XBCalendar
//
//  Created by xxb on 2017/9/7.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "XBCalendarDateTool.h"

@implementation XBCalendarDateTool

+(NSString*)getYearMonth:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月";
    return [dateFormatter stringFromDate:date];
}

+(NSInteger)dayCompareBetween:(NSDate*)date1 and:(NSDate*)date2{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];
    if(components1.year > components2.year){
        return 1;
    }else if(components1.year < components2.year){
        return -1;
    }else{
        if(components1.month > components2.month){
            return 1;
        }else if(components1.month < components2.month){
            return -1;
        }else{
            if(components1.day > components2.day){
                return 1;
            }else if(components1.day < components2.day){
                return -1;
            }else{
                return 0;
            }
        }
    }
}

+(NSInteger)getLastMonth:(NSDate*)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:date];
    NSInteger month = components.month - 1;
    return month == 0 ? 12 : month;
}

+(NSInteger)getValidNextMonth:(NSDate*)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:date];
    NSInteger month = components.month + 1;
    NSInteger year = components.year;
    
    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    if(year < componentsNow.year ||
       (year == componentsNow.year && month <= componentsNow.month)){
        return month > 12 ? 1 : month;
    }else{
        return 0;
    }
}

+(NSDate*)getDateByDate:(NSDate*)date andMonthOffset:(NSInteger)offset{
    NSDate *startDateOfDay = [self getFirstDay:date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:startDateOfDay];
    components.month += offset;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+(NSInteger)getDayOfMonth:(NSDate*)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:date];
    return components.day;
}

+(BOOL)isSameDate:(NSDate*)date1 and:(NSDate*)date2{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];
    return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day;
}

+(BOOL)isSameMonth:(NSDate*)date1 and:(NSDate*)date2{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];
    return components1.year == components2.year && components1.month == components2.month;
}

+(NSInteger)getMonthOfDate:(NSDate*)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:date];
    return components.month;
}

#pragma mark - private

+(NSDate*)getFirstDay:(NSDate*)date{
    //当月的第一天
    NSDate *startDateOfDay;
    NSTimeInterval TIOfDay;
    //获取该日期最早的天数
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDateOfDay interval:&TIOfDay forDate:date];
    return startDateOfDay;
}
@end
