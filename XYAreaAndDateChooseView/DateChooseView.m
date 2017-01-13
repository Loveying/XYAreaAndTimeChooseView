//
//  DateChooseView.m
//  YongZhiZheng
//
//  Created by xyy on 2016/12/5.
//  Copyright © 2016年 exl. All rights reserved.
//

#import "DateChooseView.h"

#define MaskBgColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

#define ToolBarBgColor [UIColor redColor]

#define BgW self.frame.size.width

#define BgH self.frame.size.height

#define BgViewHeight  240


@interface DateChooseView()

//背景View
@property(nonatomic ,strong)UIView * bgView;

@property(nonatomic ,strong)UIView *toolView;

@property(nonatomic ,strong)UIButton *cancaelBtn;

@property(nonatomic ,strong)UILabel  *titleLabel;

@property(nonatomic ,strong)UIButton *confirmBtn;

//日期选择
@property(nonatomic ,strong)UIDatePicker *datePickView;

@property(nonatomic,copy)void (^selectDate)(NSDate *selectDate);

@end

@implementation DateChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
        //添加内容视图
        [self configContentView];
        
    }
    return self;
    
}


- (void)configContentView
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    
    self.bgView.frame = CGRectMake(0, BgH, BgW, BgViewHeight);
    
    [self addSubview:self.bgView];
    
    //添加工具栏
    self.toolView.frame = CGRectMake(0, 0, BgW, 45);
    [self.bgView addSubview:self.toolView];
    
    
    self.cancaelBtn.frame = CGRectMake(0, 0, 60, 45);
    [self.toolView addSubview:self.cancaelBtn];
    
    self.titleLabel.frame = CGRectMake(self.cancaelBtn.frame.size.width, 0, BgW-(self.cancaelBtn.frame.size.width*2), 45);
    [self.toolView addSubview:self.titleLabel];
    
    self.confirmBtn.frame = CGRectMake(BgW - 64 ,0,60, 45);
    [self.toolView addSubview:self.confirmBtn];
    
    self.datePickView.frame = CGRectMake(0,45, BgW, self.bgView.frame.size.height-45);
    [self.bgView addSubview:self.datePickView];
    
    
}

-(void)showDateView:(void(^)(NSDate *selectDate))selectDate
{
    self.selectDate = selectDate;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak typeof(UIView*)blockview = self.bgView;
    __block int blockH = BgH;
    __block int bjH = BgViewHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
        [self cancelAction];
    }
    
}

#pragma mark - LazyMethod

- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = MaskBgColor;
    }
    return _bgView;
}

- (UIView*)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = ToolBarBgColor;
    }
    return _toolView;
}

- (UIButton*)cancaelBtn {
    if (!_cancaelBtn) {
        _cancaelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancaelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancaelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancaelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancaelBtn;
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"请选择日期";
    }
    return _titleLabel;
}

- (UIButton*)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIDatePicker*)datePickView {
    if (!_datePickView) {
        _datePickView = [[UIDatePicker alloc] init];
        _datePickView.backgroundColor = [UIColor whiteColor];
        //_datePickView.minimumDate = [NSDate date];
        _datePickView.datePickerMode = UIDatePickerModeDate;
        _datePickView.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];    }
    return _datePickView;
}

#pragma mark - 取消按钮事件

- (void)cancelAction
{
    __weak typeof(UIView*)blockview = self.bgView;
    __weak typeof(self)blockself = self;
    __block int blockH = BgH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
    
}

#pragma mark - 确认按钮事件

- (void)confirmAction
{
    __weak typeof(UIView*)blockview = self.bgView;
    __weak typeof(self)blockself = self;
    __block int blockH = BgH;
    
    if (self.selectDate) {
        self.selectDate(_datePickView.date);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
    
}


@end
