//
//  orderDetailOrderViewController.m
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "orderDetailOrderViewController.h"

@interface orderDetailOrderViewController ()<UIAlertViewDelegate>
@property(nonatomic)AMPopTip*popTip;
@end

@implementation orderDetailOrderViewController


-(void) viewWillAppear:(BOOL)animated
{
    if (!self.billArray) {
        self.billArray=[[NSMutableArray alloc]init];
    }
    [self send];
}


-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    
}

-(void)update{
    [self send];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self receiveNotice];
    self.tableview.backgroundColor=COLOR(228, 228, 228, 1);
    [self CreateFlow];
    [self createPop];
    // Do any additional setup after loading the view from its nib.
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
    
    
  

}

-(void)refuseShow:(NSString*)message{
    
//        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"已终止"     contentText:message leftButtonTitle:nil rightButtonTitle:@"确定"];
//        [alert show];
//        alert.rightBlock = ^() {
//        NSLog(@"right button clicked");
//        };
//        alert.dismissBlock = ^() {
//        NSLog(@"Do something interesting after dismiss block");
//    };
}

-(void)requestWithUrl:(NSString*)urlString{

    [self.billArray removeAllObjects];
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
            _currentDict=[[dict objectForKey:@"entity"]objectForKey:@"masterOrder"];
            [self.billArray addObject: [_currentDict objectForKey:@"billsNo"]];
            [self.billArray addObject:[_currentDict objectForKey:@"createTime"]];
            [self.billArray addObject:@""];
            [self.billArray addObject:[_currentDict objectForKey:@"contract"]];
            [self.billArray addObject:[_currentDict objectForKey:@"phone" ]];
            [self.billArray addObject:[NSString stringWithFormat:@"%@到%@",[self.currentDict objectForKey:@"startTime"],[self.currentDict objectForKey:@"finishTime"]]];
            [self.billArray addObject:[_currentDict objectForKey:@"region"]];
            if (![_currentDict objectForKey:@"remark"]) {
                [self.billArray addObject:@""];
            }else{
                [self.billArray addObject:[_currentDict objectForKey:@"remark"]];

            }
            [self.billArray addObject:@""];
            
            self.billStatus=[[_currentDict objectForKey:@"orderStatus"] integerValue];
            self.recommentStatus=[[_currentDict objectForKey:@"commentStatus"] integerValue];
            starModel*model1=[[starModel alloc]init];
            if ([[_currentDict objectForKey:@"orderComment"] count]!=0) {
                [model1 setValuesForKeysWithDictionary:[_currentDict objectForKey:@"orderComment"][0]];
                if ([[model1.reply objectForKey:@"content"] length]!=0) {
                    self.replystatus=1;
                }
            }
          _bespeak=[NSString stringWithFormat:@"%@到%@",[_currentDict objectForKey:@"startTime"],[_currentDict objectForKey:@"finishTime"]];
            //备注
            starModel*starsmodel=[[starModel alloc]init];
            if ([[_currentDict objectForKey:@"orderComment"] count]!=0) {
                [starsmodel setValuesForKeysWithDictionary:[_currentDict objectForKey:@"orderComment"][0]];
                self.masterID=starsmodel.id;
            }
        _remark=[_currentDict objectForKey:@"remark"];
            //技能
        for (NSInteger j=0; j<[[_currentDict objectForKey:@"skills"]  count]; j++) {
                skillModel*tempModel=[[skillModel alloc]init];
                NSArray*tempArray=[_currentDict objectForKey:@"skills"] ;
                [tempModel setValuesForKeysWithDictionary:tempArray[j]];
                [_skillArray addObject:tempModel];
            }
            self.billsNo=[[[dict objectForKey:@"entity"] objectForKey:@"masterOrder"] objectForKey:@"billsNo"];
            [model setValuesForKeysWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"masterOrder"] objectForKey:@"master"]];
            self.reasonofrefuse=[[[dict objectForKey:@"entity"] objectForKey:@"masterOrder"] objectForKey:@"rejectReason"];
            [self.dataArray addObject:model];
        }
        [self finish];
        [self.tableview reloadData];
        self.tableview.backgroundColor=COLOR(221, 221, 221, 1);
        [self flowHide];
        if (self.reasonofrefuse!=nil) {
            [self refuseShow:self.reasonofrefuse];
            
            }
        
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_recommentStatus==1) {
        return 3;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==2) {
        starModel*model=[[starModel alloc]init];
        NSArray*Array=[_currentDict objectForKey:@"orderComment"];
        if (Array.count>0) {
            [model setValuesForKeysWithDictionary:Array[0]];
        if ([[model.reply objectForKey:@"content"] length]!=0) {
            return 2;
        }
        return 1;
        }
    }
        
    if (section==0) {
        return 1;
    }else if (section==1)
    {
        return 9;
    }
    return 2;
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
            if (_dataArray.count!=0) {
                MasterDetailModel*model=_dataArray[0];
                [cell upDateWithModel:model];
            }
            cell.userInteractionEnabled=NO;
            cell.selected=NO;
            return cell;
        }
            break;
        case 1:
        {
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
            case 2:
        {
        
            if (indexPath.row==0) {
                recommendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                if (!cell) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"recommendTableViewCell" owner:nil options:nil] lastObject];
                }
                
                if (_recommentStatus==1) {
                    starModel*model=[[starModel alloc]init];
                    [model setValuesForKeysWithDictionary:[_currentDict objectForKey:@"orderComment"][0]];
                    cell.model=model;
                    cell.vc=self;
                    cell.userInteractionEnabled=YES;
                    cell.selectionStyle=0;
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
                [model setValuesForKeysWithDictionary:[_currentDict objectForKey:@"orderComment"][0]];
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
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Acell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1
                                   reuseIdentifier:@"Acell"];
    }
    cell.userInteractionEnabled=NO;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 109;
            break;
        case 1:
        {
            if (indexPath.row==8) {
                return [self accountSkill];
            }
            if (self.billArray.count!=0) {
                
                if ([self accountStringHeightFromString:self.billArray[indexPath.row] Width:SCREEN_WIDTH-110]<=17) {
                    return 30;
                }else{
                    
                    return [self accountStringHeightFromString:self.billArray[indexPath.row] Width:SCREEN_WIDTH-110]+15;
                }
                
            }
            return 30;
            
        }
            break;
        case 2:
        {
            
            if (indexPath.row==0) {
                NSArray*skillTemp;
                if ([[_currentDict objectForKey:@"orderComment"] count]!=0) {
                skillTemp =[[_currentDict objectForKey:@"orderComment"][0] objectForKey:@"acceptSkill"];
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
                NSString*temp=[[_currentDict objectForKey:@"orderComment"][0] objectForKey:@"content"];
                CGFloat height=skillHeight+45;
                if (height<65) {
                    height=65;
                }
                CGFloat contentHeight;
                contentHeight=[self accountStringHeightFromString:temp Width:SCREEN_WIDTH-20];
                if (contentHeight<35) {
                    contentHeight=35;
                }
                if ([[[_currentDict objectForKey:@"orderComment"][0] objectForKey:@"picCase"] count]%4==0) {
                    return contentHeight+([[[_currentDict objectForKey:@"orderComment"][0] objectForKey:@"picCase"] count]/4)*50+height+15;
                    
                }
                else{
                    return contentHeight+([[[_currentDict objectForKey:@"orderComment"][0] objectForKey:@"picCase"] count]/4+1)*50+height+15;
                }
            }
            if (indexPath.row==1) {
                starModel*model=[[starModel alloc]init];
                [model setValuesForKeysWithDictionary:[_currentDict objectForKey:@"orderComment"][0]];
                return [self accountStringHeightFromString:[model.reply objectForKey:@"content"] Width:SCREEN_WIDTH-85]+10;
            }
        }
        default:
            break;
    }
    return 80;
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 20;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==4) {
        return nil;
    }
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=COLOR(228, 228, 228, 1);
    if (section==5) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        label.text=@"评价";
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:15];
        [view addSubview:label];
    }
    return view;
}



