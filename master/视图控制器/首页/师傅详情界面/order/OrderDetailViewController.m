//
//  OrderDetailViewController.m
//  master
//
//  Created by xuting on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ProvinceTableViewController.h"  //省份选择界面
#import "ChangeDateViewController.h" //日期选择界面
#import "ModifyInfoViewController.h" //修改页面
#import "AreaModel.h"
#import "MyInfoTableViewCell.h"
#import "requestModel.h"
#import "WechatPayViewController.h" //微信支付页面
#import "CommonAdressController.h"
#import "personalSkillViewController.h"

@interface OrderDetailViewController ()
{
    NSArray *tableArr;
    NSMutableArray *skillArr; //所有技能数组
    NSMutableDictionary *uploadDataDic; //上传的字典
    NSArray *array;
    BOOL isNullOrder; //判断预约的必填项是否都填写
    NSString *skillIds; //存放被选中的技能的id
    NSMutableArray*selectedSkill;//已选择的技能数组
    NSString*begainTime;//开始时间
    NSMutableArray*_skillArray;//当前选择的技能数组
}

@end

@implementation OrderDetailViewController
-(void) viewWillAppear:(BOOL)animated
{
    
//    [self setupMap];
//    self.tabBarController.tabBar.hidden = YES;
    
}


//常用地址
- (IBAction)adress:(id)sender {
    
   
    
}

//地图
- (IBAction)getMap:(id)sender
{
//    [self setupMap];
    
}


#pragma mark - 提交预约
- (IBAction)commitOrder:(id)sender
{
   
       [self isNullOrder];
    
    if (isNullOrder == YES)
    {
        
        [self flowShow];
        [uploadDataDic setObject:[uploadDataDic objectForKey:@"skillIds"] forKey:@"skillIds"];
        [uploadDataDic setObject:self.order_textField.text forKey:@"address"];
        NSString *urlString = [self interfaceFromString:interface_commitOrder];
        [[httpManager share] POST:urlString parameters:uploadDataDic success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary *objDic = (NSDictionary *)responseObject;
            NSDictionary *entityDic = objDic[@"entity"];
            NSDictionary *MasterOrderDTODic = entityDic[@"masterOrder"];
            [self flowHide];
            if ([[objDic objectForKey:@"rspCode"]integerValue] == 200)
            {
                [self.view makeToast:@"恭喜，提交预约成功!" duration:1 position:@"center" Finish:^{
                [self popWithnimation:self.navigationController];
                }];
                
            }
            else
            {
                [self.view makeToast:[objDic objectForKey:@"msg"] duration:2.0f position:@"center"];
            }
            
            /******* 提交预约成功  ******/
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
            [self.view makeToast:@"网络异常，请稍后重试" duration:1 position:@"center"];
        }];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    uploadDataDic = [[NSMutableDictionary alloc]init];
//    [uploadDataDic setObject:[self requestToken] forKey:@"token"];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.city) {
        [uploadDataDic setObject:delegate.city forKey:@"region"];
        [uploadDataDic setObject:delegate.detailAdress forKey:@""];
        NSArray*temp=[delegate.city componentsSeparatedByString:@"-"];
        NSString*str=temp[2];
       AreaModel*model=[[dataBase share]findWithCity:str];
        [uploadDataDic setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"serviceRegion.id"];
    }

    // Do any additional setup after loading the view from its nib.
    isNullOrder = YES;
    skillIds = @"";
    self.model.realName=self.name;
    //注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateRegion:) name:@"order" object:nil];
    self.adressButton.layer.cornerRadius=5;
    skillArr = [NSMutableArray array];
    self.order_tableView.delegate = self;
    self.order_tableView.dataSource = self;
//    self.order_tableView.scrollEnabled = YES;
    tableArr = @[@"所在城市",@"详细地址",@"开始时间",@"结束时间",@"联系人",@"联系电话"];
    //注册自定义cell
    [self.order_tableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyInfoTableViewCell"];
    //设置regionLabel点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regionBtn)];
    self.order_region.userInteractionEnabled = YES;
    [self.order_region addGestureRecognizer:tap];
    
    //设置textField代理
//    self.order_textField.delegate = self;
    
    [self requestSkills];
    
    array = @[@"city",@"detailAdress", @"startTime",@"finishTime",@"contract",@"phone",@"skillIds",@"remark",@"serviceRegion.id",@"address",@"master.id"];
    for (int i=0; i<array.count; i++)
    {
        [uploadDataDic setObject:@"" forKey:array[i]];
    }
    
    //
    [uploadDataDic setObject:[NSNumber numberWithInteger:self.masterId] forKey:@"master.id"];
    if (self.name) {
        [uploadDataDic setObject:self.name forKey:@"contract"];
    }
    else{
    
        [uploadDataDic setObject:self.model forKey:@"phone"];
    }
    
    if (!selectedSkill) {
        selectedSkill=[[NSMutableArray alloc]init];
    }
    [self requestToken];
    
    [self CreateFlow];
}



