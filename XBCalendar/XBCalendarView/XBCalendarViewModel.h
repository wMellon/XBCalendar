//
//  XBCalendarViewModel.h
//  XBCalendar
//
//  Created by xxb on 2017/9/6.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBCalendarViewModel : NSObject

/**
 根据日期获取当月展示所需的数组

 @param date 当月的日期
 @return return value description
 */
+(NSMutableArray*)getDateSourceWithDate:(NSDate*)date;

@end
