//
//  ChangeDateViewController.m
//  ZBCloud
//
//  Created by Ky.storm on 14-9-23.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import "ChangeDateViewController.h"
#import "Toast+UIView.h"

@interface ChangeDateViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^changeBlock)(NSString *newDate, BOOL succeed);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) BOOL isChanged;
@end

@implementation ChangeDateViewController

#pragma mark - 系统方法


- (void)dealloc
{
    _changeBlock = nil;
    _tableView = nil;
    _oldDate = nil;
    _datePicker = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(changeDateBack)];
    [self initData];    //初始化数据
    [self initView];    //初始化控件
//    [self creatNavBar];
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //确定按钮
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(commitChanges:)];
    self.navigationItem.rightBarButtonItem = commitButton;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //选择器动画
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *oldDateDate = [dateFormatter dateFromString:_oldDate];
//    [_datePicker setDate:oldDateDate animated:YES];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //        NSString *  locationString=[dateFormatter stringFromDate:senddate];
    _oldDate = [dateFormatter stringFromDate:senddate];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void) creatNavBar
{
    UINavigationBar *bar = [[UINavigationBar alloc]init];
    //    if (ISIOS7) {
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.00&&[UIDevice currentDevice].systemVersion.floatValue<8.0) {
        bar.frame = CGRectMake(0, 0, self.view.bounds.size.height, 84);
    }
    else if ([UIDevice currentDevice].systemVersion.floatValue>=8)
    {
        
        bar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84);
        
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(changeDateBack)];
    
//    UINavigationItem *item = [[UINavigationItem alloc] init];
//    [bar pushNavigationItem:item animated:NO];
//    [self.view addSubview:bar];
//    [bar setBackgroundColor:[UIColor whiteColor]];
//    
//    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, 55, 40)];
//    [bar addSubview:backBtn];
//    [backBtn setBackgroundColor:[UIColor clearColor]];
//    [backBtn setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *rightNavBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 40, 55, 40)];
//    [bar addSubview:rightNavBtn];
//    [rightNavBtn setBackgroundColor:[UIColor clearColor]];
    //    [rightNavBtn addTarget:self action:@selector(rightNavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)changeDateBack{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 私有方法
/**
 @discussion:数据初始化
 */
- (void)initData{
}

/**
 @discussion:视图初始化
 */
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    //时间选择器
    _datePicker = [[UIDatePicker alloc]init];
    NSDate*minDate=[NSDate new];
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    if (self.isEndTime) {
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        minDate=[formatter dateFromString:self.begainTime];
    }
    
    if (!self.isPass) {
        [_datePicker setMinimumDate:minDate];
    }
    if (self.isfuture) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init] ;
        NSInteger unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
        NSDate *date = [NSDate date];
        comps = [calendar components:unitFlags fromDate:date];
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-mm-dd"];
        [_datePicker setMaximumDate:date];
    }
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    [self.view addSubview:_datePicker];
    //约束
    NSMutableArray *constraints = [NSMutableArray array];
    NSArray *tableViewHConrtraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)];
    NSArray *datePickHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_datePicker]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_datePicker)];
    NSArray *tableViewDatePickerVContranit = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_tableView(>=110)]-[_datePicker(>=80,>=110@1000)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView, _datePicker)];
    
    [constraints addObjectsFromArray:tableViewHConrtraint];
    [constraints addObjectsFromArray:datePickHContraint];
    [constraints addObjectsFromArray:tableViewDatePickerVContranit];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:constraints];
    
//    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13, 64, SCREEN_WIDTH, 30)];
//    label.text=@"工期截止日:";
//    label.textColor=[UIColor blackColor];
//    label.font=[UIFont systemFontOfSize:16];
//    [self.view addSubview:label];
//    if (_isShowMessage) {
//        label.hidden=NO;
//        
//    }else{
//        label.hidden=YES;
//    }
//
    
}

/*!
 * @discussion 选择器响应事件
 */
- (void)datePickerChanged:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birthdayString = [dateFormatter stringFromDate:picker.date];
    _oldDate = birthdayString;
    
    
    //刷新视图
    [_tableView reloadData];
}

/*!
 * @discussion 提交按钮响应事件
 */
- (void)commitChanges:(id)sender{
    
    if (self.blockDateValue)
    {
        self.blockDateValue(_oldDate);
        [self.navigationController popViewControllerAnimated:YES];
    }

//    DDLogVerbose(@"提交更改");
   
    _isChanged = YES;
    
    // 反馈事件响应
//    if (_changeBlock && _isChanged) {
//        _changeBlock(_oldDate, YES);
//    }
    
    
    
}

/*!
 * @discussion 设置原始时间
 */
- (void)setOldDate:(NSString *)oldDate{
    _oldDate = oldDate;
    if (!_oldDate || [_oldDate isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _oldDate = [dateFormatter stringFromDate:[NSDate date]];
    }
}
#pragma mark - 公开方法
/*!
 * @discussion 日期更改响应块
 */
- (void)changeDateWithBlock:(void(^)(NSString *newDate, BOOL succeed))block{
    _changeBlock = block;
}

#pragma mark - 委托方法
#pragma mark - UITableViewDatasouece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *birthdayString = _oldDate;
    cell.textLabel.text = birthdayString;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
