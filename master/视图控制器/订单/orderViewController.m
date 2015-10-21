//
//  orderViewController.m
//  master
//
//  Created by jin on 15/5/18.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "orderViewController.h"
#import "myorderBillViewController.h"
#import "mynextBillViewController.h"

@interface orderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)DAPagesContainer*pagesContainer;

@end

@implementation orderViewController

-(void) viewWillAppear:(BOOL)animated
{
   
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
  
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI{

    self.leftButton.layer.cornerRadius=15;
    self.leftButton.backgroundColor=COLOR(255, 255, 255, 1);
    self.rightButton.layer.cornerRadius=15;
    self.rightButton.backgroundColor=COLOR(255, 255, 255, 1);
    NSArray*Array=@[@"我的下单",@"我的接单"];
    for (NSInteger i=0; i<2; i++) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(self.leftButton.frame.size.width/2-40, 55, 80, 20)];
        label.text=Array[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=COLOR(228, 228, 228, 1);
        label.font=[UIFont systemFontOfSize:16];
        if (i==0) {
            [self.leftButton addSubview:label];
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(self.rightButton.frame.size.width/2-20, 10,40,40)];
            imageview.image=[UIImage imageNamed:@"项目经理.png"];
//            imageview.userInteractionEnabled=YES;
            [self.leftButton addSubview:imageview];
        }else{
            [self.rightButton addSubview:label];
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(self.leftButton.frame.size.width/2-20, 10,40,40)];
            imageview.image=[UIImage imageNamed:@"工头.png"];
            [self.rightButton addSubview:imageview];
        }
        self.view.backgroundColor=COLOR(244, 243, 245, 1);
        //        label.userInteractionEnabled=YES;
        label.enabled=NO;
    }

}


-(void)initData{


    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray addObject:@"我的下单"];
    [_dataArray addObject:@"我的接单"];
    [self.tableview reloadData];

}


//我的下单
- (IBAction)myorder:(id)sender {
    myorderBillViewController*ovc=[[myorderBillViewController alloc]init];
    ovc.hidesBottomBarWhenPushed=YES;
    ovc.title=@"我的下单";
    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
}

//我的接单
- (IBAction)myAccept:(id)sender {
    
    mynextBillViewController*nvc=[[mynextBillViewController alloc]init];
    nvc.hidesBottomBarWhenPushed=YES;
    nvc.title=@"我的接单";
    [self pushWinthAnimation:self.navigationController Viewcontroller:nvc];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell"] ;
        
    }
    cell.textLabel.text=_dataArray[indexPath.row];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
          }
    else if(indexPath.row==0){
       
    }
}

@end
