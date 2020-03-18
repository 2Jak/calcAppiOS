//
//  JFTCalculator.m
//  CalculatorProject
//
//  Created by hyperactive hi-tech ltd on 16/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTCalculator.h"
#import "JFTEquation.h"
static NSDictionary* titleToCodeForButtons;
static NSDictionary* codeToOperationForButtons;
@interface JFTCalculator()
@property (nonatomic) NSMutableArray* history;
@property (nonatomic) JFTEquation* currentEqation;
@property (nonatomic) NSMutableString* currentNumber;
@property BOOL newInputRequired;
@property BOOL firstOperation;
@end
@implementation JFTCalculator
-(instancetype)init
{
    if (self = [super init])
    {
        self.currentEqation = [JFTEquation new];
        self.history = [NSMutableArray new];
        self.currentNumber = [NSMutableString new];
        self.firstOperation = YES;
        self.newInputRequired = YES;
        [self initializeButtonTitleToButtonCodeDictionary];
        [self initializeButtonCodeToOperationStringDictionary];
    }
    return self;
}
-(NSMutableString *)currentNumber
{
    if ([_currentNumber isEqualToString: @""])
    {
        [_currentNumber appendString: @"0"];
        return _currentNumber;
    }
    else
        return _currentNumber;
}
-(NSArray *)getAllHistory
{
    return [self.history copy];
}
-(NSString *)getCurrentNumber
{
    return [NSString stringWithString: self.currentNumber];
}
-(JFTEquation*)getHistoryAtIndex: (int)index
{
    return [self.history[index] copy];
}
-(void)handleUserInput: (NSString*)buttonTitle
{
    int buttonCode = [titleToCodeForButtons[buttonTitle] intValue];
    if (buttonCode < 10)
    {
        if (self.newInputRequired == YES)
        {
            self.newInputRequired = NO;
            self.currentNumber = [NSMutableString new];
            [_currentNumber appendFormat: @"%d", buttonCode];
        }
        else
            [self.currentNumber appendFormat: @"%d", buttonCode];
    }
    else if (buttonCode == 10)
    {
        if ([self.currentNumber containsString: @"."])
            return;
        else
            [self.currentNumber appendString: @"."];
    }
    else if (buttonCode == 11)
    {
        if ([self.currentNumber containsString: @"-"])
            [self.currentNumber deleteCharactersInRange: NSMakeRange(0, 1)];
        else
            [self.currentNumber insertString: @"-" atIndex: 0];
    }
    else if (buttonCode == 12)
    {
        self.currentEqation = [JFTEquation new];
        self.currentNumber = [NSMutableString new];
    }
    else if (buttonCode == 13)
    {
        self.currentEqation = [[JFTEquation alloc] initWithFirstNumber: self.currentNumber];
        [self.currentEqation addNumber: [NSString stringWithFormat: @"%d", 100]];
        [self.currentEqation addOperation: @"/"];
        self.currentNumber = [NSMutableString new];
        [_currentNumber appendString: [self.currentEqation solve]];
        [self.history addObject: self.currentEqation];
        self.currentEqation = [[JFTEquation alloc] initWithFirstNumber: self.currentNumber];
        self.newInputRequired = YES;
    }
    else if (buttonCode == 18)
    {
        if (self.firstOperation == YES)
        {
            return;
        }
        else
        {
            [self.currentEqation addNumber: self.currentNumber];
            self.currentNumber = [NSMutableString new];
            [_currentNumber appendString: [self.currentEqation solve]];
            [self.history addObject: self.currentEqation];
            self.currentEqation = [[JFTEquation alloc] initWithFirstNumber: self.currentNumber];
            self.newInputRequired = YES;
            self.firstOperation = YES;
        }
    }
    else
    {
        if (self.firstOperation == YES)
        {
            //set current number as first number in the equation and reset current number for recieving another number
            self.currentEqation = [[JFTEquation alloc] initWithFirstNumber: self.currentNumber];
            self.currentNumber = [NSMutableString new];
            //add operation to equation
            [self.currentEqation addOperation: codeToOperationForButtons[[NSNumber numberWithInt: buttonCode]]];
            //reset the equation for faster computation and add the previous answer as the new equation initializer
            self.newInputRequired = YES;
            self.firstOperation = NO;
        }
        else
        {
            //add current number
            [self.currentEqation addNumber: self.currentNumber];
            //reset the equation for faster computation and add the previous answer as the new equation initializer
            self.currentNumber = [NSMutableString new];
            [_currentNumber appendString: [self.currentEqation solve]];
            [self.history addObject: self.currentEqation];
            self.currentEqation = [[JFTEquation alloc] initWithFirstNumber: self.currentNumber];
            //add the new operation to the next equation
            [self.currentEqation addOperation: codeToOperationForButtons[[NSNumber numberWithInt: buttonCode]]];
            //set flag to recieve new input
            self.newInputRequired = YES;
        }
    }
}
-(void)initializeButtonCodeToOperationStringDictionary
{
    if (!codeToOperationForButtons)
    {
        codeToOperationForButtons = @{@11:@"+/-",
                                      @13:@"%",
                                      @14:@"+",
                                      @15:@"-",
                                      @16:@"x",
                                      @17:@"/"};
    }
}
-(void)initializeButtonTitleToButtonCodeDictionary
{
    if(!titleToCodeForButtons)
        titleToCodeForButtons = @{@"1":@1,
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
                       @"C":@12,
                       @"%":@13,
                       @"+":@14,
                       @"-":@15,
                       @"x":@16,
                       @"/":@17,
                       @"=":@18};
}
@end
