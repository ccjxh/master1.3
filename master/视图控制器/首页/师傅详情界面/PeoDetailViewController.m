//
//  PeoDetailViewController.m
//  master
//
//  Created by xuting on 15/7/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "PeoDetailViewController.h"
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
#import "personDetailViewModel.h"
#define LABELTAG 300
@interface  PeoDetailViewController ()<personDetailDelegate,UIActionSheetDelegate>
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
    UIButton *orderBtn;
    NSString*shareUrl;
    masterModel*recommModel;
    UIView*contentView;
    UITextField*_tx;
    NSData*data;
}

@end

@implementation PeoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
   
//    [self createBackView];
    [self requestshare];
    [self createSlider];
    isCollect = NO;
    //    self.peopleDetailTableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    masterDetailModel = [[MasterDetailModel alloc] init];
    //    self.navigationItem.title = @"师傅详情";
//    [self createUI];
   
    if (self.type==0) {
    orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    orderBtn.frame = CGRectMake(10, SCREEN_HEIGHT-45, SCREEN_WIDTH-20, 40);
    [orderBtn setTitle:@"我要预订" forState:UIControlStateNormal];
    orderBtn.backgroundColor = [UIColor orangeColor];
    orderBtn.layer.cornerRadius = 8;
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderBtn) forControlEvents:UIControlEventTouchUpInside];

       }
    self.title=@"详情";
    [self customUI];
    [self createUI];
    [self CreateFlow];

}


-(NSInteger)firstLocation{

    return self.firstLocation;

}

-(NSInteger)personID{

    return self.id;

}

-(void)requestshare{

    
    recommModel=[[masterModel alloc]init];
    recommModel.url=[NSString stringWithFormat:@"%@/admin/share/masterDetail?id=%lu",changeURL,self.id];
    recommModel.title=@"向您推荐一位宝师傅";
    recommModel.content=[NSString stringWithFormat:@"%@",self.name];
    
    
}

-(void) orderBtn
{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    OrderDetailViewController *ctl = [[OrderDetailViewController alloc] init];
    ctl.masterId = self.id;
    ctl.name =model.realName ;
    ctl.mobile = model.mobile;
    ctl.model = masterDetailModel;
    ctl.allSkills=self.allSkills;
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}



-(void)createSlider{

    NSArray*array=@[@"基本信息",@"工程案例"];
    for (NSInteger i=0; i<array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2-1, 44)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i==0) {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width, 70, 1, 34)];
            view.backgroundColor=COLOR(205, 205, 205, 1);
            [self.view addSubview:view];
            UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 1)];
            view1.backgroundColor=COLOR(205, 205, 205, 1);
            [self.view addSubview:view1];
        }
       
    }
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH/2, 5)];
    label.backgroundColor=COLOR(22, 168, 233, 1);
    label.tag=LABELTAG;
    [self.view addSubview:label];
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, SCREEN_HEIGHT-112)];
    scrollview.delegate=self;
    scrollview.bounces=NO;
    scrollview.scrollEnabled=NO;
    scrollview.contentSize=CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-44);
    [self.view addSubview:scrollview];
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.pagingEnabled=YES;
    InfoViewController *avc = [[InfoViewController alloc] init];
    PeoCaseViewController *wvc = [[PeoCaseViewController alloc] init];
    avc.id = self.id;
    avc.cityId = self.cityId;
    avc.masterType = self.masterType;
    avc.userPost = self.userPost;
    avc.title=@"基本信息";
    wvc.title=@"工程案例";
    wvc.id = self.id;
    wvc.nav = self.navigationController;
    [self addChildViewController:avc];
    [self addChildViewController:wvc];
    for (UIViewController*vc in self.childViewControllers) {
        if ([vc isKindOfClass:[InfoViewController class]]==YES) {
            
            vc.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, scrollview.frame.size.height);
            vc.view.backgroundColor=[UIColor blackColor];
            [scrollview addSubview:vc.view];
        }
        if ([vc isKindOfClass:[PeoCaseViewController class]]==YES) {
            
            vc.view.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollview.frame.size.height);
            [scrollview addSubview:vc.view];
        }
        
    }
    
    
    
