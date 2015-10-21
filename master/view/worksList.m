//
//  worksList.m
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "worksList.h"
#import "workListTableViewCell.h"
#import "findFirstTableViewCell.h"

@implementation worksList



-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        
        [self initUI];
        
    }
    
    return self;
    
}



-(void)initUI{
    
    _menue=[[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0,0) andHeight:44];
    _menue.dataSource=self;
    _menue.type=1;
    _menue.textColor=COLOR(67, 67, 67, 1);
    _menue.textSelectedColor=COLOR(67, 67, 67, 1);
    _menue.indicatorColor=[UIColor clearColor];
    _menue.delegate=self;
    __weak typeof(self)WeSelf=self;
    _menue.personSkillBlock=^(BOOL isStatus){
        if (WeSelf.personBlock) {
            WeSelf.personBlock(isStatus);
        }
    };
    __weak typeof(DOPDropDownMenu*)menu=_menue;
    _menue.backgroundColor=[UIColor clearColor];
    _menue.block=^(NSMutableDictionary*dict){
    };
    _menue.areablock=^(NSInteger status){
        
    };
    _menue.rankblock=^(NSInteger status){
        
        
        
    };
    
    [self addSubview:_menue];
    self.tableview=[[RefershTableview alloc]initWithFrame:CGRectMake(0, menu.frame.origin.y+menu.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-menu.frame.size.height-10-49-44)];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor=[UIColor whiteColor];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self setupHeaderWithTableview:self.tableview];
    [self setupFooter:self.tableview];
    [self addSubview:self.tableview];
    
    
}


- (void)setupHeaderWithTableview:(UITableView*)tableview
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tableview];
    _refreshHeader = refreshHeader;
    
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        _isRefersh=YES;
        if (_RefershBlock) {
            _RefershBlock();
        }
    };
    
    // 动画view
    UIImageView *animationView = [[UIImageView alloc] init];
    animationView.frame = CGRectMake(30, 45, 40, 40);
    animationView.image = [UIImage imageNamed:@"staticDeliveryStaff"];
    [refreshHeader addSubview:animationView];
    _animationView = animationView;
    UIImageView *boxView = [[UIImageView alloc] init];
    boxView.frame = CGRectMake(150, 10, 15, 8);
    boxView.image = [UIImage imageNamed:@"box"];
    [refreshHeader addSubview:boxView];
    _boxView = boxView;
    
    UILabel *label= [[UILabel alloc] init];
    label.text = @"下拉加载最新数据";
    label.frame = CGRectMake(SCREEN_WIDTH/2-90, 5, 180, 20);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [refreshHeader addSubview:label];
    _label = label;
    
    // normal状态执行的操作
    refreshHeader.normalStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
        refreshView.hidden = NO;
        if (progress == 0) {
            _animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            _boxView.hidden = NO;
            _label.text = @"下拉加载最新数据";
            [_animationView stopAnimating];
        }
        self.animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(progress * 10, -20 * progress), CGAffineTransformMakeScale(progress, progress));
        self.boxView.transform = CGAffineTransformMakeTranslation(- progress * 90, progress * 35);
    };
    
    // willRefresh状态执行的操作
    refreshHeader.willRefreshStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
        _boxView.hidden = YES;
        _label.text = @"放开我，我要为你加载数据";
        _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(10, -20), CGAffineTransformMakeScale(1, 1));
        NSArray *images = @[[UIImage imageNamed:@"deliveryStaff0"],
                            [UIImage imageNamed:@"deliveryStaff1"],
                            [UIImage imageNamed:@"deliveryStaff2"],
                            [UIImage imageNamed:@"deliveryStaff3"]
                            ];
        _animationView.animationImages = images;
        [_animationView startAnimating];
    };
    
    // refreshing状态执行的操作
    refreshHeader.refreshingStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
        _label.text = @"客观别急，正在加载数据...";
        [UIView animateWithDuration:1.5 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(200, -20);
        }];
    };
    
    // 进入页面自动加载一次数据
    //    [refreshHeader beginRefreshing];
}


- (void)setupFooter:(UIScrollView*)tableview
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:tableview];
    _refreshFooter = refreshFooter;
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
}



- (void)footerRefresh
{
    
    if (self.pullUpBlock) {
        self.pullUpBlock();
    }
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 96;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    label.backgroundColor=COLOR(240, 241, 242, 1);
    return label;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    findWorkListModel*model=_dataArray[indexPath.section];
    if ([[[model.publisher objectForKey:@"certification"] objectForKey:@"personal"] integerValue]==1){
    
        findFirstTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"findFirstTableViewCell" owner:nil options:nil]lastObject];
        }
        cell.title.text=model.title;
        cell.width.constant=model.title.length*16+5;
        cell.poepleNumber.text=[NSString stringWithFormat:@"人数：%lu",model.peopleNumber];
        if ([[model.payType objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
            cell.pay.text=@"面议";
        }else{
            
            cell.pay.text=[NSString stringWithFormat:@"%@%@",model.pay,[model.payType objectForKey:@"name"]];
        }
        cell.adress.text=[NSString stringWithFormat:@"地点：%@",[model.workSite objectForKey:@"name"]];
        cell.date.text=[model.publishTime componentsSeparatedByString:@" "][0];
        return cell;
    }
    
    findFirstTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"findFirstTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.title.text=model.title;
    cell.width.constant=model.title.length*16+5;
    cell.poepleNumber.text=[NSString stringWithFormat:@"人数：%lu",model.peopleNumber];
    if ([[model.payType objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
        cell.pay.text=@"面议";
    }else{
        
        cell.pay.text=[NSString stringWithFormat:@"%@%@",model.pay,[model.payType objectForKey:@"name"]];
    }
    cell.adress.text=[NSString stringWithFormat:@"地点：%@",[model.workSite objectForKey:@"name"]];
    cell.date.text=[model.publishTime componentsSeparatedByString:@" "][0];
    cell.skillImage.hidden=YES;
    return cell;

    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tableDidSelected) {
        self.tableDidSelected(tableView,indexPath);
    }
    
}


#pragma mark-选择菜单的delegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        
        return self.firstArray.count;
        
    }else if (column == 1){
        [self.secondArray removeAllObjects];
        NSMutableArray*Array=[[dataBase share]findAllPay];
        [self.secondArray addObject:@"不限制"];
        for (NSInteger i=0;i<Array.count; i++) {
            payModel*model=Array[i];
            [self.secondArray addObject:model.name];
        }
        
        return self.secondArray.count;
    }else {
        return 1;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (_firstArray.count!=0) {
            AreaModel*model=_firstArray[indexPath.row];
            return model.name;
        }
        else
        {
            return @"全市区";
        }
    }else
        if (indexPath.column == 1){
            
            NSMutableArray*Array=[[dataBase share]findAllPay];
            
            if (indexPath.row==0) {
                return @"待遇";
            }else{
            
            payModel*model=Array[indexPath.row-1];
                return model.remark;
            
            }
        } else {
            
            if (self.thirdArray.count==0) {
                return @"信誉";
            }
            return @"信誉";
        }
    
    return @"ss";
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        if (row == 0) {
            return 0;
        } else if (row == 2){
            return 0;
        } else if (row == 3){
            return 0;
        }
    }
    return 0;
}

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
   
    if (self.menueDidSelect) {
        self.menueDidSelect(indexPath);
    }
    
}


@end
