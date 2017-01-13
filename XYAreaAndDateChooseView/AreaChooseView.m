//
//  AreaChooseView.m
//  LZWCustomActionSheet
//
//  Created by xyy on 16/11/10.
//  Copyright © 2016年 lizhiwei. All rights reserved.
//

#import "AreaChooseView.h"

#define MaskBgColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

#define ToolBarBgColor [UIColor blueColor]

#define BgW self.frame.size.width

#define BgH self.frame.size.height

#define BgViewHeight  240

@interface AreaChooseView()<UIPickerViewDelegate,UIPickerViewDataSource>

//背景View
@property(nonatomic ,strong)UIView * bgView;

@property(nonatomic ,strong)UIView *toolView;

@property(nonatomic ,strong)UIButton *cancaelBtn;

@property(nonatomic ,strong)UILabel  *titleLabel;

@property(nonatomic ,strong)UIButton *confirmBtn;

//省市区选择器
@property(nonatomic ,strong)UIPickerView *pickView;

//所有数据的数组
@property(nonatomic ,strong)NSArray *allArr;

//只装省份的数组
@property(nonatomic ,strong)NSMutableArray *provinceArr;

//只装城市的数组
@property(nonatomic ,strong)NSMutableArray *cityArr;

//只装区域的数组
@property(nonatomic ,strong)NSMutableArray *districtArr;

//用于记录选中哪个省的索引
@property(nonatomic ,assign)NSInteger proIndex;

//用于记录选中哪个市的索引
@property(nonatomic ,assign)NSInteger cityIndex;

//用于记录选中哪个区的索引
@property(nonatomic ,assign)NSInteger districtIndex;


@property (copy, nonatomic) void (^sele)(NSString *proviceStr,NSString *cityStr,NSString *distr);

@end


@implementation AreaChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //添加内容视图
         [self configContentView];
        
        //读取数据
        [self configAreaDate];
        
        
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
    
    self.pickView.frame = CGRectMake(0,45, BgW, self.bgView.frame.size.height-45);
    [self.bgView addSubview:self.pickView];
    
    
}


- (void)configAreaDate
{
    
    _provinceArr = [NSMutableArray array];
    
    _cityArr = [NSMutableArray array];
    
    _districtArr = [NSMutableArray array];
    
    
    self.allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    
    for (NSDictionary *dci in self.allArr) {
        [self.provinceArr addObject:[[dci allKeys] firstObject]];
    }
    if (!self.provinceArr.count){
        
        NSLog(@"卧槽，你连数据都没有，你也敢来调用");
    }
    
    for (NSDictionary *dci in self.allArr) {
        
        if ([dci objectForKey:self.provinceArr[self.proIndex]]) {
            self.cityArr = [NSMutableArray arrayWithArray:[[dci objectForKey:self.provinceArr[self.proIndex]] allKeys]];
            
            [_pickView reloadComponent:1];
            [_pickView selectRow:0 inComponent:1 animated:YES];
            
            self.districtArr = [NSMutableArray arrayWithArray:[[dci objectForKey:self.provinceArr[self.proIndex]] objectForKey:self.cityArr[0]]];
            [_pickView reloadComponent:2];
            [_pickView selectRow:0 inComponent:2 animated:YES];
            
        }
    }

    
}

#pragma mark - UIPickerView Delegate
//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _proIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        for (NSDictionary *dci in self.allArr) {
            
            if ([dci objectForKey:self.provinceArr[_proIndex]]) {
                self.cityArr = [NSMutableArray arrayWithArray:[[dci objectForKey:self.provinceArr[_proIndex]] allKeys]];
                
                [_pickView reloadComponent:1];
                [_pickView selectRow:0 inComponent:1 animated:YES];
                
                self.districtArr = [NSMutableArray arrayWithArray:[[dci objectForKey:self.provinceArr[_proIndex]] objectForKey:self.cityArr[0]]];
                [_pickView reloadComponent:2];
                [_pickView selectRow:0 inComponent:2 animated:YES];
                
            }
        }
        
    }
    
    if (component == 1) {
        _cityIndex = row;
        _districtIndex = 0;
        
        for (NSDictionary *dci in self.allArr) {
            
            if ([dci objectForKey:self.provinceArr[_proIndex]]) {
                self.districtArr = [[dci objectForKey:self.provinceArr[_proIndex]] objectForKey:self.cityArr[_cityIndex]];
                [_pickView reloadComponent:2];
                [_pickView selectRow:0 inComponent:2 animated:YES];
                
            }
        }
        
    }
    
    if (component == 2) {
        
        _districtIndex = row;
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [self.provinceArr objectAtIndex:row];
    }else if (component == 1){
        return [self.cityArr objectAtIndex:row];
    }else if (component == 2){
        return [self.districtArr objectAtIndex:row];
    }
    
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.provinceArr.count;
    }else if (component == 1){
        return self.cityArr.count;
    }else if (component == 2){
        return self.districtArr.count;
    }
    
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
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
    
    if (self.sele) {
        self.sele(self.provinceArr[self.proIndex],self.cityArr[self.cityIndex],self.districtArr[self.districtIndex]);
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

-(void)showCityView:(void (^)(NSString *, NSString *, NSString *))selectStr{
    
    self.sele = selectStr;
    
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


#pragma mark - SetterMethod

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
        _titleLabel.text = @"请选择省市区";
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

- (UIPickerView*)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}



@end
