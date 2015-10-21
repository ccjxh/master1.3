//
//  mypublicListView.m
//  master
//
//  Created by jin on 15/8/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "mypublicListView.h"
#import "workListTableViewCell.h"
#import "CustomDialogView.h"
@implementation mypublicListView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self initUI];
        
    }
    
    return self;
    
}


-(void)initUI{
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=0;
    [self addSubview:self.tableview];
    [self setupHeaderWithTableview:self.tableview];
    [self setupFooter:self.tableview];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 127;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 14;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    label.backgroundColor=COLOR(240, 241, 242, 1);
    return label;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    findWorkListModel*model=_dataArray[indexPath.section];
    workListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell=[[[NSBundle mainBundle]loadNibNamed:@"workListTableViewCell" owner:nil options:nil]lastObject];
        
    }
    cell.title.text=model.title;
    cell.width.constant=model.title.length*16+5;
    if (model.title.length>14) {
        cell.width.constant=14*16+5;
    }
    cell.personCount.text=[NSString stringWithFormat:@"人数：%lu",model.peopleNumber];
    if ([[model.payType objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
        cell.payMoney.text=@"面议";
    }else{
        
        cell.payMoney.text=[NSString stringWithFormat:@"%@%@",model.pay,[model.payType objectForKey:@"name"]];
    }
    cell.address.text=[NSString stringWithFormat:@"地点：%@",[model.workSite objectForKey:@"name"]];
    if (model.auditState==1) {
        cell.status.text=@"正在审核";
        cell.status.textColor=COLOR(247, 207, 56, 1);
    }else if (model.auditState==2){
    
        cell.status.text=@"审核通过";
        cell.status.textColor=COLOR(70, 195, 59, 1);
    }else if (model.auditState==3){
    
        cell.status.text=@"审核不通过";
        cell.status.textColor=COLOR(234, 0, 61, 1);
    }
    
    cell.skillImage.hidden=YES;
    cell.date.text=[model.publishTime componentsSeparatedByString:@" "][0];
    cell.publicName.textColor=COLOR(128, 128, 128, 1);
    cell.personCount.textColor=cell.publicName.textColor;
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.listDidSelect) {
        self.listDidSelect(indexPath);
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count!=0) {
        
        findWorkListModel*model=_dataArray[indexPath.section];
        if (model.auditState ==1) {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CustomDialogView*cvc=[[CustomDialogView alloc]initWithTitle:@"" message:@"发布的信息删除后无法恢复，请谨慎选择。是否删除？" buttonTitles:@"确定",@"取消", nil];
        __weak typeof(self)WeSelf=self;
        [cvc showInView:self completion:^(NSInteger selectIndex) {
            if (selectIndex==0) {
                if (WeSelf.deleBlock) {
                    WeSelf.deleBlock(indexPath);
                }
            }else{
                
                [WeSelf.tableview reloadData];
                
            }
            
            
        }];
      
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
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
//        [refreshHeader beginRefreshing];
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



@end
