//
//  replyViewController.m
//  master
//
//  Created by jin on 15/6/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "replyViewController.h"

@interface replyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@end

@implementation replyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.separatorStyle=0;
    self.tableview.backgroundColor=COLOR(228, 228, 228, 1);
    [self customNV];
    [self requestToken];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}




- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



-(NSString*)requestToken{
    
    __block NSString*token;
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    return token;
}





-(void)customNV{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)confirm{
    if (_tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }
    NSDictionary*dict=@{@"content":_tx.text,@"order.id":[NSString stringWithFormat:@"%lu",self.id],@"parent.id":[NSString stringWithFormat:@"%lu",self.masterID]};
    if (self.token) {
        dict=@{@"content":_tx.text,@"order.id":[NSString stringWithFormat:@"%lu",self.id],@"parent.id":[NSString stringWithFormat:@"%lu",self.masterID],@"token":self.token};
    }
    NSString*urlString=[self interfaceFromString:interface_commentReply];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"回复成功" duration:1 position:@"center" Finish:^{
               
                [self popWithnimation:self.navigationController];
                
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self.view makeToast:@"挡墙网络不好" duration:1 position:@"center" Finish:^{
            
        }];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            peopleDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"peopleDetailTableViewCell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"peopleDetailTableViewCell" owner:nil options:nil]lastObject];
            }
            if (_dataArray.count!=0) {
                MasterDetailModel*model=_dataArray[0];
                [cell upDateWithModel:model];
            }
            cell.userInteractionEnabled=NO;
            cell.selected=NO;
            return cell;
        }
            break;
        case 1:{
            return [self getTableviewcell:tableView];
        
        }
            break;
        default:
            break;
    }
    
    UITableViewCell*cell;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=COLOR(228, 228, 228, 1);
    return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 110;
    }else{
        return 80;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
    
        return 20;
    }

}
-(UITableViewCell*)getTableviewcell:(UITableView*)tableview{
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell"];
    }
    UIView*view=(id)[self.view viewWithTag:10];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=10;
    view.userInteractionEnabled=YES;
   _tx=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, cell.bounds.size.height-20)];
    _tx.delegate=self;
    _tx.textColor=[UIColor blackColor];
    _tx.font=[UIFont systemFontOfSize:15];
    [_tx addSubview:[self createPlace]];
    [view addSubview:_tx];
    cell.selectionStyle=0;
    [cell.contentView addSubview:view];
    return cell;
}

-(void)textViewDidChange:(UITextView *)textView{
    UILabel*label=(id)[self.view viewWithTag:56];
       if (textView.text.length>0) {
        [label removeFromSuperview];
    }else{
        if (label) {
            
        }else{
            
            [textView addSubview:[self createPlace]];
        }
    }
}


-(UILabel*)createPlace{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 100, 20)];
    label.textColor=COLOR(228, 229, 228, 1);
    label.text=@"请输入内容";
    label.userInteractionEnabled=YES;
    label.font=[UIFont systemFontOfSize:15];
    label.tag=56;
    return label;
}

@end
