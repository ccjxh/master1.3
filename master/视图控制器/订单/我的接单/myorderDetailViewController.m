//
//  myorderDetailViewController.m
//  master
//
//  Created by jin on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myorderDetailViewController.h"
#import "replyViewController.h"

@interface myorderDetailViewController ()
@property(nonatomic)UITextField*tx;//终止合同理由
@property(nonatomic)AMPopTip*popTip;
@end

@implementation myorderDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPop];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createPop{

    [[AMPopTip appearance] setFont:[UIFont fontWithName:@"Avenir-Medium" size:12]];
    
    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.popTip.tapHandler = ^{
        NSLog(@"Tap!");
    };
    self.popTip.dismissHandler = ^{
        NSLog(@"Dismiss!");
    };


}


-(void)send{
    
    NSString*urlString=[self interfaceFromString: interface_myOrderDetail];
    [self requestWithUrl:urlString];
}


-(void)requestWithUrl:(NSString*)urlString{
    [self flowShow];
    if (!self.dataArray) {
        self.dataArray=[[NSMutableArray alloc]init];
    }
    [self.dataArray removeAllObjects];
    if (!self.skillArray) {
        self.skillArray=[[NSMutableArray alloc]init];
    }
    [self.skillArray removeAllObjects];
    NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            MasterDetailModel*model=[[MasterDetailModel alloc]init];
            self.currentDict=[[dict objectForKey:@"entity"]objectForKey:@"masterOrder"] ;
            self.billStatus=[[self.currentDict objectForKey:@"orderStatus"] integerValue];
             self.billsNo=[[[dict objectForKey:@"entity"] objectForKey:@"masterOrder"] objectForKey:@"billsNo"];
            self.recommentStatus=[[self.currentDict objectForKey:@"commentStatus"] integerValue];
            starModel*model1=[[starModel alloc]init];
            [model1 setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
            if ([[model1.reply objectForKey:@"content"] length]!=0) {
                self.replystatus=1;
            }
            self.bespeak=[NSString stringWithFormat:@"%@到%@",[self.currentDict objectForKey:@"startTime"],[self.currentDict objectForKey:@"finishTime"]];
            //备注
            starModel*starsmodel=[[starModel alloc]init];
            [starsmodel setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
            self.masterID=starsmodel.id;
            self.remark=[self.currentDict objectForKey:@"remark"];
             self.reasonofrefuse=[[[dict objectForKey:@"entity"] objectForKey:@"masterOrder"] objectForKey:@"rejectReason"];
            for (NSInteger j=0; j<[[self.currentDict objectForKey:@"skills"] count]; j++) {
                skillModel*tempModel=[[skillModel alloc]init];
                NSArray*tempArray=[self.currentDict objectForKey:@"skills"];
                [tempModel setValuesForKeysWithDictionary:tempArray[j]];
                [self.skillArray addObject:tempModel];
            }
            [self.billArray addObject: [self.currentDict objectForKey:@"billsNo"]];
            [self.billArray addObject:[self.currentDict objectForKey:@"createTime"]];
            [self.billArray addObject:@""];
            [self.billArray addObject:[self.currentDict objectForKey:@"contract"]];
            [self.billArray addObject:[self.currentDict objectForKey:@"phone" ]];
            [self.billArray addObject:[NSString stringWithFormat:@"%@到%@",[self.currentDict objectForKey:@"startTime"],[self.currentDict objectForKey:@"finishTime"]]];
            [self.billArray addObject:[self.currentDict objectForKey:@"region"]];
            if (![self.currentDict objectForKey:@"remark"]) {
                [self.billArray addObject:@""];
            }else{
                [self.billArray addObject:[self.currentDict objectForKey:@"remark"]];
                
            }
            [self.billArray addObject:@""];

            
            
            [model setValuesForKeysWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"masterOrder"] objectForKey:@"buyer"]];
            [self.dataArray addObject:model];
        }
        [self finish];
        [self.tableview reloadData];
        self.tableview.backgroundColor=COLOR(221, 221, 221, 1);
        [self flowHide];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
    }];
}



