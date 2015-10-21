//
//  peopleDetailViewController.m
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "peopleDetailViewController.h"
#import "peopleDetailTableViewCell.h"
#import "peopleDetail2TableViewCell.h"
#import "peopleDetaileeTableViewCell.h"
#import "peopleDetail4TableViewCell.h"
#import "ReferrerCommentsCell.h"
#import "MasterDetailModel.h" //师傅详情model
#import "requestModel.h" 
#import "OrderDetailViewController.h"
#import "projectCastDetailViewController.h"
#import "myProjectCaseViewController.h"
#import "myRecommendScoreViewController.h"
#import "InfoViewController.h"
#import "PeoCaseViewController.h"
#import "PeoServeViewController.h"

@interface peopleDetailViewController ()
{
    MasterDetailModel *masterDetailModel;
    CGFloat skillHeight; //自适应技能 cell 高度
    CGFloat height; //自适应服务区域和服务介绍 cell 的高度
    CGFloat commentsHeight;  //推荐人评语自适应高度
    UIScrollView *scrollview;
     BOOL isCollect; //判断收藏状态
    UIButton *collectBtn;
    UIButton *shareBtn;
    NSMutableArray*_dataArray;
    NSMutableArray*programeData;
    NSMutableArray*serviceData;
    UICollectionView*_programeTableview;
    UITableView*_serviceTableview;
    
}
@end

@implementation peopleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackView];
//    _currentPage=1;
//    self.tabBarController.tabBar.hidden = YES;
//    skillHeight = 0;
//    height = 0;
//    commentsHeight = 0;
    isCollect = NO;
//    self.peopleDetailTableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    masterDetailModel = [[MasterDetailModel alloc] init];
//    self.navigationItem.title = @"师傅详情";
    [self createUI];
//    [self registerCell];
//    [self createTableview];
//
    [self customUI];
//    _inforRefersh=YES;
//    _recommendRefer=YES;
//    _projectRefersh=YES;
//    [self requestMasterDetail];
//    [self requestProjectCase];
//    [self requestAllReconnemd];
//    [self CreateFlow];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    orderBtn.frame = CGRectMake(10, SCREEN_HEIGHT-45, SCREEN_WIDTH-20, 40);
    [orderBtn setTitle:@"我要预订" forState:UIControlStateNormal];
    orderBtn.backgroundColor = [UIColor orangeColor];
    orderBtn.layer.cornerRadius = 8;
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
}
-(void) orderBtn
{
    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
    ctl.masterId = self.id;
    ctl.name = self.name;
    ctl.mobile = self.mobile;
    ctl.model = masterDetailModel;
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}

-(void)createBackView{
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.topBarBackgroundColor=COLOR(221, 221, 221, 1);
    CGFloat height ;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
        height=64;
    }else if ([[UIDevice currentDevice].systemVersion floatValue]<8){
        height=44;
    }
    self.pagesContainer.view.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT-height);
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    InfoViewController *avc = [[InfoViewController alloc] init];
    avc.id = self.id;
    avc.cityId = self.cityId;
    avc.masterType = self.masterType;
    avc.userPost = self.userPost;
    avc.title=@"基本信息";
    PeoCaseViewController *wvc = [[PeoCaseViewController alloc] init];
    wvc.title=@"工程案例";
    wvc.id = self.id;
    wvc.nav = self.navigationController;
    PeoServeViewController *pvc = [[PeoServeViewController alloc] init];
    pvc.title=@"服务评价";
    pvc.id = self.id;
    self.pagesContainer.viewControllers=@[avc,wvc,pvc];

}



- (void)viewWillUnload
{
    self.pagesContainer = nil;
    [super viewWillUnload];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.pagesContainer updateLayoutForNewOrientation:toInterfaceOrientation];
}


