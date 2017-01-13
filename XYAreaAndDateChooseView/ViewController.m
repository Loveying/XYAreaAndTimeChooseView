//
//  ViewController.m
//  XYAreaAndDateChooseView
//
//  Created by xyy on 2017/1/13.
//  Copyright © 2017年 Xyy. All rights reserved.
//

#import "ViewController.h"
#import "DateChooseView.h"
#import "AreaChooseView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)DateChooseClick:(UIButton *)sender {
    
    
    DateChooseView *chooseView = [[DateChooseView alloc]initWithFrame:self.view.bounds];
    [chooseView showDateView:^(NSDate *selectDate) {
        
        NSLog(@"选择的日期 = %@",selectDate);
    }];
    
}
- (IBAction)AreaChooseClick:(UIButton *)sender {
    
    AreaChooseView *areaChooseView = [[AreaChooseView alloc]initWithFrame:self.view.bounds];
    [areaChooseView showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        NSLog(@"选择的省市区 = %@ - %@ -%@",proviceStr,cityStr,distr);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
