//
//  JFTEquation.m
//  CalculatorProject
//
//  Created by hyperactive hi-tech ltd on 16/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTEquation.h"
@interface JFTEquation()
@property NSMutableArray* privateNumbers;
@property NSMutableArray* privateOperations;
@end
@implementation JFTEquation
-(instancetype)init
{
    return [self initWithFirstNumber: @"0"];
}
-(instancetype)initWithFirstNumber:(NSString *)number
{
    if (self = [super init])
    {
        self.privateNumbers = [NSMutableArray new];
        self.privateOperations = [NSMutableArray new];
        [self.privateNumbers addObject: number];
    }
    return self;
}
-(NSArray *)Numbers
{
    return [self.privateNumbers copy];
}
-(NSArray *)Operations
{
    return [self.privateOperations copy];
}
-(void)addOperation:(NSString *)operations
{
    [self.privateOperations addObject: operations];
}
-(void)addNumber: (NSString*)number
{
    [self.privateNumbers addObject: number];
}
-(NSString *)description
{
    NSMutableString *description = self.privateNumbers[0];
    for (int i = 0; i < self.privateOperations.count; i++)
    {
        [self addNewOperationToDescription: description operationAtIndex: i];
    }
    return [NSString stringWithString: description];
}
-(void)addNewOperationToDescription: (NSMutableString*)description operationAtIndex: (int)index
{
    if (index == 0)
        [description appendFormat: @"%@ %@", self.privateOperations[index], self.privateNumbers[index + 1]];
    else
    {
        [description insertString: @"(" atIndex: 0];
        [description appendString: @")"];
        [description appendFormat: @"%@ %@", self.privateOperations[index], self.privateNumbers[index + 1]];
    }
}
-(NSString *)solve
{
    double numberA = 0.0;
    double numberB = 0.0;
    double result = 0.0;
    for (int i = 0; i < self.privateOperations.count; i++)
    {
        if (i == 0)
        {
            numberA = [self.privateNumbers[i] doubleValue];
            numberB = [self.privateNumbers[i+1] doubleValue];
            [self executeOperation: self.privateOperations[i] onNumberA: &numberA andNumberB: &numberB intoResult: &result];
        }
        else
        {
            numberA = result;
            numberB = [self.privateNumbers[i+1] doubleValue];
            [self executeOperation: self.privateOperations[i] onNumberA: &numberA andNumberB: &numberB intoResult: &result];
        }
    }
    return [NSString stringWithFormat: @"%lf", result];
}
-(void)executeOperation: (NSString*)operation onNumberA: (double*)a andNumberB: (double*)b intoResult: (double*)result
{
    switch ([operation characterAtIndex: 0])
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
@end
