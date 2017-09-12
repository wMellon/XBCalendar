//
//  XBCalendarViewModel.m
//  XBCalendar
//
//  Created by xxb on 2017/9/6.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "XBCalendarViewModel.h"
#import "XBCalendarModel.h"
#import "XBCalendarDateTool.h"

@implementation XBCalendarViewModel

+(NSMutableArray*)getDateSourceWithDate:(NSDate*)date{
    //6行7列，固定值
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:42];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //当月的第一天
    NSDate *startDateOfDay;
    NSTimeInterval TIOfDay;
    //获取该日期最早的天数
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDateOfDay interval:&TIOfDay forDate:date];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:startDateOfDay];
    //上个月
    //1号是周几
    NSInteger firstDay = components.weekday;
    NSMutableArray *lastMonthDateArray = [[NSMutableArray alloc] init];
    XBCalendarModel *model;
    for(NSInteger i = 0; i < firstDay - 1; i++){
        components.day -= 1;
        model = [[XBCalendarModel alloc] init];
        model.date = [calendar dateFromComponents:components];
        model.isCurrent = NO;
        model.isPlanDate = [self isPlanDate:model.date];
        if(model.isPlanDate){
            model.planOverDate = [XBCalendarDateTool dayCompareBetween:model.date and:[NSDate date]] >= 0 ? NO : YES;
        }
        [lastMonthDateArray addObject:model];
    }
    //排序
    for(XBCalendarModel *model in [lastMonthDateArray reverseObjectEnumerator]){
        [resultArray addObject:model];
    }
    //本月
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:startDateOfDay];
    components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:startDateOfDay];
    for(NSInteger i = 1; i <= range.length; i++){
        components.day = i;
        model = [[XBCalendarModel alloc] init];
        model.date = [calendar dateFromComponents:components];
        model.isCurrent = YES;
        model.isPlanDate = [self isPlanDate:model.date];
        if(model.isPlanDate){
            model.planOverDate = [XBCalendarDateTool dayCompareBetween:model.date and:[NSDate date]] >= 0 ? NO : YES;
        }
        [resultArray addObject:model];
    }
    
    //下个月
    //components到这里已经是当月最后一天
    NSInteger lastDay = components.weekday;
    for(NSInteger i = 1; i < (7 - lastDay); i++){
        components.day += 1;
        model = [[XBCalendarModel alloc] init];
        model.date = [calendar dateFromComponents:components];
        model.isCurrent = NO;
        model.isPlanDate = [self isPlanDate:model.date];
        if(model.isPlanDate){
            model.planOverDate = [XBCalendarDateTool dayCompareBetween:model.date and:[NSDate date]] >= 0 ? NO : YES;
        }
        [resultArray addObject:model];
    }
    while (resultArray.count < 42) {
        components.day += 1;
        model = [[XBCalendarModel alloc] init];
        model.date = [calendar dateFromComponents:components];
        model.isCurrent = NO;
        model.isPlanDate = [self isPlanDate:model.date];
        if(model.isPlanDate){
            model.planOverDate = [XBCalendarDateTool dayCompareBetween:model.date and:[NSDate date]] >= 0 ? NO : YES;
        }
        [resultArray addObject:model];
    }
    return resultArray;
}

+(BOOL)isPlanDate:(NSDate*)date{
    for(NSDate *d in [self planDateArray]){
        if([XBCalendarDateTool isSameDate:date and:d]){
            return YES;
        }
    }
    return NO;
}

+(NSArray*)planDateArray{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:7];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:9];
    [components setMonth:9];
    [components setYear:2017];
    for(NSInteger i = 0; i < 7; i++){
        components.day += 1;
        [array addObject:[[NSCalendar currentCalendar] dateFromComponents:components]];
    }
    return array;
}

@end
