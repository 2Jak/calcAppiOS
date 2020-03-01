//
//  JFTCalculatorVwCtrl.m
//  CalculatorProject
//
//  Created by hyperactive hi-tech ltd on 27/02/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTCalculatorVwCtrl.h"
static NSDictionary *frickApple;
@interface JFTCalculatorVwCtrl ()
@property (nonatomic, strong) NSString *numberA;
@property (nonatomic, strong) NSString *numberB;
@property (nonatomic) char currentNumber;
@property (nonatomic) char action;
@end

@implementation JFTCalculatorVwCtrl
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initializeMyHateForApple];
    self.numberA = @"0";
    self.numberB = @"";
    self.currentNumber = 'a';
}
-(IBAction)onNumberGroupTouch:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    int buttonCode = [frickApple[senderButton.titleLabel.text] intValue];
    if ([[self getCurrentNumber] isEqualToString:@"0"] && buttonCode != 10)
    {
        [self assignToCurrentNumber: @""];
    }
    if (buttonCode < 10)
    {
        [self assignToCurrentNumber: [NSString stringWithFormat:@"%@%d",[self getCurrentNumber],buttonCode]];
    }
    else if (buttonCode == 10)
    {
        [self assignToCurrentNumber: [NSString stringWithFormat:@"%@.",[self getCurrentNumber]]];
    }
    [self updateVisuals];
}
-(IBAction)onTransformGroupTouch:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    int buttonCode = [frickApple[senderButton.titleLabel.text] intValue];
    double currentNumberDoubleValue = [[self getCurrentNumber] doubleValue];
    switch (buttonCode)
    {
        case 11:
            currentNumberDoubleValue *= -1.0;
            [self assignToCurrentNumber: [self removeUnnecessaryZeroes: currentNumberDoubleValue]];
            break;
        case 12:
            currentNumberDoubleValue = 0.0;
            [self assignToCurrentNumber: [self removeUnnecessaryZeroes: currentNumberDoubleValue]];
            break;
        case 13:
            currentNumberDoubleValue /= 100.0;
            [self assignToCurrentNumber:[self removeUnnecessaryZeroes: currentNumberDoubleValue]];
            break;
        default:
            break;
    }
    [self updateVisuals];
}
-(IBAction)onMathOperationsGroupTouch:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    int buttonCode = [frickApple[senderButton.titleLabel.text] intValue];
    double a = [self.numberA doubleValue];
    double b = [self.numberB doubleValue];
    double result = 0.0;
    if ([self.numberB isEqualToString:@""])
    {
        if (buttonCode != 18)
        {
            [self switchNumbers];
            self.action = [senderButton.titleLabel.text characterAtIndex:0];
        }
        [self updateVisuals];
    }
    else
    {
        if (buttonCode == 18)
        {
            [self executeOperation:self.action onValue:&a andValue:&b into:&result];
            [self switchNumbers];
            self.action = ' ';
            [self assignToCurrentNumber: [self removeUnnecessaryZeroes: result]];
        }
        else
        {
            [self executeOperation:self.action onValue:&a andValue:&b into:&result];
            [self switchNumbers];
            [self assignToCurrentNumber: [self removeUnnecessaryZeroes: result]];
        }
        [self updateVisuals];
    }
}



-(NSString *)removeUnnecessaryZeroes: (double)number
{
    if (number == 0)
        return [NSString stringWithFormat:@"%d", 0];
    NSString *preEditedDoubleString = [NSString stringWithFormat:@"%lf", number];
    int indexOfDecimalPoint = 0;
    int indexOfLastNonZeroNumber = 0;
    int lastIndex = (int)[preEditedDoubleString length] - 1;
    for (int i = 0; i < [preEditedDoubleString length]; i++)
        if ([preEditedDoubleString characterAtIndex:i] == '.')
            indexOfDecimalPoint = i;
    for (int i = indexOfDecimalPoint; i < [preEditedDoubleString length]; i++)
        if ([preEditedDoubleString characterAtIndex:i] != '0')
            indexOfLastNonZeroNumber = i;
    int zerosLength = lastIndex - indexOfLastNonZeroNumber;
    return [preEditedDoubleString stringByReplacingCharactersInRange:NSMakeRange(indexOfLastNonZeroNumber, zerosLength) withString:@""];
}
-(void)executeOperation: (char)action onValue: (double *)a andValue: (double *)b into:(double *)result
{
    switch (action)
    {
        case '+':
            *result = *a + *b;
            break;
        case '-':
            *result = *a - *b;
            break;
        case 'x':
            *result = *a * *b;
            break;
        case '/':
            *result = *a / *b;
            break;
        default:
            break;
    }
}
-(void)updateVisuals
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.calculatorScreenLbl.text = [self getCurrentNumber];
        [self.view setNeedsDisplay];
    });

}
-(void)assignToCurrentNumber: (NSString *)value
{
    if (self.currentNumber == 'a')
        self.numberA = value;
    else if (self.currentNumber == 'b')
        self.numberB = value;
}
-(NSString *)getCurrentNumber
{
    if (self.currentNumber == 'a')
        return self.numberA;
    else if (self.currentNumber == 'b')
        return self.numberB;
    return nil;
}
-(void)switchNumbers
{
    if (self.currentNumber == 'a')
    {
        self.numberB = @"0";
        self.currentNumber = 'b';
    }
    else if (self.currentNumber == 'b')
    {
        self.currentNumber = 'a';
        self.numberB = @"";
    }
}
-(void)initializeMyHateForApple
{
    if(!frickApple)
        frickApple = @{@"1":@1,
                       @"2":@2,
                       @"3":@3,
                       @"4":@4,
                       @"5":@5,
                       @"6":@6,
                       @"7":@7,
                       @"8":@8,
                       @"9":@9,
                       @"0":@0,
                       @".":@10,
                       @"+/-":@11,
                       @"AC":@12,
                       @"%":@13,
                       @"+":@14,
                       @"-":@15,
                       @"x":@16,
                       @"/":@17,
                       @"=":@18};
}
@end