-(NSString*)requestToken{
    
    
     __block NSString*token;
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
        token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        [uploadDataDic setObject:token forKey:@"token"];
            }

        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    return nil;
    
}




#pragma mark - 地区选择
-(void) regionBtn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    [defaults setObject:@"2" forKey:@"type"];
    [defaults synchronize];
    ProvinceTableViewController *ctl = [[ProvinceTableViewController alloc] init];
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}
#pragma mark - 通知中心方法
-(void) upDateRegion:(NSNotification *)nof
{
    NSDictionary *dict =  nof.object;
    self.order_region.text = [dict objectForKey:@"region"];
    [uploadDataDic setObject:[dict objectForKey:@"region"] forKey:@"region"];
    if ([uploadDataDic objectForKey:@"regionId"]) {
        [uploadDataDic removeObjectForKey:@"regionId"];
    }
    
    [uploadDataDic setObject:[dict objectForKey:@"regionId"] forKey:@"serviceRegion.id"];
    [requestModel requestRegionInfo:[dict objectForKey:@"regionId"]];
    [self.order_tableView reloadData];
    NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:0];
    MyInfoTableViewCell*cell=(MyInfoTableViewCell*)[self.order_tableView cellForRowAtIndexPath:path];
    cell.normalButton.alpha=0.5;

}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            if ([uploadDataDic objectForKey:@"region"]) {
                if ([self accountStringHeightFromString:[uploadDataDic objectForKey:@"region"] Width:SCREEN_WIDTH-160]>18) {
                    return [self accountStringHeightFromString:[uploadDataDic objectForKey:@"region"] Width:SCREEN_WIDTH-160]+20;
                }
                
            }
        }
        if (indexPath.row==1) {
            if ([uploadDataDic objectForKey:@"address"]) {
                if ([self accountStringHeightFromString:[uploadDataDic objectForKey:@"address"] Width:SCREEN_WIDTH-160]>18) {
                    return [self accountStringHeightFromString:[uploadDataDic objectForKey:@"address"] Width:SCREEN_WIDTH-160]+25;
                }
            }
        }
        
    }
    if (indexPath.section == 1)
    {
        return [self accountSkill];
        
        
    }
    
    return  50;
}


