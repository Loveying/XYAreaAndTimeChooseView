//
//  DateChooseView.h
//  YongZhiZheng
//
//  Created by xyy on 2016/12/5.
//  Copyright © 2016年 exl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateChooseView : UIView

/**
 *  显示
 */
-(void)showDateView:(void(^)(NSDate *selectDate))selectDate;

@end
