//
//  JFTCalculator.h
//  CalculatorProject
//
//  Created by hyperactive hi-tech ltd on 16/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JFTEquation;
@interface JFTCalculator : NSObject
-(NSString*)getCurrentNumber;
-(NSArray*)getAllHistory;
-(JFTEquation*)getHistoryAtIndex: (int)index;
-(void)handleUserInput: (NSString*)buttonTitle;
@end

NS_ASSUME_NONNULL_END
