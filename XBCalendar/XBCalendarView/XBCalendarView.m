//
//  XBCalendarView.m
//  XBCalendar
//
//  Created by xxb on 2017/9/6.
//  Copyright © 2017年 com.xb. All rights reserved.
//

#import "XBCalendarView.h"
#import "AppDelegate.h"
#import "XBCalendarViewModel.h"
#import "XBCalendarLayout.h"
#import "XBCalendarCell.h"
#import "XBCalendarDateTool.h"
#import "XBCalendarModel.h"

@interface XBCalendarView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *bgView;
//上个月  当前月  下个月
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *lastMonthBtn;
@property (nonatomic, strong) UILabel *currentMonthLabel;
@property (nonatomic, strong) UIButton *nextMonthBtn;
//显示周几
@property (nonatomic, strong) UIView *weekView;

@property (nonatomic, strong) UICollectionView *dateCollectionView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *backToTodayBtn;
@property (nonatomic, strong) UIButton *hideBtn;

//数据
//当前展示
@property (nonatomic, strong) NSDate *displayDate;
@property (nonatomic, strong) NSArray *dataSource;
//选中的
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSDate *today;

@end

@implementation XBCalendarView

-(instancetype)init{
    self = [self initWithDate:[NSDate date]];
    if(self){
    }
    return self;
}

-(instancetype)initWithDate:(NSDate*)date{
    self = [super initWithFrame:CGRectMake(0, 20, ScreenWidth, TitleViewHeight + WeekViewHeight + DateCollectionHeight + 1 + BottomHeight)];
    if (self) {
        //页面设置
        self.backgroundColor = BaseColor;
        [self addSubview:self.titleView];
        [self addSubview:self.weekView];
        [self addSubview:self.dateCollectionView];
        [self addSubview:self.lineView];
        [self addSubview:self.bottomView];
        //数据处理
        self.today = [NSDate date];
        self.displayDate = date;
        if(!date){
            self.displayDate = self.today;
        }
        self.dataSource = [XBCalendarViewModel getDateSourceWithDate:self.displayDate];
        [self preSetSelected:self.today];
        [self updateUI];
    }
    return self;
}

#pragma mark - 懒加载

-(UIView *)titleView{
    if(!_titleView){
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TitleViewHeight)];
        [_titleView addSubview:self.lastMonthBtn];
        [_titleView addSubview:self.nextMonthBtn];
        [_titleView addSubview:self.currentMonthLabel];
    }
    return _titleView;
}

-(UIButton *)lastMonthBtn{
    if(!_lastMonthBtn){
        _lastMonthBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, frameHeight(_titleView))];
        [_lastMonthBtn addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
        _lastMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _lastMonthBtn;
}

-(UILabel *)currentMonthLabel{
    if(!_currentMonthLabel){
        CGFloat x = CGRectGetMaxX(_lastMonthBtn.frame);
        _currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, frameX(_nextMonthBtn) - x, frameHeight(_titleView))];
        _currentMonthLabel.textAlignment = NSTextAlignmentCenter;
        _currentMonthLabel.textColor = [UIColor whiteColor];
    }
    return _currentMonthLabel;
}

-(UIButton *)nextMonthBtn{
    if(!_nextMonthBtn){
        _nextMonthBtn = [[UIButton alloc] initWithFrame:CGRectMake(frameWidth(_titleView) - 50 - 15, 0, 50, frameHeight(_titleView))];
        [_nextMonthBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
        _nextMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nextMonthBtn;
}

-(UIView *)weekView{
    if(!_weekView){
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(17/2, CGRectGetMaxY(_titleView.frame), frameWidth(self) - 17, WeekViewHeight)];
        //设置
        NSArray *array = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        CGFloat width = frameWidth(_weekView) / 7;
        UILabel *label;
        for(NSInteger i = 0; i < array.count; i++){
            label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0, width, 14)];
            label.textColor = rgb(170, 224, 255);
            label.font = [UIFont systemFontOfSize:14];
            label.text = array[i];
            label.textAlignment = NSTextAlignmentCenter;
            [_weekView addSubview:label];
        }
    }
    return _weekView;
}

