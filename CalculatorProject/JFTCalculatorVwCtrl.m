//
//  JFTCalculatorVwCtrl.m
//  CalculatorProject
//
//  Created by hyperactive hi-tech ltd on 27/02/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTCalculatorVwCtrl.h"
#import "JFTCalculator.h"
static NSDictionary *frickApple;
@interface JFTCalculatorVwCtrl ()
@property (nonatomic, strong) JFTCalculator* logicalCalculator;
@end

@implementation JFTCalculatorVwCtrl
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.logicalCalculator = [JFTCalculator new];
    self.calculatorScreenLbl.text = [self.logicalCalculator getCurrentNumber];
}
-(IBAction)onButtonTouch:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    int buttonCode = [frickApple[senderButton.titleLabel.text] intValue];
    [self setACTitle: buttonCode];
    [self.logicalCalculator handleUserInput: senderButton.titleLabel.text];
    self.calculatorScreenLbl.text = [self removeUnnecessaryZeroes: [[self.logicalCalculator getCurrentNumber] doubleValue]];
    [self updateVisuals];
}

-(NSString *)removeUnnecessaryZeroes: (double)number
{
    if (number == 0)
        return [NSString stringWithFormat:@"%d", 0];
    NSString *preEditedDoubleString = [NSString stringWithFormat:@"%lf", number];
    int indexOfDecimalPoint = 0;
    int indexOfLastNonZeroNumber = 0;
    int countBeforeZero = 0;
    for (int i = 0; i < [preEditedDoubleString length]; i++)
        if ([preEditedDoubleString characterAtIndex:i] == '.')
            indexOfDecimalPoint = i;
    for (int i = indexOfDecimalPoint; i < [preEditedDoubleString length]; i++)
        if ([preEditedDoubleString characterAtIndex:i] != '0')
            indexOfLastNonZeroNumber = i;
    for (int i = indexOfDecimalPoint; i < indexOfLastNonZeroNumber; i++)
        countBeforeZero++;
    if (countBeforeZero > 0)
        return [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@%@",@"%.", [NSString stringWithFormat:@"%d",countBeforeZero],@"lf"], number];
    else if (countBeforeZero == 0)
        return [NSString stringWithFormat:@"%d", (int)number];
    else
        return @"Error";
}
-(void)updateVisuals
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view setNeedsDisplay];
    });

}
-(void)setACTitle: (int)buttonCode
{
    if (buttonCode == 12)
    {
        [self.acBtn setTitle:@"AC" forState:UIControlStateNormal];
        [self.acBtn setTitle:@"AC" forState:UIControlStateFocused];
        [self.acBtn setTitle:@"AC" forState:UIControlStateSelected];
    }
    else
    {
        [self.acBtn setTitle:@"C" forState:UIControlStateNormal];
        [self.acBtn setTitle:@"C" forState:UIControlStateFocused];
        [self.acBtn setTitle:@"C" forState:UIControlStateSelected];
    }
}
@end
