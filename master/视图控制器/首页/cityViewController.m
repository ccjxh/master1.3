//
//  cityViewController.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "cityViewController.h"
#import "headCollectionReusableView.h"
#import "SecondCityViewController.h"
@interface cityViewController ()
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSArray*AZArray;
@end

@implementation cityViewController
{

    NSMutableArray*_currentArray;//装着已开通城市的数组

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"省选择";
    [self initData];
    [self customNavigation];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)initData
{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    _AZArray=@[@"A",@"B",@"C",@"G",@"H",@"J",@"L",@"M",@"N",@"Q",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    for (NSInteger i=0; i<_AZArray.count; i++) {
        NSString*char1=_AZArray[i];
        NSMutableArray*array1=[[dataBase share]findWithFlag:char1];
        [_dataArray addObject:array1];
    }
    [_tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    }
    AreaModel*model=_dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text=model.name;
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return _AZArray[section];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _AZArray;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel*model=_dataArray[indexPath.section][indexPath.row];
    SecondCityViewController*svc=[[SecondCityViewController alloc]initWithNibName:@"SecondCityViewController" bundle:nil];
    svc.model=model;
    svc.count=self.count;
    [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
}




-(void)customNavigation{

//    if (self.type==1) {
//    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//    [button addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"确定" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font=[UIFont systemFontOfSize:16];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
//    }
}

-(void)certain{
    
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    NSString*str;
    for (NSInteger i=0; i<_currentArray.count; i++) {
        AreaModel*model=_currentArray[i];
        if (model.isselect==YES) {
            if (!str) {
                str=[NSString stringWithFormat:@"%lu",model.id];
            }else{
                str=[NSString stringWithFormat:@"%@,%lu",str,model.id];
            }
        }
    }
}

//-(void)initData
//{
//    
//    
//    if (!_dataArray) {
//        _dataArray=[[NSMutableArray alloc]initWithArray:[[dataBase share] findWithPid:30000]];
//        [_tableview reloadData];
//    }
//    
//}
//
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _dataArray.count;
//
//}
//
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!Cell) {
//        Cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
//    }
//
//    Cell.textLabel.font=[UIFont systemFontOfSize:15];
//    AreaModel*model=_dataArray[indexPath.row];
//    Cell.textLabel.text=model.name;
//    return Cell;
//
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    AreaModel*model=_dataArray[indexPath.row];
//    SecondCityViewController*svc=[[SecondCityViewController alloc]initWithNibName:@"SecondCityViewController" bundle:nil];
//    svc.model=model;
//    svc.count=self.count;
//    [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
//
//}


-(void)selected:(UIButton*)button{

    //选择了
    AreaModel*model1=[[dataBase share]findWithCity:button.titleLabel.text];
    if (self.TBlock) {
        if (self.type==0) {
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
        }
    }
}

-(NSInteger)accountCity{
    
    NSMutableArray*array=[[dataBase share]findWithPid:30000];
    if (array.count%3==0) {
        return array.count/3*40+20;
    }else{
    
        return (array.count/3+1)*40+20;
    }
}

-(void)select:(UIButton*)button{

    //选择了
    AreaModel*model1=[[dataBase share]findWithCity:button.titleLabel.text];
    
    if (self.TBlock) {
        if (self.type==0) {
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
        }
    }
}


//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    NSArray*array=@[@"定位的城市",@"已开通的城市"];
//    return array[section];
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0) {
//        
//    return 50;
//        
//    }
//    
//    return [self accountCity];
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
//
//-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return _AZArray;
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//
//}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray*array=[[dataBase share]findWithPid:30000];
    AreaModel*model=array[indexPath.row];
    if (self.type==1){
        if (indexPath.section==1) {
            AreaModel*model=_currentArray[indexPath.row];
            if (model.isselect==NO) {
                model.isselect=YES;
            }else{
                
                model.isselect=NO;
            }
            [_currentArray replaceObjectAtIndex:indexPath.row withObject:model];
            [collectionView reloadData];;
            return;
        }
    }
    
    if (self.TBlock) {
        if (self.type==0) {
        if (indexPath.section==0) {
            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if (delegate.city) {
            AreaModel*model1=[[dataBase share]findWithCity:delegate.city];
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
            return;
        }else{
        
            [self.view makeToast:@"定位中" duration:1 position:@"center"];
            return;
            
            }
        }
        
        if (self.type==0) {
            self.TBlock(model);
            [self popWithnimation:self.navigationController];
            
            }
        }
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    
    headCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        NSArray*array=@[@"    GPS定位",@"    已开通的城市"];
    UILabel*label=(id)[collectionView viewWithTag:30+indexPath.section];
    if (label) {
        [label removeFromSuperview];
    }
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    label.backgroundColor=[UIColor whiteColor];
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:13];
    label.text=array[indexPath.section];
    [view addSubview:label];
        return view;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(90, 35);
    }
    if (indexPath.section==1) {
        return CGSizeMake((SCREEN_WIDTH-60)/3, 35);
    }
    return CGSizeZero;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    
    CGSize size={SCREEN_WIDTH,35};
    return size;
}


@end