-(UITableViewCell*)getbeskeak:(UITableView*)tableview{
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell2"];
    }
    UIView*view=(id)[self.view viewWithTag:105];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=105;
    UILabel*name=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 20)];
    name.text=@"预约时间";
    name.textColor=[UIColor lightGrayColor];
    name.font=[UIFont systemFontOfSize:16];
    [view addSubview:name];
    UILabel*content=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-210, 0, 220, 20)];
    content.text=_bespeak;
    content.textColor=[UIColor lightGrayColor];
    content.font=[UIFont systemFontOfSize:16];
    [view addSubview:content];
    [cell.contentView addSubview:view];
    cell.selected=NO;
    cell.userInteractionEnabled=NO;
    return cell;
    
}


-(UITableViewCell*)getRemark:(UITableView*)tableview{
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell2"];
    }
    UIView*view=(id)[self.view viewWithTag:10];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=10;
    UILabel*name=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    name.text=@"备注";
    name.textColor=[UIColor lightGrayColor];
    name.font=[UIFont systemFontOfSize:16];
    [view addSubview:name];
    UILabel*content=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-210, 10, 220, 20)];
    content.text=_remark;
    content.textColor=[UIColor lightGrayColor];
    content.font=[UIFont systemFontOfSize:16];
    [view addSubview:content];
    [cell.contentView addSubview:view];
    cell.selected=NO;
    cell.userInteractionEnabled=NO;
    return cell;
}



