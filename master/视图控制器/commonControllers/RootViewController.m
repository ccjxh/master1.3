//
//  RootViewController.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showIncreaImage" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self createIncreaseview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parse:) name:@"showIncreaImage" object:nil];
    
       // Do any additional setup after loading the view.
}


-(void)parse:(NSNotification*)notiction{

    NSDictionary*dict=notiction.userInfo;
    _addIntral=[[dict objectForKey:@"value"] integerValue];
    [self showIncreaImage];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-加载动画
-(void)CreateFlow
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressHUD];
    _progressHUD.labelText = @"加载中...";
    _progressHUD.labelFont = [UIFont systemFontOfSize:10];
    _progressHUD.backgroundColor=[UIColor clearColor];
    _progressHUD.cornerRadius = 5;
    _progressHUD.dimBackground=NO;
    _progressHUD.minSize = CGSizeMake(70, 70);
    _progressHUD.animationType = MBProgressHUDAnimationZoomOut;
}

-(void)flowShow{

    [_progressHUD show:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;

}


-(void)flowHide{
    [_progressHUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}


#pragma mark-刷新
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
    label.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, 5, 200, 20);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
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


-(void)setupfooterForCollectionview:(UIScrollView*)collectionview{

    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:collectionview];
    _refreshFooter = refreshFooter;
    [refreshFooter addTarget:self refreshAction:@selector(collectionviewFooterRefresh)];


}



- (void)footerRefresh
{
   
    
    
}



-(void)noData{
    _noDataView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-70, 130, 140, 80)];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, _noDataView.frame.size.width, 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"暂无相关数据";
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(_noDataView.frame.size.width/2-40, 10, 80, 75)];
    imageview.image=[UIImage imageNamed:@"表情.jpg"];
    [_noDataView addSubview:imageview];
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:17];
    [_noDataView addSubview:label];
    [self.view addSubview:_noDataView];
    _noDataView.hidden=YES;
    
}


-(void)net{
    _netIll=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-70, 120, 140, 80)];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(_netIll.frame.size.width/2-40, 10, 80, 70)];
    imageview.image=[UIImage imageNamed:@"表情.jpg"];
    [_netIll addSubview:imageview];
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(_netIll.frame.size.width/2-60, imageview.frame.size.height+15, 120, 25)];
    [button setTitle:@"当前网络不好" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(reRequest) forControlEvents:UIControlEventTouchUpInside];
    [_netIll addSubview:button];
    _netIll.hidden=YES;
    [self.view addSubview:_netIll];
    [self.view bringSubviewToFront:_netIll];
}

-(void)reRequest{
    

}


-(void)createIncreaseview{
    _increaseView=[[UIView alloc]initWithFrame:self.view.bounds];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-140, SCREEN_HEIGHT/2-120, 280, 240)];
    view.layer.cornerRadius=3;
    view.backgroundColor=[UIColor whiteColor];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/2-70, 20, 140, 140)];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-70, CGRectGetMaxY(imageview.frame)+10, 160, 20)];
    imageview.backgroundColor=[UIColor whiteColor];
    imageview.alpha=1;
    label.tag=100;
    label.textAlignment=NSTextAlignmentCenter;
    label.text=[NSString stringWithFormat:@"恭喜您获得%lu积分",_addIntral];
    label.textColor=COLOR(248, 101, 0, 1);
    label.font=[UIFont systemFontOfSize:18];
    [view addSubview:label];
    imageview.image=[UIImage imageNamed:@"签到成功"];
    [view addSubview:imageview];
    [_increaseView addSubview:view];
    _increaseView.backgroundColor=COLOR(29, 29, 29, 0.5);

}


-(void)showIncreaImage{
    [self.view addSubview:_increaseView];
    UILabel*label=(id)[self.view viewWithTag:100];
    label.text=[NSString stringWithFormat:@"恭喜获得%lu积分",(long)_addIntral];
    [self.view bringSubviewToFront:_increaseView];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
}

-(void)delayMethod{

    _increaseView.hidden=YES;

}


@end
