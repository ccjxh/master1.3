//
//  PayViewController.m
//  master
//
//  Created by jin on 15/6/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PayViewController
{
    NSMutableArray*_dataArray;
    UITextField*_tx;
    payModel*valueModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self CreateFlow];
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
    NSMutableArray*array=[[dataBase share]findAllPay];
    for (NSInteger i=0; i<array.count; i++) {
        payModel*model=array[i];
        [_dataArray addObject:model];
    }
    
    [self.tableview reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    payModel*model=_dataArray[indexPath.row];
    cell.textLabel.text=model.remark;
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    valueModel=_dataArray[indexPath.row];
    if ([valueModel.name isEqualToString:@"面议"]==YES) {
        
        if (self.type==1) {
           
            if (self.valuechange) {
                self.valuechange(nil,valueModel);
            }
            [self popWithnimation:self.navigationController];
            return;
        }
        
        //面议处理时间
        [self flowShow];
        NSString*urlString=[self interfaceFromString:interface_updateExpectPay];
        NSDictionary*dict=@{@"expectPay":@"0",@"payTypeId":[NSString stringWithFormat:@"%lu",valueModel.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self flowHide];
                [self popWithnimation:self.navigationController];
                if (_expectBlock) {
                    _expectBlock();
                }
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
        }];
        

        
    }else{
        valueModel=_dataArray[indexPath.row];
        [self createPay];
    
    
    }


}


-(void)createPay{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 110)];
    contentView.backgroundColor=[UIColor whiteColor];
    [KGModal sharedInstance].modalBackgroundColor=[UIColor whiteColor];
    [KGModal sharedInstance].showCloseButton=NO;
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor clearColor];
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
    _tx.font=[UIFont systemFontOfSize:15];
    _tx.frame=CGRectMake(_tx.frame.origin.x+70, _tx.frame.origin.y-10, _tx.frame.size.width-150, 35);
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(_tx.frame.origin.x, _tx.frame.origin.y+_tx.frame.size.height, _tx.frame.size.width, 1)];
    view.backgroundColor=COLOR(74, 166, 216, 1);
    [contentView addSubview:view];
    [_tx becomeFirstResponder];
//    _tx.layer.borderColor=[[UIColor whiteColor]CGColor];
//    _tx.layer.borderWidth=1;
    _tx.delegate=self;
    _tx.textAlignment=NSTextAlignmentRight;
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor blackColor];
    _tx.keyboardType=UIKeyboardTypeDecimalPad;
    [contentView addSubview:_tx];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(_tx.frame.size.width+85, _tx.frame.origin.y, 80, 30)];
    label.text=valueModel.name;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:15];
    [contentView addSubview:label];
    NSArray*array=@[@"确定",@"取消",];
    for (NSInteger i=0; i<array.count; i++) {
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(contentView.frame.size.width-140+i*70, _tx.frame.size.height+welcomeLabel.frame.size.height+25, 60, 30)];
    button.backgroundColor=contentView.backgroundColor;
    [button setTitle:array[i] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    }
//    label.frame.origin.x= CGRectGetMaxY(infoLabelRect)+5;
    [[KGModal sharedInstance]showWithContentView:contentView andAnimated:YES];
}




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (temp.length>7) {
        
        return NO;
    }
    
    NSArray*array=[temp componentsSeparatedByString:@"."];
    if (array.count>1) {
        if ([array[1] length]>2) {
            return NO;
        }
    }

    if ([array[0] length]>4) {
        return NO;
    }
    if ([array[0] integerValue]>1000) {
        return NO;
    }
    return YES;
}


//- (void)textFieldDidChange:(UITextField *)textField
//{
//   


    
//    NSArray*Array=[_tx.text componentsSeparatedByString:@"."];
//    if (Array.count>1) {
//        if ([Array[1] length]>2) {
//            _tx.text = [_tx.text substringToIndex:2];
//
//        }
//    }
//    
//        if (textField.text.length > 20) {
//            
//            textField.text = [textField.text substringToIndex:20];
//        
//    }
    
//}



-(void)confirm:(UIButton*)button{
    [_tx resignFirstResponder];
    
    
    if ([button.titleLabel.text isEqualToString:@"取消"]==YES) {
        return;
    }
    
    
    
    if (_tx.text.length==0) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"操作提示" message:@"薪资不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
        
    if ([button.titleLabel.text isEqualToString:@"确定"]==YES) {
        
        if (self.type==1) {
             [[KGModal sharedInstance]hideAnimated:YES];
            if (self.valuechange) {
                self.valuechange(_tx.text,valueModel);
            }
            [self popWithnimation:self.navigationController];
            return;
        }
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_updateExpectPay];
    NSDictionary*dict=@{@"expectPay":_tx.text,@"payTypeId":[NSString stringWithFormat:@"%lu",valueModel.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self flowHide];
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
               
                [self popWithnimation:self.navigationController];
                if (_expectBlock) {
                    _expectBlock();
                }
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        }];
    }else{
    
       
    }
}




@end
