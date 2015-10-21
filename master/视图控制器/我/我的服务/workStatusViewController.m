//
//  workStatusViewController.m
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "workStatusViewController.h"

@interface workStatusViewController ()

@end

@implementation workStatusViewController
{

    UIView *_tagView;   //
    UIDatePicker *_DatePickerView;  //
    UIView *_titleView;
    NSString*date;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    NSArray*array=@[@"空闲",@"繁忙"];
    for (NSInteger i=0; i<2; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-30+SCREEN_WIDTH/2*i, 60, 60, 30)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor orangeColor];
        button.layer.cornerRadius=10;
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=10+i;
        [self.view addSubview:button];
    }

}


-(void)onclick:(UIButton*)button{
    switch (button.tag) {
        case 10:
        {
            if (self.workStatusBlock) {
                self.workStatusBlock(0,@"",nil);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        
        }
            break;
        case 11:{
            [self initPickerView];
        
        }
            break;
        default:
            break;
    }


}


#pragma mark-pickview相关
-(void) initPickerView
{
    
    _tagView=[[UIView alloc]initWithFrame:self.view.bounds];
    _tagView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.4];
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    _titleView.backgroundColor=[UIColor whiteColor];
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0, 20, 80, 40);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelPickerView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(self.view.bounds.size.width-80,20, 80, 40);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(donePickData) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_titleView addSubview:leftButton];
    [_titleView addSubview:rightButton];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2+1, self.view.bounds.size.width, 0.5)];
    _DatePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2+90, self.view.bounds.size.width, self.view.bounds.size.height/2-90)];
    _DatePickerView.backgroundColor=[UIColor whiteColor];
    NSDate *date=[NSDate dateWithTimeInterval:3600*24 sinceDate:[NSDate date]];
    _DatePickerView.date=date;
    _DatePickerView.minimumDate=date;
    _DatePickerView.datePickerMode=UIDatePickerModeDate;
    [_tagView addSubview:_titleView];
    [_DatePickerView addSubview:lineView];
    [_tagView addSubview:_DatePickerView];
    [[UIApplication  sharedApplication].keyWindow addSubview:_tagView];
    
}



// 确定按钮点击事件
-(void)donePickData{
    //        //将nsdate类型转换成nsstring
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy/MM/dd"];
    NSDate*temp=[NSDate dateWithTimeInterval:0 sinceDate:_DatePickerView.date];
    NSInteger time=[[df stringFromDate:temp] integerValue]/3600/24;
    if ([[df stringFromDate:temp] integerValue]%(3600*24)!=0) {
        time++;
    }
       
    if (self.workStatusBlock) {
        self.workStatusBlock(1,[NSString stringWithFormat:@"%lu",time],[df stringFromDate:_DatePickerView.date]);
    }
    [_tagView removeFromSuperview];
    [_DatePickerView removeFromSuperview];
    [_titleView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//取消按钮点击事件
-(void) cancelPickerView
{
    [_tagView removeFromSuperview];
    [_DatePickerView removeFromSuperview];
    [_titleView removeFromSuperview];
    
}

@end
