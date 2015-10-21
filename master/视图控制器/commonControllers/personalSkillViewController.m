//
//  personalSkillViewController.m
//  master
//
//  Created by jin on 15/8/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "personalSkillViewController.h"

@interface personalSkillViewController ()

@end

@implementation personalSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    
    if (self.dataArray) {
        self.dataArray=[[NSMutableArray alloc]init];
    }
    for (NSInteger i=0; i<self.allSkills.count; i++) {
        skillModel*model=self.allSkills[i];
        for (NSInteger j=0; j<self.Array.count; j++) {
            skillModel*tempModel=self.Array[j];
            if ([tempModel.name isEqualToString:model.name]==YES) {
                model.isOwer=YES;
            }
        }
        [self.dataArray addObject:model];
    }
    if (!self.tempArray) {
        self.tempArray=[[NSMutableArray alloc]init];
    }
    [self.tableview reloadData];

}

@end
