//
//  XBCalendarCell.h
//  XBCalendar
//
//  Created by xxb on 2017/9/7.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBCalendarCell : UICollectionViewCell

/**
 是否选中

 @param isSelect isSelect description
 */
-(void)select:(BOOL)isSelect;

/**
 是否标记

 @param isMark isMark description
 */
-(void)mark:(BOOL)isMark;


/**
 设置时间，是否当个月内、是否计划内、是否过期

 @param day day description
 @param isCurrent isCurrent description
 @param isPlanDate isPlanDate description
 */
-(void)setDay:(NSInteger)day isCurrent:(BOOL)isCurrent isPlanDate:(BOOL)isPlanDate planOverDate:(BOOL)planOverDate;


@end