-(void)finish{
    
    starModel*model=[[starModel alloc]init];
    [model setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
    
    if (model.reply.allKeys.count>1) {
       
        UIView*view1=(id)[self.view viewWithTag:100];
        if (view1) {
            [view1 removeFromSuperview];
        }
        
    }else{
    
    self.tableview.tableFooterView=[self setupFoot];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.recommentStatus==1) {
        
        return 3;
    }
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==1) {
        return 9;
    }
    if (section==2) {
        starModel*model=[[starModel alloc]init];
        [model setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
        if ([[model.reply objectForKey:@"content"] length]!=0) {
            return 2;
        }
        return 1;
    }

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSArray*Array=@[@"订单编号",@"创建时间",@"订单状态",@"联系人",@"联系电话",@"预约时间",@"地点",@"备注",@"技能要求"];
    switch (indexPath.section) {
        case 0:
        {
            peopleDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"peopleDetailTableViewCell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"peopleDetailTableViewCell" owner:nil options:nil]lastObject];
            }
            if (self.dataArray.count!=0) {
                MasterDetailModel*model=self.dataArray[0];
                [cell upDateWithModel:model];
            }
            cell.userInteractionEnabled=NO;
            cell.selected=NO;
            return cell;
        }
            break;
        case 1:{
            
            commendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"commendTableViewCell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"commendTableViewCell" owner:nil options:nil]lastObject];
            }
            
            cell.name.text=Array[indexPath.row];
            if (self.billArray.count!=0) {
                
                cell.content.text=self.billArray[indexPath.row];
                
            }
            
            NSString*content;
            if ([self.orderStatus isEqualToString:@"已拒绝"]==YES) {
                content=[NSString stringWithFormat:@"%@(%@)",self.orderStatus,self.reasonofrefuse];
                
            }else{
                content=self.orderStatus;
            }
            if (content==nil) {
                content=@"已完结";
            }
            
            if (indexPath.row==2) {
                
                cell.content.text=content;
                
            }
            
            cell.selectionStyle=0;
            if (indexPath.row==8) {
                
                return  [self getSkillCellWithTableview:tableView];
                
            }
            return cell;
        }
            break;

            
        case 2:{
            if (indexPath.row==0) {
                recommendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                if (!cell) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"recommendTableViewCell" owner:nil options:nil] lastObject];
                }
                if (self.recommentStatus==1) {
                    starModel*model=[[starModel alloc]init];
                    [model setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
                    cell.model=model;
                    cell.userInteractionEnabled=NO;
                    [cell reloadData];
                }
                return cell;
            }
            if (indexPath.row==1) {
                replyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"replyTableViewCell"];
                if (!cell) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"replyTableViewCell" owner:nil options:nil]lastObject];
                }
                starModel*model=[[starModel alloc]init];
                [model setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
                cell.name.layer.cornerRadius=5;
                cell.selectionStyle=0;
                cell.name.text=[NSString stringWithFormat:@"%@回复:%@",[model.reply objectForKey:@"user"],[model.reply objectForKey:@"content"]];
                cell.name.backgroundColor=COLOR(228, 228, 228, 1);
                return cell;
            }
            
        }
            break;

        default:
            break;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        return 115;
        
    }
    else if (indexPath.section==1){
        
        if (indexPath.row==8) {
            return [self accountSkill];
        }
        if (self.billArray.count!=0) {
            
            if ([self accountStringHeightFromString:self.billArray[indexPath.row] Width:SCREEN_WIDTH-110]<=17) {
                return 30;
            }else{
                
                return [self accountStringHeightFromString:self.billArray[indexPath.row] Width:SCREEN_WIDTH-110]+13;
            }
            
        }
        return 30;
    }else if (indexPath.section==2){
    
        if (indexPath.row==0) {
            NSArray*skillTemp;
            if ([[self.currentDict objectForKey:@"orderComment"] count]!=0) {
                skillTemp =[[self.currentDict objectForKey:@"orderComment"][0] objectForKey:@"acceptSkill"];
            }
            NSString*skillString;
            for (NSInteger i=0; i<skillTemp.count; i++) {
                if (i==0) {
                    skillString=[NSString stringWithFormat:@"认可的技能:%@",[skillTemp[i] objectForKey:@"name"]];
                }else{
                    skillString=[NSString stringWithFormat:@"%@、%@",skillString,[skillTemp[i] objectForKey:@"name"]];
                }
            }
            CGFloat skillHeight=[self accountStringHeightFromString:skillString Width:SCREEN_WIDTH-70-15]+5;
            NSString*temp=[[self.currentDict objectForKey:@"orderComment"][0] objectForKey:@"content"];
            CGFloat height=skillHeight+45;
            if (height<60) {
                height=60;
            }
            CGFloat contentHeight;
            contentHeight=[self accountStringHeightFromString:temp Width:SCREEN_WIDTH-20];
            if (contentHeight<35) {
                contentHeight=35;
            }
            
            if ([(NSArray*)([[self.currentDict objectForKey:@"orderComment"][0] objectForKey:@"picCase"]) count]%4==0) {
                return ([(NSArray*)([[self.currentDict objectForKey:@"orderComment"][0] objectForKey:@"picCase"]) count]/4)*45+height+15+contentHeight;
            }
            else{
                return ([(NSArray*)([[self.currentDict objectForKey:@"orderComment"][0] objectForKey:@"picCase"]) count]/4+1)*45+height+15+contentHeight;
            }
        }
        if (indexPath.row==1) {
            starModel*model=[[starModel alloc]init];
            [model setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
            return [self accountStringHeightFromString:[model.reply objectForKey:@"content"] Width:SCREEN_WIDTH-150]+10;
            }
        
    }
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath*path=[NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:path];
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            if ([self.orderStatus isEqualToString:@"已拒绝"]==YES) {
                self.popTip.popoverColor = [UIColor colorWithRed:0.95 green:0.65 blue:0.21 alpha:1];
                
                [self.popTip showText:self.reasonofrefuse direction:AMPopTipDirectionUp maxWidth:SCREEN_WIDTH-100 inView:self.tableview fromFrame:cell.frame];
            }
        }
    }
}


