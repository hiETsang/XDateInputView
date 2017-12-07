//
//  XInputTextField.h
//  LEVE
//
//  Created by canoe on 2017/12/7.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XInputTextField;

@protocol XInputTextFieldDelegate <NSObject>

-(void)xInputTextFieldDeleteBackWard:(XInputTextField *)textField;

@end

@interface XInputTextField : UITextField

@property(nonatomic, weak) id<XInputTextFieldDelegate> x_delegate;

@end
