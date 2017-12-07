//
//  ViewController.m
//  XDateInputView
//
//  Created by canoe on 2017/12/7.
//  Copyright © 2017年 canoe. All rights reserved.
//

#import "ViewController.h"
#import "XDateInputView.h"


/***  当前屏幕宽度 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

/***  以6s为基准等比例高度 */
#define kRatioHeight(height) (height)/667.0 * kScreenHeight
/***  以6s为基准等比例宽 */
#define kRatioWidth(weight) (weight)/375.0 * kScreenWidth

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XDateInputView *birthDayView = [[XDateInputView alloc] initWithFrame:CGRectMake(kRatioWidth((kScreenWidth - 216)/2), 193, kRatioWidth(216), 20)];
    [self.view addSubview:birthDayView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