-(CGFloat)accountPic{
    starModel*model=[[starModel alloc]init];
    [model setValuesForKeysWithDictionary:[self.currentDict objectForKey:@"orderComment"][0]];
    if (model.picCase.count%4==0) {
        return model.picCase.count/4*45;
    }
    else{
        return (model.picCase.count/4+1)*45;
        
    }
    
}


-(UIView*)setupFoot{
    
    UIView*view=(id)[self.view viewWithTag:100];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.tag=100;
    
    switch (self.billStatus) {
       case 1:
            self.orderStatus=@"接受";
            break;
            case 2:
            self.orderStatus=@"等待对方确认完工";
            break;
        case 3:
            self.orderStatus=@"已拒绝";
            break;
        case 4:
            if (self.recommentStatus==2) {
                self.orderStatus=@"等待对方评价";
            }else{
                self.orderStatus=@"待回复";
            }
            break;
        case 5:
            self.orderStatus=@"已终结";
            break;
        default:
            break;
    }

    NSArray*array=@[@"拒绝",@"终止合同"];
    NSString*title;
    if (self.billStatus==1) {
        switch (self.billStatus) {
            case 1:
                title=array[0];
                break;
                case 2:
                title=array[1];
                break;
            default:
                break;
        }
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, 80, 30)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        button.layer.borderColor=[UIColor orangeColor].CGColor;
        button.layer.borderWidth=1;
        button.layer.cornerRadius=5;
        [button addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    self.statusButton=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, SCREEN_WIDTH-60, 30)];
    if (self.billStatus==2||self.billStatus==1) {
        self.statusButton.frame=CGRectMake(120, 5, SCREEN_WIDTH-150, 30);
    }
    if (self.billStatus==2) {
        self.statusButton.frame=CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH-150)/2, 5, SCREEN_WIDTH-150, 30);
    }
    self.statusButton.backgroundColor=[UIColor orangeColor];
    self.statusButton.layer.cornerRadius=5;
    [self.statusButton setTitle:self.orderStatus forState:UIControlStateNormal];
    [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.statusButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.statusButton addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.statusButton];
    return view;
}


-(void)reply:(UIButton*)button{
    self.isNetWorkRefer=YES;
    self.isNetWorkRefer=YES;
    if (self.block) {
        self.block(self.isNetWorkRefer);
    }
    if ([button.titleLabel.text isEqualToString:@"接受"]==YES) {
        [self flowShow];
       NSString* urlString=[self interfaceFromString:interface_accept];
        NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"已接受" duration:1 position:@"center" Finish:^{
                    [self send];
                }];
                [self popWithnimation:self.navigationController];
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
            [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
        }];
    }
    if ([button.titleLabel.text isEqualToString:@"待回复"]==YES) {
    replyViewController*rvc=[[replyViewController alloc]initWithNibName:@"replyViewController" bundle:nil];
    rvc.dataArray=self.dataArray;
    rvc.masterID=self.masterID;
    rvc.id=self.id;
    [self pushWinthAnimation:self.navigationController Viewcontroller:rvc];
    }
}

