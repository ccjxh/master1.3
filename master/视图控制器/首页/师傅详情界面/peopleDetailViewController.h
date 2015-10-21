//
//  peopleDetailViewController.h
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "rootDetailViewController.h"


@interface peopleDetailViewController : rootDetailViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TencentSessionDelegate,WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *master_scrollview;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property(nonatomic)NSMutableArray*collEctionArray;
@property (weak, nonatomic) IBOutlet UITableView *peopleDetailTableView;
@property(nonatomic) NSInteger id; //用户id
@property(nonatomic) NSInteger cityId;  //城市id
@property(nonatomic) NSInteger masterType; //判断是师傅(2)还是项目经理(1)
@property(nonatomic)NSMutableArray*picArray;//工程案例数据源
@property(nonatomic)NSMutableArray*recommendArray;//评论数据源
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)BOOL isFinshRefersh;//是否完成了刷新
@property(nonatomic)NSInteger type;//类型   0为详情  1为我推荐的人
@property(nonatomic)UIViewController*vc;
@property(nonatomic)NSInteger orderID;//推荐记录ID
@property(nonatomic)NSInteger dealResult;//处理结果   0为未处理  1为已处理
@property(nonatomic)TencentOAuth*tencentOAuth;//QQ分享句柄
@property(nonatomic)NSArray*permissions;//QQ允许授权的列表
@property(nonatomic)BOOL inforRefersh;//基本信息刷新状态
@property(nonatomic)BOOL projectRefersh;//工程案例刷新状态
@property(nonatomic)BOOL recommendRefer;//服务评价刷新状态
@property(nonatomic)DAPagesContainer*pagesContainer;

@property (nonatomic,copy) NSString *name; //姓名
@property (nonatomic,copy) NSString *mobile; //电话号码
@property (nonatomic,assign) NSInteger favoriteFlag; //判断是否是已收藏状态
@property (nonatomic,assign) NSInteger userPost; //判断项目经理或师傅
-(void) createUI;
@end
