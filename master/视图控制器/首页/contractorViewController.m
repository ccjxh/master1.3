//
//  contractorViewController.m
//  master
//
//  Created by jin on 15/5/20.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "contractorViewController.h"
#import "PeoDetailViewController.h"
@interface contractorViewController ()

@end

@implementation contractorViewController

- (void)viewDidLoad {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.type=@"工长";
    self.firstLocation=3;
    [super viewDidLoad];
    self.title=@"工长";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    peoplr*p=self.dataArray[indexPath.row];
//    NSLog(@"%ld",(long)p.id);
    
    peoplr*model=self.dataArray[indexPath.row];
    PeoDetailViewController*pvc=[[PeoDetailViewController alloc]init];
    pvc.id = model.id;
    pvc.name = model.realName;
    pvc.mobile = model.mobile;
    
    AreaModel*areaModel = [[dataBase share]findWithCity:self.cityName];
    pvc.cityId = areaModel.id;
    pvc.masterType=2; //判断是项目经理(1)还是师傅(2)
    pvc.userPost = model.userPost;
    pvc.favoriteFlag = model.favoriteFlag;
    NSMutableArray*temp=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<[[model.service objectForKey:@"servicerSkills"] count]; i++) {
        skillModel*skillmodel=[[skillModel alloc]init];
        [ skillmodel setValuesForKeysWithDictionary:[model.service objectForKey:@"servicerSkills"][i]];
        [temp addObject:skillmodel];
    }
    pvc.allSkills=temp;
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
    
}




@end
