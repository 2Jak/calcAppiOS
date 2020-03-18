//
//  JFTEquation.h
//  CalculatorProject
//
//  Created by hyperactive hi-tech ltd on 16/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFTEquation : NSObject
@property (nonatomic, strong, readonly) NSArray* Numbers;
@property (nonatomic, strong, readonly) NSArray* Operations;
-(instancetype)initWithFirstNumber: (NSString*)number;
-(void)addOperation: (NSString*)operations;
-(void)addNumber: (NSString*)number;
-(NSString*)solve;
@end

NS_ASSUME_NONNULL_END
