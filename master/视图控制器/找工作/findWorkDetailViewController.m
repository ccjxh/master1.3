//
//  findWorkDetailViewController.m
//  master
//
//  Created by jin on 15/8/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findWorkDetailViewController.h"
#import "findWorkDetail.h"
@interface findWorkDetailViewController ()

@end

@implementation findWorkDetailViewController
{
    findWorkDetailModel*detailModel;
    findWorkDetail*view;
    masterModel*recommModel;//分享的数据模型
    NSInteger _currentIndex;//分享类型
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self CreateFlow];
    [self requestshare];
    [self customNavigation];
    [self requestInformation];
    
    
            // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(void)initUI{

    view=[[findWorkDetail alloc]init];
    if (!self.title) {
        
        self.title=@"招工详情";

    }
    __weak typeof(self)WeSelf=self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    view.deleBlock=^(NSInteger ID){
    
        [WeSelf requestTokenWithID:ID];
    
    };
    view.type=self.type;
    view.reportBlock=^{
        
        [WeSelf report];
    
    };
    self.view=view;
   
}


-(void)report{

    opinionViewController*opinion=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
    opinion.title=@"举报";
    opinion.limitCount=200;
    opinion.type=1;
    opinion.contentBlock=^(NSString*content){
    
        NSString*urlString=[self interfaceFromString:interface_reportInfo];
        NSDictionary*dict=@{@"problem":content,@"checkUser.id":[NSString stringWithFormat:@"%lu",self.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] intValue]==200) {
                [self.view makeToast:@"提交成功" duration:1 position:@"center"];
            }else{
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
           
            [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        }];
    };
    
    [self pushWinthAnimation:self.navigationController Viewcontroller:opinion];

}


-(void)deleWithID:(NSInteger)ID{

    NSString*urlString=[self interfaceFromString:interface_delePublic];
    NSDictionary*dict=@{@"token":self.token,@"id":[NSString stringWithFormat:@"%lu",ID]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
        [self.view makeToast:@"删除成功" duration:1 position:@"center" Finish:^{
            
            if (self.removeBlock) {
                self.removeBlock(ID);
            }
            
            [self popWithnimation:self.navigationController];
        }];
        
        }else{
            
            NSString*str=[[dict objectForKey:@"msg"] componentsSeparatedByString:@" "][0];
            [self.view makeToast:[NSString stringWithFormat:@"网络异常%@",str] duration:1 position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        
    }];

}


-(void)requestInformation{
    
    [self flowShow];
   
    NSString*urlstring=[self interfaceFromString:interface_findWorkDetail];
    NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id]};
    
    [[httpManager share]POST:urlstring parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSDictionary*inforDict=[[dict objectForKey:@"entity"] objectForKey:@"project"];
            detailModel=[[findWorkDetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:inforDict];
            view.model=detailModel;
            [view.tableview reloadData];
            
        }else{
        
            NSString*temp=[[dict objectForKey:@"msg"]componentsSeparatedByString:@"."][0];
            
            [self.view makeToast:[NSString stringWithFormat:@"出现异常%@",temp] duration:1 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        
    }];

}


-(void)requestTokenWithID:(NSInteger)ID{
    
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        [self deleWithID:ID];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}


-(void)customNavigation{

    UIButton*rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 20, 20);
    [rightButton setImage:[UIImage imageNamed:@"btn_chare_normal"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}



-(void)share{

    [self selectShare];

}


-(void)selectShare{
    
    UIActionSheet*actionsheet=[[UIActionSheet alloc]initWithTitle:@"请选择分享的地方" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到QQ" otherButtonTitles:@"分享到微信",@"分享到朋友圈",@"QQ空间", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionsheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _currentIndex=buttonIndex+1;
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
                 NSString*urlString=[self interfaceFromString:interface_shareWorkInfor];
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


-(void)requestshare{
    
    
    recommModel=[[masterModel alloc]init];
    recommModel.url=[NSString stringWithFormat:@"%@/admin/share/projectDetail?id=%lu",changeURL,self.id];
    recommModel.title=@"向您分享了一个招工信息";
    recommModel.content=[NSString stringWithFormat:@"%@",@""];
    
    
}


@end
