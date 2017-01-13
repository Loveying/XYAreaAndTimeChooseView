//
//  AreaChooseView.h
//  LZWCustomActionSheet
//
//  Created by xyy on 16/11/10.
//  Copyright © 2016年 lizhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaChooseView : UIView

/**
 *  显示
 */
-(void)showCityView:(void(^)(NSString *proviceStr,NSString *cityStr,NSString *distr))selectStr;

@end
