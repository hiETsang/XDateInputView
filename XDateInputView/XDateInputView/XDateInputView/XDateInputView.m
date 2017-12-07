//
//  XDateInputView.m
//  LEVE
//
//  Created by canoe on 2017/12/7.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import "XDateInputView.h"
#import "XInputTextField.h"
#import "UITextField+Shake.h"

/***  当前屏幕宽度 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

/***  以6s为基准等比例高度 */
#define kRatioHeight(height) (height)/667.0 * kScreenHeight
/***  以6s为基准等比例宽 */
#define kRatioWidth(weight) (weight)/375.0 * kScreenWidth


//思路
//1. 年的第一位可以输入1和2。其他位数，每输入一位数字，其他位默认填充1900-01-01，当第一位是2时，其他位默认填充2000-01-01
//2.每一次的输入判断是否是正确的日期格式，然后再判断是否是位于日期区间

@interface XDateInputView()<UITextFieldDelegate,XInputTextFieldDelegate>

@property(nonatomic, strong) NSMutableArray *textfieldArray;

@property(nonatomic, assign) BOOL canlastActiveTF;//是否能够退到上一个输入框

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, copy) NSDate *inputDate;

@end

@implementation XDateInputView

#pragma mark - init

-(NSMutableArray *)textfieldArray
{
    if (!_textfieldArray) {
        _textfieldArray = [NSMutableArray array];
    }
    return _textfieldArray;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self createUI];
    }
    return self;
}

-(void)initData
{
    self.orginDate = [self dateFromString:@"19000101"];
    self.lastDate = [NSDate date];
}

-(void)beginEdit
{
    UITextField *textfield = self.textfieldArray[0];
    [textfield becomeFirstResponder];
}

#pragma mark - UI

-(void)createUI
{
    for (NSInteger i = 0; i < 4; i++) {
        XInputTextField *yearTF = [[XInputTextField alloc] initWithFrame:CGRectMake(kRatioWidth(4 + 18) * i , 0, kRatioWidth(18), 20)];
        [self addSubview:yearTF];
        yearTF.keyboardType = UIKeyboardTypeNumberPad;
        yearTF.textAlignment = NSTextAlignmentCenter;
        yearTF.delegate = self;
        yearTF.x_delegate = self;
        yearTF.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1/1.0];
        yearTF.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [yearTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addBottomLineViewWithTextField:yearTF];
        [self.textfieldArray addObject:yearTF];
    }
    
    UIView *sepOne = [[UIView alloc] initWithFrame:CGRectMake(kRatioWidth(98), 3, kRatioWidth(2), 14)];
    sepOne.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1/1.0];
    [self addSubview:sepOne];
    
    for (NSInteger i = 0; i < 2; i++) {
        XInputTextField *monthTF = [[XInputTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sepOne.frame) + kRatioWidth(11) + kRatioWidth(4 + 18) * i , 0, kRatioWidth(18), 20)];
        [self addSubview:monthTF];
        monthTF.keyboardType = UIKeyboardTypeNumberPad;
        monthTF.textAlignment = NSTextAlignmentCenter;
        monthTF.delegate = self;
        monthTF.x_delegate = self;
        monthTF.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1/1.0];
        monthTF.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [monthTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addBottomLineViewWithTextField:monthTF];
        [self.textfieldArray addObject:monthTF];
    }
    
    UIView *sepTwo = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sepOne.frame) + kRatioWidth(61), 3, kRatioWidth(2), 14)];
    sepTwo.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1/1.0];
    [self addSubview:sepTwo];
    
    for (NSInteger i = 0; i < 2; i++) {
        XInputTextField *dayTF = [[XInputTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sepTwo.frame) + kRatioWidth(11) + kRatioWidth(4 + 18) * i , 0, kRatioWidth(18), 20)];
        [self addSubview:dayTF];
        dayTF.keyboardType = UIKeyboardTypeNumberPad;
        dayTF.textAlignment = NSTextAlignmentCenter;
        dayTF.delegate = self;
        dayTF.x_delegate = self;
        dayTF.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1/1.0];
        dayTF.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [dayTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addBottomLineViewWithTextField:dayTF];
        [self.textfieldArray addObject:dayTF];
    }
}

-(void) addBottomLineViewWithTextField:(UITextField *)textfield
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, textfield.frame.size.height + 1, textfield.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:176/255.0 green:182/255.0 blue:194/255.0 alpha:1/1.0];
    [textfield addSubview:line];
}

#pragma mark - Date
-(NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMdd";
    NSDate *date = [format dateFromString:string];
    return date;
}

-(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMdd";
    NSString *newString = [format stringFromDate:date];
    return newString;
}

- (BOOL) isValidBirthday:(NSString*)birthday
{
    BOOL result = NO;
    if (birthday && 8 == [birthday length])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:birthday];
        if (date)
        {
            result = YES;
        }
    }
    return result;
}

-(BOOL)judgeTime:(NSDate *)compareDate ByStartAndEnd:(NSDate *)startDate EndTime:(NSDate *)endDate
{
    if (([compareDate compare:startDate] == NSOrderedDescending || [compareDate compare:startDate] == NSOrderedSame)
        && ([compareDate compare:endDate] == NSOrderedAscending || [compareDate compare:endDate] == NSOrderedSame)) {
        return YES;
    }
    return NO;
}

