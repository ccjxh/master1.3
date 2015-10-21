//
//  RootViewController.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SDRefresh.h"
typedef void (^refershBlock)();
typedef void (^loadMoreBlock)();
@interface RootViewController : UIViewController
{
    MBProgressHUD*_progressHUD;
}

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@property(nonatomic)NSInteger Page;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property(nonatomic)BOOL isRefersh;//是否是下拉刷新
@property(nonatomic,weak)SDRefreshHeaderView *weakRefreshHeader;//下拉刷新透视图
@property(nonatomic,copy)refershBlock RefershBlock;//上拉刷新处理
@property(nonatomic)BOOL isNetWorkRefer;//是否进行网络请求
@property(nonatomic,copy)NSString*token;//请求身份令牌
@property(nonatomic)UIView*noDataView;//没有数据
@property(nonatomic)UIView*netIll;//网络不好
@property(nonatomic)UIView*increaseView;//积分增加view
@property(nonatomic)NSInteger addIntral;//积分增加的数量
-(void)CreateFlow;
-(void)flowShow;
-(void)flowHide;
- (void)footerRefresh;
-(void)setupfooterForCollectionview:(UICollectionView*)collectionview;
- (void)setupHeaderWithTableview:(UIScrollView*)tableview;
- (void)setupFooter:(UIScrollView*)tableview;
-(void)collectionviewFooterRefresh;
-(void)refersh;
-(void)noData;
-(void)net;
-(void)createIncreaseview;
-(void)showIncreaImage;
@end