-(UICollectionView *)dateCollectionView{
    if(!_dateCollectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //6行
        _dateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_weekView.frame), ScreenWidth, DateCollectionHeight) collectionViewLayout:flowLayout];
        _dateCollectionView.backgroundColor = [UIColor clearColor];
        [_dateCollectionView registerClass:[XBCalendarCell class] forCellWithReuseIdentifier:@"XBCalendarCell"];
        _dateCollectionView.delegate = self;
        _dateCollectionView.dataSource = self;
    }
    return _dateCollectionView;
}

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, frameHeight(self), ScreenWidth, ScreenHeight - frameHeight(self))];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _bgView;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateCollectionView.frame), frameWidth(self), 1)];
        _lineView.backgroundColor = rgb(109, 196, 232);
    }
    return _lineView;
}

-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), frameWidth(self), BottomHeight)];
        [_bottomView addSubview:self.backToTodayBtn];
        [_bottomView addSubview:self.historyBtn];
        [_bottomView addSubview:self.hideBtn];
    }
    return _bottomView;
}

-(UIButton *)backToTodayBtn{
    if(!_backToTodayBtn){
        _backToTodayBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 18, 67, 22)];
        [_backToTodayBtn setTitle:@"回到今天" forState:UIControlStateNormal];
        _backToTodayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backToTodayBtn setTitleColor:rgb(170, 224, 255) forState:UIControlStateNormal];
        _backToTodayBtn.layer.cornerRadius = 5;
        _backToTodayBtn.layer.borderWidth = 1;
        _backToTodayBtn.layer.borderColor = [rgb(170, 224, 255) CGColor];
        [_backToTodayBtn addTarget:self action:@selector(backToToday) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToTodayBtn;
}

-(UIButton *)historyBtn{
    if(!_historyBtn){
        _historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(frameWidth(self) - 100 - 15, 18, 100, 22)];
        [_historyBtn setTitle:@"查看历史计划 >" forState:UIControlStateNormal];
        _historyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _historyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_historyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _historyBtn;
}

-(UIButton *)hideBtn{
    if(!_hideBtn){
        _hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backToTodayBtn.frame) + 10, frameWidth(self), 38)];
        [_hideBtn setImage:[UIImage imageNamed:@"XBCalendarUp"] forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideBtn;
}

#pragma mark - UICollection