//判断是否符合的时间
-(BOOL)resultAfterInputTextfield:(UITextField *)textfield inputText:(NSString *)str
{
    NSString *dateStr = [NSString string];
    NSInteger index = [self.textfieldArray indexOfObject:textfield];
    
    //这里如果第一个输入2  那么需要更改默认的时间为20000101
    if ([self isAllNotInput] && index == 0 && [str isEqualToString:@"2"]) {
        dateStr = @"20000101";
    }else
    {
        dateStr = [self stringFromDate:self.orginDate];
    }
    
    for (NSInteger i = 0; i < self.textfieldArray.count; i++) {
        UITextField *tf = self.textfieldArray[i];
        if (tf.text.length == 1) {
            dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:tf.text];
        }
    }
    
    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:str];
    
    //是否是正确的时间
    if (![self isValidBirthday:dateStr]) {
        NSLog(@"不是正确时间 ---------> %@",dateStr);
        return NO;
    }
    
    //是否位于时间段内
    if (![self judgeTime:[self dateFromString:dateStr] ByStartAndEnd:self.orginDate EndTime:self.lastDate]) {
        NSLog(@"不是在时间段内 ---------> %@",dateStr);
        return NO;
    }
    
    return YES;
}

- (BOOL)isNumberStrWithStr:(NSString *)str
{
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^\\d{1,1000}$" options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    return results.count > 0;
}

#pragma mark - TextField

-(void)xInputTextFieldDeleteBackWard:(XInputTextField *)textField
{
    //不能退格
    if (!self.canlastActiveTF) {
        self.canlastActiveTF = YES;
        return;
    }
    //删除
    if (textField.text.length == 0){
        [self changeDeleteActiveTextField:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        self.canlastActiveTF = NO;
        return YES;
    }
    
    //不是数字或者大于1位
    NSString *tobeStr = [textField.text stringByAppendingString:string];
    if (![self isNumberStrWithStr:string] || tobeStr.length > 1) {
        [self inputErrorWithTextField:textField];
        return NO;
    }
    
    //判断是否是正确的时间
    if ([self resultAfterInputTextfield:textField inputText:string] == NO) {
        [self inputErrorWithTextField:textField];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    //光标自动跳下一个
    if (textField.text.length == 1) {
        [self changeActiveTextField:textField];
    }
    
    if ([self isAllInput]) {
        NSString *dateStr = [self stringFromDate:self.orginDate];
        for (NSInteger i = 0; i < self.textfieldArray.count; i++) {
            UITextField *tf = self.textfieldArray[i];
            if (tf.text.length == 1) {
                dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:tf.text];
            }
        }
        
        if (self.didEndEditing) {
            self.didEndEditing([self dateFromString:dateStr]);
        }
    }
}

//删除按钮退格
-(void)changeDeleteActiveTextField:(UITextField *)textField
{
    if ([self.textfieldArray.firstObject isEqual:textField]) {
        return;
    }
    [textField resignFirstResponder];
    NSInteger index = [self.textfieldArray indexOfObject:textField];
    UITextField *tf = self.textfieldArray[index - 1];
    [tf becomeFirstResponder];
}

//自动跳转下一个光标
-(void)changeActiveTextField:(UITextField *)textField
{
    //最后一个并且前面有没有输入完的
    if ([self.textfieldArray.lastObject isEqual:textField]) {
        if (![self isAllInput]) {
            return;
        }else
        {
            [textField resignFirstResponder];
            return;
        }
    }
    [textField resignFirstResponder];
    //往下循环查找没有填写的输入框
    NSInteger index = [self.textfieldArray indexOfObject:textField];
    for (index = index + 1; index < self.textfieldArray.count; index ++) {
        UITextField *textfield = self.textfieldArray[index];
        if (textfield.text.length == 0) {
            [textfield becomeFirstResponder];
            break;
        }
    }
}

//是否全部输入
-(BOOL)isAllInput
{
    BOOL allInput = YES;
    for (UITextField *textField in self.textfieldArray) {
        if (textField.text.length == 0) {
            allInput = NO;
            break;
        }
    }
    
    return allInput;
}

//是否没有一个输入
-(BOOL)isAllNotInput
{
    BOOL allNotInput = YES;
    for (UITextField *textField in self.textfieldArray) {
        if (textField.text.length != 0) {
            allNotInput = NO;
            break;
        }
    }
    
    return allNotInput;
}

//输入错误
-(void)inputErrorWithTextField:(UITextField *)textfield
{
    [textfield shake:6 withDelta:3 speed:0.05];
    textfield.tintColor = [UIColor redColor];
    if (_timer.isValid){
        [_timer invalidate];
    }
    _timer = nil;//实际测试中，不置nil也正常运行，还是保持规范性
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeColor:) userInfo:textfield repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)changeColor:(NSTimer *)timer
{
    UITextField *textfield = (UITextField *)timer.userInfo;
    textfield.tintColor = [UIColor blueColor];
}

@end
