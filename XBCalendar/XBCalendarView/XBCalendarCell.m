//
//  XBCalendarCell.m
//  XBCalendar
//
//  Created by xxb on 2017/9/7.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "XBCalendarCell.h"
#import "XBCalendarLayout.h"

@interface XBCalendarCell()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *bigCircle;
@property (nonatomic, strong) UIView *smallCircle;

@end

@implementation XBCalendarCell

#pragma mark - property

-(UILabel *)dayLabel{
    if(!_dayLabel){
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake((DateCellWidth - 21) / 2, 3, 21, 14)];
        _dayLabel.font = [UIFont systemFontOfSize:14];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dayLabel];
    }
    return _dayLabel;
}

-(UIView *)bigCircle{
    if(!_bigCircle){
        _bigCircle = [[UIView alloc] initWithFrame:CGRectMake(frameX(_dayLabel), 0, frameWidth(_dayLabel), 20)];
        _bigCircle.backgroundColor = [UIColor whiteColor];
        _bigCircle.layer.cornerRadius = 20 / 2;
        [self.contentView addSubview:_bigCircle];
        [self.contentView sendSubviewToBack:_bigCircle];
    }
    return _bigCircle;
}

-(UIView *)smallCircle{
    if(!_smallCircle){
        _smallCircle = [[UIView alloc] initWithFrame:CGRectMake((DateCellWidth - 5) / 2, CGRectGetMaxY(_dayLabel.frame) + 10, 5, 5)];
        _smallCircle.backgroundColor = [UIColor whiteColor];
        _smallCircle.layer.cornerRadius = 5 / 2;
        [self.contentView addSubview:_smallCircle];
    }
    return _smallCircle;
}

#pragma mark - action

-(void)select:(BOOL)isSelect{
    if(isSelect){
        //选中
        self.bigCircle.hidden = NO;
        self.dayLabel.textColor = BaseColor;
    }else{
        //取消选中
        self.bigCircle.hidden = YES;
        self.dayLabel.textColor = [UIColor whiteColor];
    }
}

-(void)mark:(BOOL)isMark{
    
}

-(void)setDay:(NSInteger)day isCurrent:(BOOL)isCurrent isPlanDate:(BOOL)isPlanDate planOverDate:(BOOL)planOverDate{
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
    if(isCurrent){
        self.dayLabel.textColor = [UIColor whiteColor];
    }else{
        self.dayLabel.textColor = rgb(121, 206, 255);
    }
    
    if(isPlanDate){
        self.smallCircle.hidden = NO;
        if(planOverDate){
            self.smallCircle.backgroundColor = rgb(121, 206, 255);
        }else{
            self.smallCircle.backgroundColor = rgb(255, 255, 1);
        }
    }else{
        self.smallCircle.hidden = YES;
    }
}

@end
