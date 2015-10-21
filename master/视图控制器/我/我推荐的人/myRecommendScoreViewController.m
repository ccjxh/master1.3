//
//  myRecommendScoreViewController.m
//  master
//
//  Created by jin on 15/6/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myRecommendScoreViewController.h"

@interface myRecommendScoreViewController ()<StarRatingViewDelegate>
@property(nonatomic)NSMutableArray*valueArray;
@end

@implementation myRecommendScoreViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)initData{

    if (!self.dataArray ) {
        self.dataArray=[[NSMutableArray alloc]initWithObjects:@"基本信息",@"评星",@"推荐说明",@"认可的技能", nil];
    }
    if (!self.pictureArray) {
        self.pictureArray=[[NSMutableArray alloc]init];
    }
    [self.pictureArray addObject:@""];
    if (!self.picDataArray) {
        self.picDataArray=[[NSMutableArray alloc]init];
    }
    if (self.skillArray) {
        self.skillArray=[[NSMutableArray alloc]init];
    }
    
    if (!_valueArray) {
        _valueArray=[[NSMutableArray alloc]init];
    }
}

-(void)confirm{

    NSString*urlString=[self interfaceFromString:interface_resignRecommend];
    if (self.tx.text.length==0) {
        [self.view makeToast:@"请填写评论内容" duration:1 position:@"center"];
        return;
    }
    if (_valueArray.count==0) {
        NSDictionary*parent=@{@"content":self.tx.text,@"scores[0].category.id":@"17",@"scores[1].category.id":@"18",@"scores[2].category.id":@"19",@"requestRecommend.id":[NSString stringWithFormat:@"%lu",self.orderID],@"scores[0].score":[NSString stringWithFormat:@"%lu",self.skillScore],@"scores[1].score":[NSString stringWithFormat:@"%lu",self.serviceScore],@"scores[2].score":[NSString stringWithFormat:@"%lu",self.peopleScore]};
        [self flowShow];
        [[httpManager share]POST:urlString parameters:parent success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            
            
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self flowHide];
                [self.view makeToast:@"评价成功" duration:1 position:@"center" Finish:^{
                    
                    [self.navigationController popToViewController:self.vc animated:YES];
                }];
            
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
            
        }];
    }else{
        [self flowShow];
        NSString*temp;
        for (NSInteger i=0; i<_valueArray.count; i++) {
            skillModel*model=_valueArray[i];
            if (i==0) {
                
                temp=[NSString stringWithFormat:@"%lu",model.id];
            }else{
            
                temp=[NSString stringWithFormat:@"%@,%lu",temp,model.id];
            }
        }
        NSDictionary*parent=@{@"content":self.tx.text,@"scores[0].category.id":@"17",@"scores[1].category.id":@"18",@"scores[2].category.id":@"19",@"requestRecommend.id":[NSString stringWithFormat:@"%lu",self.orderID],@"scores[0].score":[NSString stringWithFormat:@"%lu",self.skillScore],@"scores[1].score":[NSString stringWithFormat:@"%lu",self.serviceScore],@"scores[2].score":[NSString stringWithFormat:@"%lu",self.peopleScore],@"acceprSkill":temp};
            [[httpManager share]POST:urlString parameters:parent success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
                
                
                
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self flowHide];
                [self.view makeToast:@"推荐成功" duration:1 position:@"center" Finish:^{
                    [self.navigationController popToViewController:self.vc animated:YES];
                    return ;
                }];
                
            }else{
                [self flowHide];
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
                
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
        }];
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 3;
    }
    return 1;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            peopleDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CELL"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"peopleDetailTableViewCell" owner:nil options:nil]lastObject];
            }
            if (self.dataArray.count!=0) {
//                MasterDetailModel*model=self.model;
                [cell upDateWithModel:self.dModel];
            }
            cell.userInteractionEnabled=NO;
            cell.selected=NO;
            return cell;
            
        }
            break;
        case 1:{
            if (indexPath.row==0) {
                return [self getStars:tableView Indexpath:indexPath];
            }
            else if (indexPath.row==1){
                return [self getStars:tableView Indexpath:indexPath];
            }
            else{
                return [self getStars:tableView Indexpath:indexPath];
            }
        }
            break;
        case 2:{
            
            return [self getContent:tableView];
        }
            break;
        case 3:{
            return [self getSkillCellWithTableview:tableView];
        }
          
            break;
        default:
            break;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"ce"];
    return cell;
}

-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    cell.selectionStyle=0;
    UIView*view=(id)[self.view viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    if (_valueArray.count==0) {
            UILabel*tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 20)];
            tempLabel.text=@"点击添加技能";
            tempLabel.textColor=COLOR(228, 228, 228, 1);
            tempLabel.font=[UIFont systemFontOfSize:15];
            tempLabel.userInteractionEnabled=NO;
            tempLabel.enabled=YES;
            [view addSubview:tempLabel];
        [cell.contentView addSubview:view];
        return cell;
    }
    
    for (NSInteger i=0; i<_valueArray.count; i++) {
        skillModel*model=_valueArray[i];
        NSInteger width=(SCREEN_WIDTH-20-30)/4;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 5+i/4*30, width-10, 25)];
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.layer.cornerRadius=10;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor lightGrayColor];
        if (model.isSelect==YES) {
            label.textColor=COLOR(29, 90, 172, 1);
            label.layer.borderColor=[COLOR(29, 90, 172, 1)CGColor];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=NO;
        label.userInteractionEnabled=YES;
        [view addSubview:label];
        
    }
   
    [cell.contentView addSubview:view];
    return cell;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=(id)[self.view viewWithTag:600];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor=COLOR(221, 221, 221, 1);
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 30)];
    label.text=self.dataArray[section];
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=[UIColor blackColor];
    [view addSubview:label];
    return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
    
        return 30;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==3) {
        skillSelectViewController*svc=[[skillSelectViewController alloc]init];
        svc.Array=self.skillArray;
        svc.skillArray=^(NSMutableArray*array){
            [self.skillArray removeAllObjects];
            for (NSInteger i=0; i<array.count; i++) {
                skillModel*model=array[i];
                [_valueArray addObject:model];
            }

            NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:3];
            NSArray*temp=@[path];
            [self.tableview reloadRowsAtIndexPaths:temp withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 110;
            break;
            case 1:
        {
            return 30;
        }
            break;
            case 2 :
        {
            return 70;
        }
            break;
            case 3:
        {
            return [self accountSkill];
        }
            break;
        default:
            break;
    }

    return 0;
}


/**计算技能高度*/
-(CGFloat)accountSkill{
    
    if (_valueArray.count==0) {
        return 50;
    }
    else
    {
        if (_valueArray.count%4==0) {
            
            return _valueArray.count/4*30+10;
        }
        else
        {
            return (_valueArray.count/4+1)*30+10;
        }
    }
}


-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
    
    if (view.tag==20) {
        self.skillScore=(NSInteger)(score/2*10);
        
        
    }else if (view.tag==21){
        self.serviceScore=(NSInteger)(score/2*10);
        
        
    }else if (view.tag==22){
        self.peopleScore=(NSInteger)(score/2*10);
    }
}

@end
