//
//  headViewController.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "headViewController.h"
#import "PeoDetailViewController.h"

@interface headViewController ()

@end

@implementation headViewController

- (void)viewDidLoad {
    self.type=@"师傅";
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    peoplr*model=self.dataArray[indexPath.row];
    PeoDetailViewController*ctl=[[PeoDetailViewController alloc]init];
    ctl.masterType = 1;
    ctl.id = model.id;
    ctl.icon=model.icon;
    ctl.favoriteFlag = model.favoriteFlag; //判断收藏状态
    ctl.userPost = model.userPost; //判断是项目经理还是师傅
    AreaModel*areaModel = [[dataBase share]findWithCity:self.cityName];
    ctl.cityId = areaModel.id;
    ctl.name = model.realName;
    ctl.mobile = model.mobile;
    NSMutableArray*temp=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<[[model.service objectForKey:@"servicerSkills"] count]; i++) {
        skillModel*skillmodel=[[skillModel alloc]init];
        [ skillmodel setValuesForKeysWithDictionary:[model.service objectForKey:@"servicerSkills"][i]];
        [temp addObject:skillmodel];
    }
    ctl.allSkills=temp;
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}
@end
