# CBLineChart
简洁美观的折线图

//初始化数据数组<br />
NSArray *dataArr = [NSArray arrayWithObjects:@"40", @"300", @"120", @"350", @"150", @"30", @"480", nil];<br />
//初始化折线图<br />
CBLineChartView *lcView = [[CBLineChartView alloc]initWithFrame:CGRectMake(10, 50, 300, 250) dataArray:dataArr];<br />
//设置背景色<br />
lcView.backgroundColor = [UIColor whiteColor];<br />
//加入到主视图,DONE!<br />
[self.view addSubview:lcView];<br />