/**计算技能高度*/
-(CGFloat)accountSkill{
    
    if (selectedSkill.count==0) {
        return 50;
    }
    else
    {
        if (selectedSkill.count%4==0) {
            
            return selectedSkill.count/4*30+10;
        }
        else
        {
            return (selectedSkill.count/4+1)*30+10;
        }
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else if (section == 1)
    {
        return @"技能要求";
    }
    else
    {
        return @"备注";
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 6;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell"];
    if (cell == nil)
    {
        cell = [[MyInfoTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"MyInfoTableViewCell"];
        
    }
   
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //设置cell无点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.section == 0)
    {
        cell.listLabel.text = tableArr[indexPath.row];
        
        if (indexPath.row == 4)
        {
            cell.contentLabel.text = self.name;
            if ([cell.contentLabel.text isEqualToString:@""]==YES) {
                cell.contentLabel.text=@"点击填写姓名";
                cell.contentLabel.textColor=[UIColor lightGrayColor];
            }
            else{
                
                cell.contentLabel.textColor=[UIColor blackColor];
            }
            cell.normalButton.hidden=YES;
        }
        else if(indexPath.row == 5)
        {
            cell.normalButton.hidden=YES;
            cell.contentLabel.text = self.mobile;
            [uploadDataDic setObject:self.mobile forKey:@"phone"];
        }
        else
        {
        cell.contentLabel.text = [uploadDataDic objectForKey:array[indexPath.row]];
        }
        
        if (indexPath.row==2) {
            
            cell.normalButton.hidden=YES;
            if ([cell.contentLabel.text isEqualToString:@""]==YES) {
                cell.contentLabel.text=@"点击添加时间";
                cell.contentLabel.textColor=[UIColor lightGrayColor];
            }else{
                
                cell.contentLabel.textColor=[UIColor blackColor];
            }
        }
        
        if (indexPath.row==3) {
            cell.normalButton.hidden=YES;
            if ([cell.contentLabel.text isEqualToString:@""]==YES) {
                cell.contentLabel.text=@"点击添加时间";
                cell.contentLabel.textColor=[UIColor lightGrayColor];

            }else{
                
                cell.contentLabel.textColor=[UIColor blackColor];
            }
        }
        
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentLabel.text=[uploadDataDic objectForKey:@"region"];
            if (!cell.contentLabel.text) {
                
            }
            cell.normalBlock=^(){
                CommonAdressController*cvc=[[CommonAdressController alloc]initWithNibName:@"CommonAdressController" bundle:nil];
                cvc.type=1;
                cvc.addressBlock=^(normalAdress*tempModel){
                    if ([uploadDataDic objectForKey:@"region"]) {
                        [uploadDataDic removeObjectForKey:@"region"];
                    }
                    [uploadDataDic setObject:[NSString stringWithFormat:@"%@-%@-%@",[tempModel.province objectForKey:@"name"],[tempModel.city objectForKey:@"name"],[tempModel.region objectForKey:@"name"]] forKey:@"region"];
                    if ([uploadDataDic objectForKey:@"address"]) {
                        [uploadDataDic removeObjectForKey:@"address"];
                    }
                    
                    [uploadDataDic setObject:tempModel.street forKey:@"address"];
                    if ([uploadDataDic objectForKey:@"serviceRegion.id"]) {
                        [uploadDataDic removeObjectForKey:@"serviceRegion.id"];
                    }
                    [uploadDataDic setObject:[tempModel.region objectForKey:@"id"] forKey:@"serviceRegion.id"];
                    self.order_region.text=@"1";
                    [uploadDataDic setObject:tempModel.street forKey:@"address"];
                    [self.order_tableView reloadData];
                    NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:0];
                    MyInfoTableViewCell*cell=(MyInfoTableViewCell*)[self.order_tableView cellForRowAtIndexPath:path];
                    cell.normalButton.alpha=0.5;
                };
                [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
            };
        }
        if (indexPath.row==1) {
            cell.contentLabel.text=[uploadDataDic objectForKey:@"address"];
            if ([cell.contentLabel.text isEqualToString:@""]==YES) {
                cell.contentLabel.text=@"点击添加详细地址";
                cell.contentLabel.textColor=[UIColor lightGrayColor];
            }else{
            
                cell.contentLabel.textColor=[UIColor blackColor];
            }
            cell.normalButton.hidden=YES;
        }
        
    }
    
    if (indexPath.section == 1)   //技能要求
    {
       
//        UIView*view=(id)[self.view viewWithTag:100];
//        if (view) {
//            [view removeFromSuperview];
//        }
//        view=[[UIView alloc]initWithFrame:cell.bounds];
//        view.tag=100;
//        for (int i=0; i<selectedSkill.count; i++)
//        {
//            
//            AreaModel *model = selectedSkill[i];
//            UIButton *btn= [UIButton buttonWithType:UIButtonTypeSystem];
//            btn.titleLabel.font = [UIFont systemFontOfSize:13];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            btn.tag = i+100;
////            if (model.isselect == YES)
////            {
//                btn.backgroundColor = [UIColor orangeColor];
////            }
////            else
////            {
////                btn.backgroundColor = [UIColor grayColor];
////            }
//            [btn addTarget:self action:@selector(skillsBtn:) forControlEvents:UIControlEventTouchUpInside];
//            btn.layer.cornerRadius = 8;
//            if (i >= 4 && i < 8)
//            {
//                btn.frame = CGRectMake(70*(i-4)+15, 40, 65, 25);
//                [btn setTitle:model.name forState:UIControlStateNormal];
//            }
//            else if ( i >= 8)
//            {
//                btn.frame = CGRectMake(70*(i-3)+15, 75, 65, 25);
//                [btn setTitle:model.name forState:UIControlStateNormal];
//            }
//            else
//            {
//                btn.frame = CGRectMake(5+(i*70), 5, 65, 25);
//                [btn setTitle:model.name forState:UIControlStateNormal];
//            }
//            [view addSubview:btn];
//            [cell.contentView addSubview:view];
//        }
        
        cell.normalButton.hidden=YES;
        return [self getSkillCellWithTableview:tableView];
        
    }
    if (indexPath.section == 2)
    {
        cell.normalButton.hidden=YES;
        cell.listLabel.text = @"备注信息";
        cell.contentLabel.text = [uploadDataDic objectForKey:@"remark"];
    }
    return cell;
}
#pragma mark - UITableview datasource
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
            if (indexPath.section== 0)
            {
                if (indexPath.row==0) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
                    [defaults setObject:@"2" forKey:@"type"];
                    [defaults synchronize];
                    ProvinceTableViewController *ctl = [[ProvinceTableViewController alloc] init];
                    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
                    return;
                }
                
                if (indexPath.row==1) {
                    opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
                    ovc.origin=[uploadDataDic objectForKey:@"address"];
                    ovc.limitCount=200;
                    ovc.type=1;
                    ovc.contentBlock=^(NSString*content){
                    
                        [uploadDataDic setObject:content forKey:@"address"];
                        [self.order_tableView reloadData];
                    
                    };
                    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
                    return;
                }
               
            if (indexPath.row == 2 || indexPath.row == 3)
                {
            
            if (!begainTime&&indexPath.row==3) {
                [self.view makeToast:@"请先选择开始时间" duration:1 position:@"center"];
                return;
            }
            ChangeDateViewController *ctl = [[ChangeDateViewController alloc]init];
            if (indexPath.row==3) {
                ctl.begainTime=begainTime;
                ctl.isEndTime=YES;
            }else{
            
                ctl.isEndTime=NO;
            }
            ctl.blockDateValue = ^(NSString *date){
                
                if (indexPath.row == 2)
                {
                    [uploadDataDic setObject:date forKey:@"startTime"];
                    begainTime=date;
                }
                else
                {
                    [uploadDataDic setObject:date forKey:@"finishTime"];
                }
                [self.order_tableView reloadData];
            };
            [self.navigationController pushViewController:ctl animated:YES];
        }
        else
        {
            ModifyInfoViewController *modify = [[ModifyInfoViewController alloc] init];
            if (indexPath.row == 4)
            {
                modify.index = 5;
                if (self.name) {
                    modify.oldName=self.name;
                    
                }
            }
            else
            {
                modify.index = 0;
                if (self.mobile) {
                    modify.oldMobile=self.mobile;
                }
            }
            modify.modifyBasicInfoBlock = ^(NSString *mobile,long tag){
                
                if (indexPath.row == 4)
                {
                    [uploadDataDic setObject:mobile forKey:@"contract"];
                    self.name = mobile;
                    
                }
                else
                {
                    [uploadDataDic setObject:mobile forKey:@"phone"];
                    self.model.mobile = mobile;
                }
                [self.order_tableView reloadData];
            };
            
            [self.navigationController pushViewController:modify animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
      
        skillSelectViewController*pvc=[[skillSelectViewController alloc]initWithNibName:@"skillSelectViewController" bundle:nil];
        pvc.allSkills=self.allSkills;
        pvc.Array=selectedSkill;
        __block NSString*str;
        pvc.skillArray=^(NSMutableArray*temp){
            [selectedSkill removeAllObjects];
            for (NSInteger i=0; i<temp.count; i++) {
                skillModel*model=temp[i];
                [selectedSkill addObject:model];
                if (i==0) {
                    str=[NSString stringWithFormat:@"%lu",model.id];
                }else{
                    str=[NSString stringWithFormat:@"%@,%lu",str,model.id];
                }
            }
            [uploadDataDic setObject:str forKey:@"skillIds"];
            skillIds=temp;
            [self.order_tableView reloadData];
        };
        
        [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
        
    }
    else
    {
        ModifyInfoViewController *modify = [[ModifyInfoViewController alloc] init];
        modify.index = 6;
        if ([uploadDataDic objectForKey:@"remark"]) {
            modify.oldName=[uploadDataDic objectForKey:@"remark"];
        }
        modify.modifyBasicInfoBlock = ^(NSString *mobile,long tag){
            [uploadDataDic setObject:mobile forKey:@"remark"];
            [self.order_tableView reloadData];
        };
        [self.navigationController pushViewController:modify animated:YES];
    }
}

#pragma mark - 技能按钮点击事件
-(void) skillsBtn:(UIButton *)bt
{
    AreaModel *model = skillArr[bt.tag - 100];
    model.isselect = !model.isselect;
     skillIds = [skillIds stringByAppendingFormat:@"%ld,",(long)model.id];
    [self.order_tableView reloadData];
}

#pragma mark -  请求技能
-(void) requestSkills
{
   
//    NSString *urlString = [self interfaceFromString:interface_skill];
//    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//        NSDictionary *objDic = (NSDictionary *)responseObject;
//        NSArray *entityArr = objDic[@"entities"];
//        for (int i=0; i<entityArr.count; i++)
//        {
//            AreaModel *model = [[AreaModel alloc] init];
//            NSDictionary *dic=entityArr[i];
//            NSDictionary *servicerSkillsDic = dic[@"servicerSkills"];
//            model.id = [servicerSkillsDic[@"id"] integerValue];
//            model.name = servicerSkillsDic[@"name"];
//            model.isselect = NO;
//            [skillArr addObject:model];
//        }
//        [_order_tableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//        
//    }];
    
    for (NSInteger i=0; i<self.allSkills.count; i++) {
        skillModel*model=self.allSkills[i];
        [skillArr addObject:model];
    }
    [self.order_tableView reloadData];
}

#pragma mark - 判断提交预约必填项是否都填写
-(void) isNullOrder
{
    
    if (self.order_region.text.length == 0)
    {
        [self.view makeToast:@"请选择地区!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
   
    
    else if (![uploadDataDic objectForKey:@"address"])
    {
        [self.view makeToast:@"请输入详细地址!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
    else if ([[uploadDataDic objectForKey:@"startTime"] isEqualToString:@""])
    {
       [self.view makeToast:@"请选择开始时间!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
    else if ([[uploadDataDic objectForKey:@"finishTime"] isEqualToString:@""])
    {
        [self.view makeToast:@"请选择结束时间!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
    else if ([[uploadDataDic objectForKey:@"contract"] isEqualToString:@""])
    {
        [self.view makeToast:@"请输入联系人!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
    else if ([[uploadDataDic objectForKey:@"phone"] isEqualToString:@""])
    {
        [self.view makeToast:@"请输入联系电话!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
    else if ([skillIds  isEqual: @""])
    {
        [self.view makeToast:@"请选择技能!" duration:2.0f position:@"center"];
        isNullOrder = NO;
    }
    else
    {
        isNullOrder = YES;
    }
}


//地图相关设置

-(void)setupMap{
    
    _mapManager=[[CLLocationManager alloc]init];
    _geocoder=[[CLGeocoder alloc]init];
    if (![CLLocationManager locationServicesEnabled]) {
        [self.view makeToast:@"定位尚未打开，请检查设置" duration:1 position:@"center"];
        
    }else{
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [_mapManager requestWhenInUseAuthorization];
           
        }else{
            
            _mapManager.delegate=self;
            _mapManager.desiredAccuracy=kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance=10.0;//十米定位一次
            _mapManager.distanceFilter=distance;
            //启动跟踪定位
            [_mapManager startUpdatingLocation];
        }
        
    }
    
}


#pragma mark - CoreLocation 代理
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //    //如果不需要实时定位，使用完即使关闭定位服务
    [_mapManager stopUpdatingLocation];

    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        _serviceRegion=[NSString stringWithFormat:@"%@-%@-%@",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"SubLocality"] ];
        self.order_region.text=_serviceRegion;
        NSString*str=[placemark.addressDictionary objectForKey:@"FormattedAddressLines"][0];
        NSArray*tempArray=[str componentsSeparatedByString:[placemark.addressDictionary objectForKey:@"SubLocality"]];
        self.order_textField.text=tempArray[1];
//        NSLog(@"%@",[placemark.addressDictionary objectForKey:@"SubLocality"]);
      AreaModel*model1=[[dataBase share]findWithCity:[placemark.addressDictionary objectForKey:@"SubLocality"]];
       //数据库处理问题
//        if ([uploadDataDic objectForKey:@"serviceRegion.id"]) {
//            [uploadDataDic removeObjectForKey:@"serviceRegion.id"];
//        }
//        [uploadDataDic setObject:[NSString stringWithFormat:@"%lu",model1.id] forKey:@"serviceRegion.id"];
//        [uploadDataDic setObject:_serviceRegion forKey:@"region"];
//        [uploadDataDic setObject:tempArray[1] forKey:@"address"];
        [self.order_tableView reloadData];
    }];
   
    
}


//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    if (selectedSkill.count==0) {
        cell.textLabel.text=@"点击添加技能";
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        return cell;
    }
    UIView*view=(id)[self.view viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    cell.textLabel.text=@"";
    for (NSInteger i=0; i<selectedSkill.count; i++) {
        skillModel*model=selectedSkill[i];
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
        label.layer.borderWidth=1;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        [view addSubview:label];
        [cell.contentView addSubview:view];
    }
    return cell;
}




@end
