//
//  ViewController.m
//  CBLineChart
//
//  Created by C-Bee on 16/2/19.
//  Copyright © 2016年 C-Bee. All rights reserved.
//

#import "ViewController.h"
#import "CBLineChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *dataArr = [NSArray arrayWithObjects:@"0", @"300", @"120", @"350", @"150", @"30", @"480", nil];
    CBLineChartView *lcView = [[CBLineChartView alloc]initWithFrame:CGRectMake(10, 50, 300, 250) dataArray:dataArr];
    lcView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lcView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

