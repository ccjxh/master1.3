//
//  myProjectCaseViewController.m
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myProjectCaseViewController.h"
#import "projectCastDetailViewController.h"
#import "projectCaseAddViewController.h"

@interface myProjectCaseViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation myProjectCaseViewController






-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isRefersh=YES;
    [self requestProjectCase];
   
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _rightStstus=@"管理";
    _currentPage=1;
   [self initUI];
    [self customNV];
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestProjectCase];
    };
    [self setupHeaderWithTableview:self.collection];
    [self setupFooter:self.collection];
    [self CreateFlow];
    [self net];
    [self noData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求工程案例
-(void) requestProjectCase
{
    [self flowShow];
    self.netIll.hidden=YES;
    self.noDataView.hidden=YES;
    if (!_deleArray) {
        _deleArray=[[NSMutableArray alloc]init];
    }
    [_deleArray removeAllObjects];
    
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    
    NSString *urlString;
    NSDictionary*valueDict;
    if (self.type==1) {
        urlString=[self interfaceFromString:interface_IDAllProjectCase];
        valueDict=@{@"userId":[NSString stringWithFormat:@"%lu",self.id],@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
    }else{
    
        urlString = [self interfaceFromString:interface_projectCase];
        valueDict=@{@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
    }
    [[httpManager share]POST:urlString parameters:valueDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        
        
        
        if (self.isRefersh==YES) {
            [_dataArray removeAllObjects];
        }
        NSArray*array=[objDic objectForKey:@"entities"];
        
        
        
        if (array.count==0) {
            self.noDataView.hidden=NO;
            
        }else{
        
            self.noDataView.hidden=YES;
        }
        
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*dict=array[i];
            peojectCaseModel*model=[[peojectCaseModel alloc]init];
            [model setValuesForKeysWithDictionary:[dict objectForKey:@"masterProjectCase"]];
            [_dataArray addObject:model];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collection reloadData];
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            self.isRefersh=NO;
            [self flowHide];
        });
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        self.netIll.hidden=NO;
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        self.isRefersh=NO;
        [self flowHide];
    }];
    
}



-(void)footerRefresh{

    _currentPage++;
    [self requestProjectCase];

}

-(void)customNV{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:_rightStstus forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)initUI{
    
    self.collection.backgroundColor=COLOR(234, 234, 234, 1);
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)/2)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//设置其边界
    self.collection.collectionViewLayout=layout;
    UINib*nib=[UINib nibWithNibName:@"projectCaseCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collection registerNib:nib  forCellWithReuseIdentifier:@"Cell"];
   
}

-(void)add:(UIButton*)button{
    
    
    for (NSInteger i=0; i<_dataArray.count; i++) {
        peojectCaseModel*model=_dataArray[i];
        if (model.isSelected==YES) {
            [_deleArray addObject:model];
        }
    }
    
    if ([button.titleLabel.text isEqualToString:@"管理"]==YES) {
        UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"工程案例管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除案例",@"添加新案例", nil];
        [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    }
        if ([button.titleLabel.text isEqualToString:@"删除"]==YES) {
        if (_deleArray.count!=0) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"删除提示" message:[NSString stringWithFormat:@"是否删除%lu个工程案例",_deleArray.count] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
        }else{
        
        _rightStstus=@"管理";
            [self customNV];
            return;
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //确认删除
        NSString*urlString=[self interfaceFromString:interface_deleProjectCase];
        NSDictionary*dict;
        NSString*temp;
        for (NSInteger i=0; i<_deleArray.count; i++) {
            peojectCaseModel*model=_deleArray[i];
            if (i==0) {
                temp=[NSString stringWithFormat:@"%lu",model.id];
            }else{
                temp=[NSString stringWithFormat:@"%@,%lu",temp,model.id];
            }
        }
        dict=@{@"id":temp};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*inforDic=(NSDictionary*)responseObject;
            if ([[inforDic objectForKey:@"rspCode"] integerValue]==200) {
                self.isRefersh=YES;
               
            }else{
                [self.view makeToast:[inforDic objectForKey:@"msg"] duration:1 position:@"center"];
            
            }
            
            _rightStstus=@"管理";
            _isshow=NO;
            [self customNV];
            [self requestProjectCase];
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
            _rightStstus=@"管理";
            _isshow=NO;
            [self customNV];
        }];
    }


}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return _dataArray.count;

}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    projectCaseCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    peojectCaseModel*model=_dataArray[indexPath.row];
    cell.model=model;
    cell.isShow=_isshow;
    cell.isSel=model.isSelected;
    cell.isExitImageBack=YES;
    cell.block=^{
        if (model.isSelected) {
            model.isSelected=NO;
        }else{
            model.isSelected=YES;
        }
        [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        [self.collection reloadData];
    
    };
    [cell reloadData];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    peojectCaseModel*model=_dataArray[indexPath.row];
    projectCastDetailViewController*pvc=[[projectCastDetailViewController alloc]initWithNibName:@"projectCastDetailViewController" bundle:nil];
    pvc.id=model.id;
    if (model.type==1) {
        pvc.isStars=YES;
    }else{
        pvc.isStars=NO;
    }
    pvc.model=model;
    pvc.name=model.caseName;
    pvc.introlduce=model.introduce;
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        switch (buttonIndex) {
        
        case 0:
        {
            //删除照片
            _isshow=YES;
            _rightStstus=@"删除";
            [self customNV];
            [self.collection reloadData];
            
        }
            break;
        case 1:
        {
            //添加新照片
            projectCaseAddViewController*pvc=[[projectCaseAddViewController alloc]init];
            pvc.caseType=2;
            [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
        }
            break;
        case 2:
        {
            //取消
            
            
            
        }
            break;
        default:
            break;
    }
    
    
}




@end