//    UIView*backView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45,SCREEN_WIDTH, 45)];
//    backView.backgroundColor=[UIColor whiteColor];
//    UILabel*checkLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 35)];
//    checkLabel.textColor=COLOR(146, 146, 146, 1);
//    checkLabel.text=@"内容信息不符?";
//    checkLabel.font=[UIFont systemFontOfSize:15];
//    [backView addSubview:checkLabel];
//    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 45)];
//    [button setTitle:@"举报" forState:UIControlStateNormal];
//    button.backgroundColor=COLOR(22, 167, 232, 1);
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font=[UIFont systemFontOfSize:16];
//    [button addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:button];
//    [backView addSubview:button];
//    backView.userInteractionEnabled=YES;
//    [self.view addSubview:backView];
    
//    PeoServeViewController *pvc = [[PeoServeViewController alloc] init];
//    pvc.title=@"服务评价";
//    pvc.id = self.id;
//    self.pagesContainer.viewControllers=@[avc,wvc];
//    [self.view addSubview:self.pagesContainer.view];

}


//举报
-(void)check{
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"举报!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textAlignment=NSTextAlignmentRight;
    welcomeLabel.textColor = [UIColor blackColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    infoLabelRect.size.height-=40;
    _tx=[[UITextField alloc]initWithFrame:infoLabelRect];
    _tx.font=[UIFont systemFontOfSize:16];
    _tx.layer.cornerRadius=7;
    _tx.placeholder=@"在这里输入内容?";
    [_tx becomeFirstResponder];
    _tx.delegate=self;
    [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor blackColor];
    [contentView addSubview:_tx];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(_tx.frame.origin.x, _tx.frame.origin.y+_tx.frame.size.height-5, _tx.frame.size.width, 1)];
    view.backgroundColor=COLOR(74, 166, 216, 1);
    [contentView addSubview:view];
    CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
    txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
    txBounce.size.width-=30;
    txBounce.size.height=30;
    NSArray*array=@[@"确定",@"取消"];
    for (NSInteger i=0; i<array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
        button.frame=CGRectMake(150+i*60, button.frame.origin.y, 50, button.frame.size.height+10);
        button.backgroundColor=contentView.backgroundColor;
        button.layer.borderColor=[[UIColor whiteColor]CGColor];
        button.layer.borderWidth=1;
        button.layer.cornerRadius=3;
        button.tag=40+i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.userInteractionEnabled=NO;
        }
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(changeDEsscribe:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    contentView.backgroundColor=[UIColor whiteColor];
    [KGModal sharedInstance].modalBackgroundColor=[UIColor whiteColor];
    [KGModal sharedInstance].showCloseButton=NO;
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UIButton*button=(id)[contentView viewWithTag:40];
    
    if (textField.text.length==0) {
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
    }else{
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.userInteractionEnabled=YES;
    }
    return YES;
    
}



-(void)changeDEsscribe:(UIButton*)button{
    
    [[KGModal sharedInstance]hideAnimated:YES];
    if (button.tag==40) {
        //改变说明
        if (_tx.text.length==0) {
            [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
            return;
        }
        [self flowShow];
        NSDictionary*dict=@{@"problem":_tx.text,@"checkUser.id":[NSNumber numberWithInteger:self.id]};
        
        NSString*urlString=[self interfaceFromString:interface_reportInfo];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                    
                    [self.view makeToast:@"举报成功!" duration:2.0f position:@"center"];
                }];
            }else{
                
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
            [self.view makeToast:@"网络繁忙,请稍后重试" duration:1 position:@"center"];
            
        }];
    }else{
        
    }
}