-(void)refuse:(UIButton*)button{
    self.isNetWorkRefer=YES;
    if (self.block) {
        self.block(self.isNetWorkRefer);
    }
    NSString*urlString;
    if ([button.titleLabel.text isEqualToString:@"拒绝"]==YES) {
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
        CGRect welcomeLabelRect = contentView.bounds;
        welcomeLabelRect.origin.y = 20;
        welcomeLabelRect.size.height = 20;
        UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
        UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
        welcomeLabel.text = @"请填写拒绝的理由!";
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
        _tx.layer.borderColor=[[UIColor whiteColor]CGColor];
        _tx.layer.cornerRadius=7;
        _tx.layer.borderWidth=1;
        _tx.placeholder=@"在这里输入内容";
        [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _tx.backgroundColor=contentView.backgroundColor;
        _tx.textColor=[UIColor whiteColor];
        [contentView addSubview:_tx];
        CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
        txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
        txBounce.size.height=30;
        
        UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
        button.frame=CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height+10);
        button.backgroundColor=contentView.backgroundColor;
        button.layer.borderColor=[[UIColor whiteColor]CGColor];
        button.layer.borderWidth=1;
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(changeDEsscribe:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        
        [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
        
        
    }
    
    if ([button.titleLabel.text isEqualToString:@"终止合同"]==YES) {
        //终止合同操作
        [self scanfInforDic];
    }
    
}


-(void)scanfInforDic{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"请填写终止的理由!";
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
    _tx.layer.borderColor=[[UIColor whiteColor]CGColor];
    _tx.layer.cornerRadius=7;
    _tx.layer.borderWidth=1;
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
    button.tag=30;
    [button addTarget:self action:@selector(changeDEsscribe:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}


-(void)changeDEsscribe:(UIButton*)button{
    if (_tx.text.length==0) {
        UIAlertView*alertive=[[UIAlertView alloc]initWithTitle:@"信息提示" message:@"拒绝理由未填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertive show];
        return;
    }

    if (button.tag==30) {
       [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_stopWork];
    NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"opinion":_tx.text};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"已终止" duration:1 position:@"center" Finish:^{
                [self send];
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        }];
    }else{
    
    NSString* urlString=[self interfaceFromString:interface_refuse];
        NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"opinion":_tx.text};
        
        
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            
            
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                [self.view makeToast:@"已拒绝" duration:1 position:@"center" Finish:^{
                    [self send];
                }];
            }];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    }
    
}




-(void)send:(UIButton*)button{
    
    if ([button.titleLabel.text isEqualToString:@"取消"]==YES) {
        [_messageView removeFromSuperview];
    }
    else{
        
        
        if (_tv.text.length==0) {
            [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
            return;
        }
        NSString*urlString=[self interfaceFromString:interface_refuse];
        NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"opinion":self.tv.text};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self popWithnimation:self.navigationController];
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
        }];
    
    }

}


//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    if (self.skillArray.count==0) {
        cell.textLabel.text=@"该用户暂时木有技能";
        cell.textLabel.textColor=COLOR(228, 228, 228, 1);
        return cell;
    }
    cell.textLabel.text=nil;
    UIView*view=(id)[self.view viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    for (NSInteger i=0; i<self.skillArray.count; i++) {
        skillModel*model=self.skillArray[i];
        NSInteger width=(SCREEN_WIDTH-20-30)/4;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 5+i/4*30, width-10, 30)];
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.layer.cornerRadius=10;
        label.textAlignment=NSTextAlignmentCenter;
        label.numberOfLines=0;
        label.textColor=[UIColor whiteColor];
        label.layer.backgroundColor=[UIColor orangeColor].CGColor;
        label.layer.borderColor=[UIColor orangeColor].CGColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        
        [view addSubview:label];
        cell.selectionStyle=0;
        [cell.contentView addSubview:view];
    }
    return cell;
}
-(CGFloat)accountSkill{
    
    if (self.skillArray.count==0) {
        return 50;
    }
    else
    {
        if (self.skillArray.count%4==0) {
            
            return self.skillArray.count/4*35+10;
    }
        else
        {
            return (self.skillArray.count/4+1)*35+10;
        }
    }
}


@end