#pragma mark -collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XBCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XBCalendarCell" forIndexPath:indexPath];
    XBCalendarModel *model = self.dataSource[indexPath.row];
    [cell setDay:[XBCalendarDateTool getDayOfMonth:model.date] isCurrent:model.isCurrent isPlanDate:model.isPlanDate planOverDate:model.planOverDate];
    //默认选中or之前选中
    if([XBCalendarDateTool isSameMonth:model.date and:self.selectedDate] && self.selectedIndexPath == indexPath){
        [cell select:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

#pragma mark -UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //无效点击
    XBCalendarModel *model = self.dataSource[indexPath.row];
    if(!model.isCurrent &&
       [XBCalendarDateTool getMonthOfDate:model.date] > [XBCalendarDateTool getMonthOfDate:self.today]){
        return NO;
    }else{
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XBCalendarModel *model = self.dataSource[indexPath.row];
    
    //如果不是本月内的日期要做刷新
    if(![XBCalendarDateTool isSameMonth:model.date and:self.displayDate]){
        self.displayDate = model.date;
        self.dataSource = [XBCalendarViewModel getDateSourceWithDate:self.displayDate];
        [self preSetSelected:self.displayDate];
        [self updateUI];
    }else{
        self.selectedDate = model.date;
        self.selectedIndexPath = indexPath;
        XBCalendarCell *cell = (XBCalendarCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [cell select:YES];
    }
    
    //响应外界操作
    if([self.delegate respondsToSelector:@selector(selectDate:)]){
        [self.delegate selectDate:model.date];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    XBCalendarCell *cell = (XBCalendarCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell select:NO];
}

#pragma mark -UICollectionViewDelegateFlowLayout

#pragma mark -设置每个item的size

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(DateCellWidth, DateCellHeight);
}

#pragma mark -设置每个item水平间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 17/2, 0, 17/2);
}

#pragma mark - Action

/**
 预先设置选中部分（包括月份、indexPath）。需要先获取数据源

 @param date 传入要选中的日期
 */
-(void)preSetSelected:(NSDate*)date{
    for(NSInteger i = 0; i < self.dataSource.count; i++){
        XBCalendarModel *model = self.dataSource[i];
        if([XBCalendarDateTool isSameDate:model.date and:date]){
            //同一天
            self.selectedDate = date;
            self.selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
}

/**
 反选

 @param indexPath indexPath description
 */
-(void)unSelectForUI:(NSIndexPath*)indexPath{
    if(indexPath){
        XBCalendarCell *cell = (XBCalendarCell*)[self.dateCollectionView cellForItemAtIndexPath:indexPath];
        [cell select:NO];
        [self.dateCollectionView deselectItemAtIndexPath:self.selectedIndexPath animated:NO];
    }
}

#pragma mark -刷新UI。（日期和顶部月份栏）

/**
 根据displayDate和selectedIndexPath（用来改变cell的选中状态，没有的话就是用默认）来刷新
 */
-(void)updateUI{
    [self.dateCollectionView reloadData];
    self.currentMonthLabel.text = [XBCalendarDateTool getYearMonth:self.displayDate];
    [self updateBtnLayout];
}

-(void)updateBtnLayout{
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"XBCalendarLast"];
    //image不能设置跟lineHeight相等，不然label会再自动加上去
    attach.bounds = CGRectMake(0, -1.5, 7, _lastMonthBtn.titleLabel.font.pointSize);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    NSString *text = [NSString stringWithFormat:@" %ld月", [XBCalendarDateTool getLastMonth:self.displayDate]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_lastMonthBtn.titleLabel.font.pointSize] range:NSMakeRange(0, text.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = _lastMonthBtn.titleLabel.font.pointSize;
    paragraphStyle.lineSpacing = 0;
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [attributedText appendAttributedString:attString];
    [_lastMonthBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    if([XBCalendarDateTool getValidNextMonth:self.displayDate] != 0){
        _nextMonthBtn.hidden = NO;
        NSTextAttachment *attach = [NSTextAttachment new];
        attach.image = [UIImage imageNamed:@"XBCalendarNext"];
        attach.bounds = CGRectMake(0, -1.5, 7, _nextMonthBtn.titleLabel.font.pointSize);
        NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
        
        NSString *text = [NSString stringWithFormat:@"%ld月 ", [XBCalendarDateTool getValidNextMonth:self.displayDate]];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_nextMonthBtn.titleLabel.font.pointSize] range:NSMakeRange(0, text.length)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
        [attString appendAttributedString:attributedText];
        [_nextMonthBtn setAttributedTitle:attString forState:UIControlStateNormal];
    }else{
        _nextMonthBtn.hidden = YES;
    }
}

-(void)lastMonth{
    self.displayDate = [XBCalendarDateTool getDateByDate:_displayDate andMonthOffset:-1];
    [self unSelectForUI:self.selectedIndexPath];
    self.dataSource = [XBCalendarViewModel getDateSourceWithDate:self.displayDate];
    [self updateUI];
}

-(void)nextMonth{
    _displayDate = [XBCalendarDateTool getDateByDate:_displayDate andMonthOffset:+1];
    [self unSelectForUI:self.selectedIndexPath];
    self.dataSource = [XBCalendarViewModel getDateSourceWithDate:self.displayDate];
    [self updateUI];
}

-(void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bgView];
    [keyWindow addSubview:self];
}

-(void)toToday{
    //顶部月份显示
    if(![XBCalendarDateTool isSameMonth:self.displayDate and:self.today]){
        [self unSelectForUI:self.selectedIndexPath];
        self.displayDate = self.today;
        self.dataSource = [XBCalendarViewModel getDateSourceWithDate:self.displayDate];
        [self preSetSelected:self.today];
        [self updateUI];
    }else{
        //反选
        [self unSelectForUI:self.selectedIndexPath];
        //选中
        [self preSetSelected:self.today];
        XBCalendarCell *cell = (XBCalendarCell*)[self.dateCollectionView cellForItemAtIndexPath:self.selectedIndexPath];
        [cell select:YES];
        [self.dateCollectionView selectItemAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark -点击“回到今天”触发

-(void)backToToday{
    [self toToday];
}

-(void)hide{
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

@end
