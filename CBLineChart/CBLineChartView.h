//
//  CBLineChartView.h
//  CBLineChart
//
//  Created by C-Bee on 16/2/19.
//  Copyright © 2016年 C-Bee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CBLineChartView : UIView

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic) NSInteger maxValue;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr maxValue: (NSInteger)maxValue;

@end