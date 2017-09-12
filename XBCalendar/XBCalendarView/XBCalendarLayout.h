//
//  XBCalendarLayout.h
//  XBCalendar
//
//  Created by xxb on 2017/9/7.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#ifndef XBCalendarLayout_h
#define XBCalendarLayout_h

//方便访问
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define BaseColor rgb(0,162,255)

#define frameHeight(view) view.frame.size.height
#define frameWidth(view) view.frame.size.width
#define frameX(view) view.frame.origin.x
#define frameY(view) view.frame.origin.y

//view的大小定义
#define TitleViewHeight 44
#define WeekViewHeight 35
#define DateCellHeight 41
#define DateCellWidth (ScreenWidth - 17) / 7
#define DateCollectionHeight DateCellHeight * 6
#define BottomHeight 88

#endif /* XBCalendarLayout_h */