-(void)customUI{
    if (self.type==1) {
       UIButton*view1=(id)[self.view viewWithTag:200];
        UILabel*label=(id)[self.view viewWithTag:201];
        label.hidden=YES;
        view1.hidden=YES;
        
        
        if (self.dealResult==0) {
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
    NSArray*Array=@[@"推荐",@"拒绝推荐"];
            
            
    for (NSInteger i=0; i<Array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(20+i*(SCREEN_WIDTH-120), 0, 80, 30)];
        button.backgroundColor=[UIColor orangeColor];
        [button setTitle:Array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        button.tag=20+i;
        button.layer.cornerRadius=10;
        [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
       }
    [self.view addSubview:view];
    }
 }

}


-(void)onclick:(UIButton*)button{
    switch (button.tag) {
        case 20:
        {
            myRecommendScoreViewController*mvc=[[myRecommendScoreViewController alloc]initWithNibName:@"recommendStarsViewController" bundle:nil];
            mvc.id=self.id;
            mvc.dataArray=_dataArray;
            mvc.orderID=self.orderID;
            mvc.vc=self.vc;
            mvc.model=_dataArray[0];
            [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];
            
        }
            break;
        case 21:
        {
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void) createUI
{

    //导航栏右边按钮
    shareBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(210, 8, 21, 17);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_chare_press"] forState:UIControlStateNormal];
    shareBtn.tag = 100;
    [shareBtn addTarget:self action:@selector(navRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    collectBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    collectBtn.frame = CGRectMake(250, 8, 21, 17);
    if (self.favoriteFlag == 1)
    {
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_great"] forState:UIControlStateNormal];
    }
    else
    {
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_un_great"] forState:UIControlStateNormal];
    }
    collectBtn.tag = 101;
    [collectBtn addTarget:self action:@selector(navRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    NSArray *array = @[item,item2];
    self.navigationItem.rightBarButtonItems = array;
    
}

#pragma mark - 右侧导航栏按钮点击事件
-(void) navRight: (UIButton *)bt
{
    if (bt.tag == 101)
    {
        if (self.favoriteFlag == 1)
        {
            [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_great"] forState:UIControlStateNormal];
            [self.view makeToast:@"已收藏过" duration:2.0f position:@"center"];

        }
        else
        {
            [self requestCollect];
            [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_great"] forState:UIControlStateNormal];
        }
        isCollect = !isCollect;
    }
    if (bt.tag==100) {
        [self selectShare];
    }
}



#pragma mark - 添加收藏
-(void) requestCollect
{
    NSString *urlString = [self interfaceFromString:interface_collectMaster];
    NSDictionary *dic = @{@"masterId":[NSNumber numberWithInteger:self.id]};
    [[httpManager share] POST:urlString parameters:dic success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        if ([[objDic objectForKey:@"rspCode"]integerValue] == 200)
        {
            [self.view makeToast:@"收藏成功!" duration:2.0f position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}



#pragma mark-QQShare
-(void)setupQQShare{
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104650241" andDelegate:self];
    _permissions =[NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    NSString*urlString=@"http://www.zhuobao.com";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:urlString] title:@"zhege" description:@"大声叫出我的名字拜师傅" previewImageURL:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
}

-(void)selectShare{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-125, SCREEN_HEIGHT/2-90, 250, 140)];
    view.tag=400;
    view.backgroundColor=[UIColor whiteColor];
    NSArray*array=@[@"分享到QQ",@"分享到微信",@"取消"];
    for (NSInteger i=0; i<array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 10+i*50, view.frame.size.width, 30)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.tag=300+i;
        if (i!=2) {
            UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 49+i*50, view.frame.size.width, 1)];
            view1.backgroundColor=[UIColor lightGrayColor];
            [view addSubview:view1];
        }
        [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    view.userInteractionEnabled=YES;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

//微信分享
-(void)WeiChatShare{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"给自己一个大大的微笑";
    message.description = @"世界这么乱，何不给自己一个大大的微笑--消息来自宝师傅APP客户端。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.zhuobao.com";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;//0是好友  1是朋友圈  2是收藏
    [WXApi sendReq:req];


}


- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

-(void)share:(UIButton*)button{
    UIView*view=(id)[self.view viewWithTag:400];
    switch (button.tag) {
        case 300:
        {
            [view removeFromSuperview];
            [self setupQQShare];
        }
            break;
            case 301:
        {
            //微信分享
            [view removeFromSuperview];
            [self WeiChatShare];
        }
            break;
            case 302:
        {
            
            [view removeFromSuperview];
            
        }
            break;
        default:
            break;
    }

}

@end