-(CGFloat)accountPic{
    starModel*model=[[starModel alloc]init];
    [model setValuesForKeysWithDictionary:[_currentDict objectForKey:@"orderComment"][0]];
    if (model.picCase.count%4==0) {
        return model.picCase.count/4*40;
    }
    else{
        return (model.picCase.count/4+1)*45;
    
    }

}


-(UIView*)createButton{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.tag=101;
    self.statusButton=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, SCREEN_WIDTH-60, 30)];
    self.statusButton.backgroundColor=[UIColor orangeColor];
    self.statusButton.layer.cornerRadius=10;
    [self.statusButton setTitle:_orderStatus forState:UIControlStateNormal];
    [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.statusButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.statusButton addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.statusButton];
    return view;
}


-(void)order:(UIButton*)button{
    if ([button.titleLabel.text isEqualToString:@"工程完工"]==YES) {
        UIAlertView*alertive=[[UIAlertView alloc]initWithTitle:@"操作提示" message:@"是否确定已完工" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertive.tag=80;
        [alertive show];
    }else if ([button.titleLabel.text isEqualToString:@"评价"]==YES){
    //评价界面操作。。。。。
        recommendStarsViewController*vcv=[[recommendStarsViewController alloc]initWithNibName:@"recommendStarsViewController" bundle:nil];
        vcv.model=_dataArray[0];
        vcv.id=self.id;
        [self pushWinthAnimation:self.navigationController Viewcontroller:vcv];
    }

}


-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    cell.textLabel.text=@" 技能";
    if (_skillArray.count==0) {
        cell.detailTextLabel.text=@"该用户暂时没有填写技能";
        cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor=COLOR(228, 228, 228, 1);
        return cell;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.detailTextLabel.text=@"";
    UIView*view=(id)[self.view viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, cell.frame.size.height)];
    view.tag=31;
    for (NSInteger i=0; i<_skillArray.count; i++) {
        skillModel*model=_skillArray[i];
        NSInteger width=(SCREEN_WIDTH-20-30)/4;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 5+i/4*40, width-10, 30)];
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.numberOfLines=0;
        label.layer.cornerRadius=10;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.layer.backgroundColor=[UIColor orangeColor].CGColor;
        label.layer.borderColor=[UIColor orangeColor].CGColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        [view addSubview:label];
        view.userInteractionEnabled=YES;
        [cell.contentView addSubview:view];
    }
    cell.selectionStyle=0;
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

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self flowShow];
        NSString*urlString=[self interfaceFromString: interface_finish];
        NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"提交成功" duration:1 position:@"center" Finish:^{
                    [self send];
                }];
            }else
            {
                [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
            }
            [self flowHide];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
        }];
    }
}

@end
