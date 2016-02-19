//
//  CBLineChartView.m
//  CBLineChart
//
//  Created by C-Bee on 16/2/19.
//  Copyright © 2016年 C-Bee. All rights reserved.
//

#import "CBLineChartView.h"
@implementation CBLineChartView

//x轴的初始坐标
#define beginX 10
//每个数据的横间距
#define dataInterval 43
//底部高
#define footerHeight 30
//顶部高
#define headerHeight 30

#define viewHeight rect.size.height
#define viewWidth rect.size.width
#define chartHeight viewHeight - footerHeight
#define numToY(y) (chartHeight - (chartHeight - headerHeight) * y / _maxValue)
#define beginY numToY([_dataArr[0] integerValue])

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr maxValue: (NSInteger)maxValue {
    self = [self initWithFrame:frame];
    _dataArr = [NSArray arrayWithArray:dataArr];
    _maxValue = maxValue;
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /*画阴影*/
    float nowX = beginX;
    float nowY = beginY;
    CGContextMoveToPoint(ctx, nowX, nowY);
    
    for (int i = 1; i < _dataArr.count; ++i) {
        nowX += dataInterval;
        nowY = numToY([_dataArr[i] floatValue]);
        CGContextAddLineToPoint(ctx, nowX, nowY);
        
    }
    //闭合折线
    CGContextAddLineToPoint(ctx, nowX, chartHeight);
    CGContextAddLineToPoint(ctx, beginX, chartHeight);
    //填充颜色
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.5);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    
    /*画圆点*/
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    nowX = beginX;
    nowY = numToY([_dataArr[0] integerValue]);
    CGContextAddArc(ctx, nowX, nowY, 2, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    for (int i = 1; i < _dataArr.count; ++i) {
        nowX += dataInterval;
        nowY = numToY([_dataArr[i] integerValue]);
        CGContextAddArc(ctx, nowX, nowY, 2, 0, M_PI * 2, 0);
        CGContextStrokePath(ctx);
    }
    
    /*画折线*/
    nowX = beginX;
    nowY = numToY([_dataArr[0] integerValue]);
    for (int i = 1; i < _dataArr.count; ++i) {
        CGContextMoveToPoint(ctx, nowX + 1, nowY + 1);
        nowX += dataInterval;
        nowY = numToY([_dataArr[i] integerValue]);
        CGContextAddLineToPoint(ctx, nowX - 1, nowY - 1);
        CGContextStrokePath(ctx);
    }
    
    /*画基准线*/
    //下实线
    CGContextMoveToPoint(ctx, beginX - 5, beginY + 5);
    CGContextAddLineToPoint(ctx, self.frame.size.width - 5, beginY + 5);
    CGContextStrokePath(ctx);
    //上实线
    CGContextMoveToPoint(ctx, beginX - 5, numToY(_maxValue));
    CGContextAddLineToPoint(ctx, self.frame.size.width - 5, numToY(_maxValue));
    CGContextStrokePath(ctx);
    //中间虚线
    CGFloat lineStyle[] = {10,10};
    CGContextSetLineDash(ctx, 0, lineStyle, 2);
    CGContextMoveToPoint(ctx, beginX - 5, numToY(_maxValue / 2));
    CGContextAddLineToPoint(ctx, self.frame.size.width - 5, numToY(_maxValue / 2));
    CGContextStrokePath(ctx);
    
    
    /*坐标文字*/
    NSDictionary *fontStyle = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSArray *wordArr = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日", nil];
    nowX = beginX - 5;
    for (int i = 0; i < wordArr.count; ++i) {
        [wordArr[i] drawAtPoint:CGPointMake(nowX, beginY + 10) withAttributes:fontStyle];
        nowX += dataInterval;
    }
    
    /*其它文字*/
    [[NSString stringWithFormat:@"%ld", _maxValue / 2] drawAtPoint:CGPointMake(beginX - 5, numToY(_maxValue / 2) - 15) withAttributes:fontStyle];
    float sum = 0;
    for (int i = 0; i < _dataArr.count; ++i) {
        sum += [_dataArr[i] floatValue];
    }
    [[NSString stringWithFormat:@"总步数: %.0f", sum] drawAtPoint:CGPointMake(beginX, numToY(_maxValue) - 15) withAttributes:fontStyle];
    
    
}

@end