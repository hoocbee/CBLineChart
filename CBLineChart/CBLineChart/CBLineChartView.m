//
//  CBLineChartView.m
//  MyCarSDK
//
//  Created by C-Bee on 16/4/29.
//  Copyright © 2016年 huweitao. All rights reserved.
//

#import "CBLineChartView.h"

@interface CBLineChartView () {
    NSInteger indexOfMax, indexOfMin;
    CGFloat maxValue, minValue;
    CGFloat nowX, nowY;     //ctx当前的x,y坐标
}

@end

//每个数据的横间距
#define dataInterval ((self.frame.size.width - beginX * 2) / (self.dataArr.count - 1))
//底部高
#define footerHeight (self.frame.size.height * 0.15)
//顶部高
#define headerHeight (self.frame.size.height * 0.15)
//表格高度
#define chartHeight (self.frame.size.height - footerHeight)
//y数值转y坐标值
#define numToY(num) (chartHeight - (chartHeight - headerHeight) * (num) / (maxValue))
//x轴的初始坐标
#define beginX 15
//y轴的初始坐标
#define beginY numToY([self.dataArr[0] floatValue])

#define BGColor [UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:1.0 alpha:0.12]
#define LineColor [UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:1.0 alpha:0.50]
#define FontColor [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define RectColor [UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:1.0 alpha:1.0]

@implementation CBLineChartView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr
{
    if (self = [super initWithFrame:frame]) {
        self.dataArr = dataArr;
    }
    return self;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray new];
    }
    return _dataArr;
}

- (void)drawRect:(CGRect)rect {
    if (self.dataArr && self.dataArr.count > 0) {
        maxValue = [self.dataArr[0] floatValue];
        minValue = [self.dataArr[0] floatValue];
    }
    for (int i = 0; i < self.dataArr.count; ++i) {
        CGFloat y = [self.dataArr[i] floatValue];
        if (y > maxValue) {
            maxValue = y;
            indexOfMax = i;
        }
    }
    for (int i = 0; i < self.dataArr.count; ++i) {
        CGFloat y = [self.dataArr[i] floatValue];
        if (y < minValue) {
            minValue = y;
            indexOfMin = i;
        }
    }

    NSString *maxStr = [NSString stringWithFormat:@"%.1f", maxValue];
    NSString *minStr = [NSString stringWithFormat:@"%.1f", minValue];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画曲线
    CGContextSetStrokeColorWithColor(ctx, LineColor.CGColor);
    CGContextSetFillColorWithColor(ctx, BGColor.CGColor);
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    nowX = beginX;
    nowY = beginY;
    CGFloat lastY = nowY;                   //上一个Y坐标点
    [aPath moveToPoint:CGPointMake(nowX, nowY)];
    for (int i = 1; i < self.dataArr.count; ++i) {
        nowX += dataInterval;
        nowY = numToY([self.dataArr[i] floatValue]);
        CGPoint controlPoint1 = CGPointMake(nowX - dataInterval / 2, lastY);
        CGPoint controlPoint2 = CGPointMake(nowX - dataInterval / 2, nowY);
        [aPath addCurveToPoint:CGPointMake(nowX, nowY) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        lastY = nowY;
    }
    [aPath stroke];
    //填充阴影
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    [aPath addLineToPoint:CGPointMake(nowX, chartHeight)];
    [aPath addLineToPoint:CGPointMake(beginX, chartHeight)];
    [aPath closePath];
    [aPath fill];
    
    /*抹掉两个小圆*/
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //最小圆
    nowX = beginX + dataInterval * indexOfMin;
    nowY = numToY([self.dataArr[indexOfMin] floatValue]);
    CGContextAddArc(ctx, nowX, nowY, 2, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    //最大圆
    nowX = beginX + dataInterval * indexOfMax;
    nowY = numToY([self.dataArr[indexOfMax] floatValue]);
    CGContextAddArc(ctx, nowX, nowY, 2, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    /*添加两个小圆圈*/
    CGContextSetStrokeColorWithColor(ctx, LineColor.CGColor);
    //最小圆
    nowX = beginX + dataInterval * indexOfMin;
    nowY = numToY([self.dataArr[indexOfMin] floatValue]);
    CGContextAddArc(ctx, nowX, nowY, 2, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    //最大圆
    nowX = beginX + dataInterval * indexOfMax;
    nowY = numToY([self.dataArr[indexOfMax] floatValue]);
    CGContextAddArc(ctx, nowX, nowY, 2, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    /*最大最小值*/
    NSDictionary *fontStyle = @{NSFontAttributeName: [UIFont systemFontOfSize:8], NSForegroundColorAttributeName: [UIColor whiteColor]};
    //最小值
    nowX = beginX + dataInterval * indexOfMin - (minStr.length - 1) * 3;
    nowY = numToY([self.dataArr[indexOfMin] floatValue]) - 15;
    CGContextSetFillColorWithColor(ctx, RectColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(nowX - 1, nowY, (minStr.length - 1) * 5.5 + 3, 10));
    [[NSString stringWithFormat:@"%.1f", minValue]drawAtPoint:CGPointMake(nowX, nowY) withAttributes:fontStyle];
    //最大值
    nowX = beginX + dataInterval * indexOfMax - (maxStr.length - 1) * 3;
    nowY = numToY([self.dataArr[indexOfMax] floatValue]) - 15;
    CGContextSetFillColorWithColor(ctx, RectColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(nowX - 1, nowY, (maxStr.length - 1) * 5.5 + 3, 10));
    [[NSString stringWithFormat:@"%.1f", maxValue]drawAtPoint:CGPointMake(nowX, nowY) withAttributes:fontStyle];

    /*坐标文字*/
    fontStyle = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: FontColor};
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"d"];
    nowX = beginX - 8 + dataInterval * (self.dataArr.count - 1);
    for (int i = 0; i < self.dataArr.count; ++i) {
        NSString *aDate = [formatter stringFromDate:date];
        NSString *dateStr = [NSString stringWithFormat:@"%@日", aDate];
        [dateStr drawAtPoint:CGPointMake(nowX, chartHeight) withAttributes:fontStyle];
        date = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24 * 3600)];
        nowX -= dataInterval;
    }

    /*顶部*/
    float sum = 0;
    for (int i = 0; i < self.dataArr.count; ++i) {
        sum += [self.dataArr[i] floatValue];
    }
    NSString *topWord = [NSString stringWithFormat:@"里程    日平均 %.2f    累计 %.2fkm", sum / self.dataArr.count, sum];
    [topWord drawAtPoint:CGPointMake(beginX, 0) withAttributes:fontStyle];
}

@end