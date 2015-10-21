//
//  recommendViewController.m
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "recommendViewController.h"
#import "listRootTableViewCell.h"
#import "opinionViewController.h"

@interface recommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)UITextField*tx;//意见输出框
@property(nonatomic)peoplr*valueModel; //选中的数据模型
@end

@implementation recommendViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{

    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    
    [_dataArray removeAllObjects];
    NSString*urlString=[self interfaceFromString:interface_findRecommend];
    NSDictionary*dict=@{@"pageNo":[NSString stringWithFormat:@"%lu",(long)_currentPage],@"pageSize":@"10",@"applyPost":[NSString stringWithFormat:@"%@",@"4"]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary*tempDict=array[i];
                peoplr*model=[[peoplr alloc]init];
                [model setValuesForKeysWithDictionary:[tempDict objectForKey:@"user"]];
                [_dataArray addObject:model];
                
            }

        }
        
        [self.tableview reloadData];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    listRootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"listRootTableViewCell" owner:nil options:nil]lastObject];
    }
    peoplr*p=_dataArray[indexPath.row];
    cell.type=1;
    cell.model=p;
    cell.typeLabel.text=@"项目经理";
    cell.selectionStyle=0;
    [cell reloadData];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.valueModel=_dataArray[indexPath.row];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"欢迎填写、修改服务介绍!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    infoLabelRect.size.height-=40;
    _tx=[[UITextField alloc]initWithFrame:infoLabelRect];
    _tx.font=[UIFont systemFontOfSize:16];
    _tx.placeholder=@"在这里输入内容";
    [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor whiteColor];
    [contentView addSubview:_tx];
    
    
    CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
    txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
    txBounce.size.height=30;
    UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
    button.backgroundColor=contentView.backgroundColor;
    button.layer.borderColor=[[UIColor whiteColor]CGColor];
    button.layer.borderWidth=1;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(changeDEsscribe) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
    
    
//    opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
//    peoplr*p=_dataArray[indexPath.row];
//    ovc.model=p;
//    ovc.opinionBlock=^(NSString*value){
//    };
//    ovc.modalPresentationStyle=UIModalPresentationFormSheet;
//    ovc.modalTransitionStyle=2;
//    [self.navigationController presentViewController:ovc animated:YES completion:nil];
}


-(void)changeDEsscribe{
    [self flowShow];
    if (_tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }else{
        NSString*urlString=[self interfaceFromString:interface_sendRecommend];
        NSDictionary*dict=@{@"remark":_tx.text,@"receiver.id":[NSString stringWithFormat:@"%lu",(long)self.valueModel.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                self.isNetWorkRefer=YES;
                if (self.block) {
                    self.block(self.isNetWorkRefer);
                }
                [self flowHide];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[KGModal sharedInstance]hideAnimated:YES];
            }else{
                [self flowHide];
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[KGModal sharedInstance]hideAnimated:YES];
                }];
                
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
            [[KGModal sharedInstance]hideAnimated:YES];
        }];
    }

}

@end