-(void)change:(UIButton*)button{
    
    UILabel*label=(id)[self.view viewWithTag:LABELTAG];
    if ([button.titleLabel.text isEqualToString:@"基本信息"]==YES) {
        label.frame=CGRectMake(0, 108, SCREEN_WIDTH/2, 5);
        if (scrollview.contentOffset.x==0) {
            return;
        }else{
        
            [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }else{
        label.frame=CGRectMake(SCREEN_WIDTH/2, 108, SCREEN_WIDTH/2, 5);
        if (scrollview.contentOffset.x==SCREEN_WIDTH) {
            return;
        }else{
        
            [scrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        }
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    UILabel*label=(id)[self.view viewWithTag:LABELTAG];
    label.frame=CGRectMake(scrollView.contentOffset.x/2, 108, SCREEN_WIDTH/2, 5);

}


-(void)createBackView{
    
//    self.pagesContainer = [[DAPagesContainer alloc] init];
//    [self.pagesContainer willMoveToParentViewController:self];
//    self.pagesContainer.view.frame = self.view.bounds;
//    self.pagesContainer.topBarBackgroundColor=COLOR(22, 168, 234, 1);
//    NSInteger orginHeight ;
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
//        orginHeight=64;
//    }else if ([[UIDevice currentDevice].systemVersion floatValue]<8){
//        orginHeight=64;
//    }
//    self.pagesContainer.view.frame = CGRectMake(0, orginHeight, SCREEN_WIDTH, SCREEN_HEIGHT-orginHeight);
//    InfoViewController *avc = [[InfoViewController alloc] init];
//    avc.id = self.id;
//    avc.cityId = self.cityId;
//    avc.masterType = self.masterType;
//    avc.userPost = self.userPost;
//    avc.title=@"基本信息";
//    PeoCaseViewController *wvc = [[PeoCaseViewController alloc] init];
//    wvc.title=@"工程案例";
//    wvc.id = self.id;
//    wvc.nav = self.navigationController;
//    PeoServeViewController *pvc = [[PeoServeViewController alloc] init];
//    pvc.title=@"服务评价";
//    pvc.id = self.id;
//    self.pagesContainer.viewControllers=@[avc,wvc];
//    [self.view addSubview:self.pagesContainer.view];
//    [self.pagesContainer didMoveToParentViewController:self];
//    
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
        if (self.dealResult==1)
        {
            [orderBtn removeFromSuperview];
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 40)];
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
            mvc.dModel = self.model;
            mvc.vc=self.vc;
            mvc.model=_dataArray[0];
            [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];
            
        }
            break;
        case 21:
        {
            //拒绝推荐
            NSString*urlString=[self interfaceFromString:interface_refuseRecommend];
            NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.orderID]};
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    [self.view makeToast:@"请求成功" duration:1 position:@"center" Finish:^{
                        [self popWithnimation:self.navigationController];
                    }];
                }else{
                
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
//                        [self popWithnimation:self.navigationController];
                    }];
                }
                
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                
            }];
            
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
            [self flowShow];
            NSString*urlString=[self interfaceFromString:interface_delegateCollection];
            NSDictionary*dict=@{@"ids":[NSString stringWithFormat:@"%lu",self.id]};
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                [self flowHide];
                if ([[dict objectForKey:@"rspCode"] intValue]==200) {
                    [self.view makeToast:@"取消成功" duration:1 position:@"center" Finish:^{
                        [collectBtn setBackgroundImage:[UIImage imageNamed:@"ic_un_great"] forState:UIControlStateNormal];
                        self.favoriteFlag=0;
                    }];
                }else{
                    
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                
                [self flowHide];
               [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                
            }];
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
    [self flowShow];
    NSString *urlString = [self interfaceFromString:interface_collectMaster];
    NSDictionary *dic = @{@"masterId":[NSNumber numberWithInteger:self.id]};
    [[httpManager share] POST:urlString parameters:dic success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        [self flowHide];
        if ([[objDic objectForKey:@"rspCode"]integerValue] == 200)
        {
            [self.view makeToast:@"收藏成功!" duration:2.0f position:@"center"];
            self.favoriteFlag=1;
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络繁忙，请稍后重试" duration:1 position:@"center"];
        
    }];
}


#pragma mark-QQShare
-(void)setupQQShare{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    [ShareSDK share:SSDKPlatformSubTypeQQFriend
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%u",self.id],@"shareType":@"1"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}


-(void)requestImageData{

    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,self.model.icon];
    [[httpManager share]POST:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        data=(NSData*)responseObject;
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

-(void)selectShare{
    
    UIActionSheet*actionsheet=[[UIActionSheet alloc]initWithTitle:@"请选择分享的地方" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到QQ" otherButtonTitles:@"分享到微信",@"分享到朋友圈",@"QQ空间", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionsheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self setupQQShare];
        
    }else if (buttonIndex==1){
    
        [self WeiChatShare];
        
    }else if (buttonIndex==2){
    
        [self shareWeichatCircle];
        
    }else if(buttonIndex==3){
        
        [self shareQzone];
    }
    
}



//分享到QQ空间
-(void)shareQzone{

     NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    [ShareSDK share:SSDKPlatformSubTypeQZone
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"shareType":@"2"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];

}

//微信分享
-(void)WeiChatShare{
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url] thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [ShareSDK share:SSDKPlatformSubTypeWechatSession
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"shareType":@"3"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

-(void)shareWeichatCircle{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatParamsByText:recommModel.content title:recommModel.title url:[NSURL URLWithString:recommModel.url] thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 NSString*urlString=[self interfaceFromString:interface_shareToQzone];
                 NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"shareType":@"4"};
                 [self updateOpinionWithDict:dict UrlString:urlString];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
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
