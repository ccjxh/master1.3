//
//  dealRecommendViewController.m
//  master
//
//  Created by jin on 15/6/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "dealRecommendViewController.h"
#import "requestModel.h"
#import "peopleDetail4TableViewCell.h"
#import "myRecommendScoreViewController.h"
@interface dealRecommendViewController ()
@property(nonatomic) MasterDetailModel *masterDetailModel;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSMutableArray*serviceArray;
@property(nonatomic)NSMutableArray*skillArray;
@property(nonatomic)NSInteger YPonit;
@property(nonatomic)NSString*cityString;
@property(nonatomic)NSString*townString;
@property(nonatomic)NSInteger totleHeight;
@end

@implementation dealRecommendViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.separatorStyle=0;
    [self requestMasterDetail];
    [self initUI];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    if (_recommendType!=1) {
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    NSArray*Array=@[@"推荐",@"拒绝推荐"];
    for (NSInteger i=0; i<Array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(20+i*(SCREEN_WIDTH-120), 10, 80, 30)];
        button.backgroundColor=[UIColor orangeColor];
        [button setTitle:Array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        button.tag=20+i;
        button.layer.cornerRadius=10;
        [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        }
      self.tableview.tableFooterView=view;
    }
}

-(void)onclick:(UIButton*)button{
    switch (button.tag) {
        case 20:
        {
            myRecommendScoreViewController*mvc=[[myRecommendScoreViewController alloc]initWithNibName:@"recommendStarsViewController" bundle:nil];
            mvc.id=self.id;
            mvc.dataArray=self.dataArray;
            mvc.orderID=self.orderID;
            mvc.vc=self.vc;
            mvc.model=self.dataArray[0];
            [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];
        
        }
            break;
            case 21:
        {
        
            
        }
            break;
            
        default:
            break;
    }


}

#pragma mark - 请求师傅详情
-(void) requestMasterDetail
    {
        if (!_dataArray) {
            _dataArray=[[NSMutableArray alloc]init];
        }
        [_dataArray removeAllObjects];
        if (!_skillArray) {
            _skillArray=[[NSMutableArray alloc]init];
        }
        [_skillArray removeAllObjects];
        if (!_serviceArray) {
            _serviceArray=[[NSMutableArray alloc]init];
        }
        [_serviceArray removeAllObjects];
        
          for (NSInteger i=0; i<[[self.model.service objectForKey:@"serviceRegions"] count]; i++) {
            
              AreaModel*model=[[AreaModel alloc]init];
              model.name=[self.model.service objectForKey:@"serviceRegions"][i];
              [_serviceArray addObject:model];
          }
          
          for (NSInteger i=0; i<[[self.model.service objectForKey:@"servicerSkills"] count]; i++) {
              AreaModel*model=[[AreaModel alloc]init];
                [model setValuesForKeysWithDictionary:[self.model.service objectForKey:@"servicerSkills"][i]];
                [_skillArray addObject:model];
              
            }

            [_dataArray addObject:self.model];
            [self.tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count==0) {
        return 0;
    }
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return 0;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
        {
            peopleDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"peopleDetailTableViewCell"];
            if (cell1 == nil)
            {
                cell1 = [[[NSBundle mainBundle]loadNibNamed:@"peopleDetailTableViewCell" owner:nil options:nil]lastObject];
            }
            //设置cell无点击效果
            _masterDetailModel=self.model;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            [requestModel isNullMasterDetail:self.model];
            [cell1 upDateWithModel:self.model];
            return cell1;
        }
            break;
        case 1:{
        
            return [self getSkillCellWithTableview:tableView];
        }
            break;
            case 2:
        {
            peopleDetaileeTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"peopleDetaileeTableViewCell"];
            if (cell3 == nil)
            {
                cell3 = [[[NSBundle  mainBundle ]loadNibNamed:@"peopleDetaileeTableViewCell" owner:nil options:nil]lastObject];
            }
            //设置cell无点击效果
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            [requestModel isNullMasterDetail:self.model];
            [cell3 upDateWithModel3:self.model];
            return cell3;
            
        }
            break;
            case 3:
        {
            return [self getServiceCellWithTableview:tableView];
        }
            break;
            
        default:
            break;
    }
    UITableViewCell*cell=[[UITableViewCell alloc ]initWithStyle:1 reuseIdentifier:@"CEll"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 110;
        }
            break;
            case 1:
        {
            if (_skillArray.count==0) {
                return 44;
            }
            else{
                return [self accountSkill];
            }
        }
            break;
            case 2:
        {
            return 110;
        }
            break;
            case 3:
        {
            if (_serviceArray.count==0) {
                return 40;
            }else{
                return [self accountservice];
            }
        }
            
        default:
            break;
    }
    return 110;

}

//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    if (_skillArray.count==0) {
        return cell;
    }
    UIView*view=(id)[self.view viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    for (NSInteger i=0; i<_skillArray.count; i++) {
        skillModel*model=_skillArray[i];
        NSInteger width=(SCREEN_WIDTH-20-30)/4;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 5+i/4*30, width-10, 25)];
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.layer.cornerRadius=10;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        [view addSubview:label];
        [cell.contentView addSubview:view];
    }
    return cell;
}
//服务区域
-(UITableViewCell*)getServiceCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CELl"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CELl"];
    }
    
    if (_serviceArray.count==0) {
        cell.textLabel.textColor=[UIColor lightGrayColor];
        return cell;
    }
    _YPonit=10;
    UIView*view=(id)[self.view viewWithTag:30];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=30;
    if (_serviceArray.count==0) {
        UILabel*label=[[UILabel alloc]initWithFrame:view.bounds];
        label.text=@"该用户暂时未添加服务区域";
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor blackColor];
        [view addSubview:label];
    }else{
        UILabel* cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 17)];
        cityLabel.text=@"服务区域";
        cityLabel.textColor=COLOR(228, 228, 228, 1);
        cityLabel.font=[UIFont systemFontOfSize:14];
        cityLabel.numberOfLines=0;
        CGFloat height=[self accountStringHeightFromString:_townString Width:SCREEN_WIDTH-110];
        UILabel*townLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-110-30, height)];
        townLabel.font=[UIFont systemFontOfSize:14];
        townLabel.textColor=COLOR(228, 228, 228, 1);
        townLabel.numberOfLines=0;
        townLabel.text=_townString;
        [view addSubview:cityLabel];
        [view addSubview:townLabel];
        [cell.contentView addSubview:view];
    }
       return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 20;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=COLOR(228, 228, 228, 1);
    
    UILabel*label=[[UILabel alloc]initWithFrame:view.bounds];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:15];
    label.text=@"服务区域";
    
    if (section==3) {
//        [view addSubview:label];
    }
    return view;

}
/**计算服务区域高度*/
-(CGFloat)accountservice{
    
    if (_serviceArray.count==0) {
        return 50;
    }
    _totleHeight=0;
    for (NSInteger i=0; i<_serviceArray.count; i++) {
        AreaModel*model=_serviceArray[i];
        if (i==0) {
            _townString=model.name;
        }else{
            _townString=[NSString stringWithFormat:@"%@、%@",_townString,model.name];
        }
        
    }
    CGFloat height=[self accountStringHeightFromString:_townString Width:SCREEN_WIDTH-110];
    return height+20;
    
}
/**计算技能高度*/
-(CGFloat)accountSkill{
    
    if (_skillArray.count==0) {
        return 50;
    }
    else
    {
        if (_skillArray.count%4==0) {
            
            return self.skillArray.count/4*30+10;
        }
        else
        {
            return (self.skillArray.count/4+1)*30+10;
        }
    }
}





@end
