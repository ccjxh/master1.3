//
//  RootView.m
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootView.h"

@implementation RootView

- (void)setupHeaderWithTableview:(UITableView*)tableview
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tableview];
    _refreshHeader = refreshHeader;
    
    _weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
//        _isRefersh=YES;
//        if (_RefershBlock) {
//            _RefershBlock();
//        }
        if (self.tableviewPullDown) {
            self.tableviewPullDown();
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

-(void)footerRefresh{

    if (self.tableviewPullUp) {
        self.tableviewPullUp();
    }

}


@end
