//
//  XDateInputView.h
//  LEVE
//
//  Created by canoe on 2017/12/7.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDateInputView : UIView

/**
 可以输入最小的时间  默认1990-01-01
 */
@property(nonatomic, strong) NSDate *orginDate;

/**
 可以输入最大的时间  默认当前时间
 */
@property(nonatomic, strong) NSDate *lastDate;

/**
 弹出键盘，开始编辑
 */
-(void)beginEdit;

/**
 结束编辑
 */
@property (nonatomic,copy) void (^didEndEditing)(NSDate *inputDate);


@end
