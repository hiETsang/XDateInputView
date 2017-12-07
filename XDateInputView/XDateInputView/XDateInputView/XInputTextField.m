//
//  XInputTextField.m
//  LEVE
//
//  Created by canoe on 2017/12/7.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import "XInputTextField.h"

@implementation XInputTextField

- (void)deleteBackward {
    [super deleteBackward];
    
    if ([self.x_delegate respondsToSelector:@selector(xInputTextFieldDeleteBackWard:)]) {
        [self.x_delegate xInputTextFieldDeleteBackWard:self];
    }
}

@end
