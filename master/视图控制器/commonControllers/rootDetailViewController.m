//
//  rootDetailViewController.m
//  master
//
//  Created by jin on 15/5/20.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "rootDetailViewController.h"
#import "custonView.h"
#import "OrderDetailViewController.h"

@interface rootDetailViewController ()
@property(nonatomic)UITableView*informationView;
@property(nonatomic)UITableView*projectView;
@property(nonatomic)UITableView*serviceView;
@property(nonatomic)NSMutableArray*dataArray;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollview;

@end

@implementation rootDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    NSArray*array=@[@"informationView",@"projectView",@"serviceView"];
    for (NSInteger i=0; i<array.count; i++) {
        Class temp=NSClassFromString(array[i]);
        UITableView*tableview=[[temp alloc]initWithFrame:CGRectMake(i*_backScrollview.frame.size.width, 0, _backScrollview.frame.size.width, _backScrollview.frame.size.height)];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.showsHorizontalScrollIndicator=NO;
        tableview.showsVerticalScrollIndicator=NO;
        [_backScrollview addSubview:tableview];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nil;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
