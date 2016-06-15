//
//  CBLineChartView.h
//  MyCarSDK
//
//  Created by C-Bee on 16/4/29.
//  Copyright © 2016年 huweitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CBLineChartView : UIView

@property (nonatomic, copy) NSArray *dataArr;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr;

@end