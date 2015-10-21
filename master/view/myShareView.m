//
//  myShareView.m
//  master
//
//  Created by jin on 15/10/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myShareView.h"

@implementation myShareView
{
    NSInteger _currentTag;//当前分享的方式

}
-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createUI];
    }
    
    return self;

}

-(void)createUI{

    NSArray*array=@[@"qq",@"QQ空间",@"微信",@"朋友圈"];
    NSArray*titleArray=@[@"QQ",@"QQ空间",@"微信",@"朋友圈"];
    for (NSInteger i=0; i<array.count; i++) {
        
        CGFloat space=(SCREEN_WIDTH-26-50*4)/3;
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(13+i*(space+50), 84, 50, 50)];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13+i*(space+50), 144, 50, 16)];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=COLOR(114, 114, 114, 1);
        label.text=titleArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label];
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=10+i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        
    }
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(80, 184, SCREEN_WIDTH-160, SCREEN_WIDTH-160)];
    imageview.image=[UIImage imageNamed:@"二维码"];
    imageview.backgroundColor=[UIColor blackColor];
    UILabel*describeLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(imageview.frame)+24, SCREEN_WIDTH-160, 20)];
    describeLabel.text=@"扫面二维码安装宝师傅";
    describeLabel.textColor=COLOR(123, 123, 123, 1);
    describeLabel.font=[UIFont systemFontOfSize:16];
    UILabel*visitLabel=[[UILabel alloc]initWithFrame:CGRectMake(47, CGRectGetMaxY(describeLabel.frame)+48, SCREEN_WIDTH-96, 25)];
    visitLabel.font=[UIFont systemFontOfSize:24];
    visitLabel.textColor=COLOR(212, 160, 69, 1);
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    visitLabel.text=[NSString stringWithFormat:@"邀请码:%@",[delegate.userInforDic objectForKey:@"inviteCode"]];
    visitLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:visitLabel];
    [self addSubview:describeLabel];
    [self addSubview:imageview];

}

-(void)buttonOnclick:(UIButton*)button{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _currentTag=button.tag-10+1;
    SSDKPlatformType type;
    NSInteger version=button.tag-10+1;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString*finaUrlString=@"http://a.app.qq.com/o/simple.jsp?pkgname=com.bsf.freelance";
//    NSString*parent=[NSString stringWithFormat:SHAREAPPKEY,[NSString stringWithFormat:@"%ld",(long)version]];
//    NSString*finaUrlString=[NSString stringWithFormat:@"%@%@",urlString,SHAREAPPKEY];
    switch (button.tag) {
        case 10:
            //qq好友
        {
            type=SSDKPlatformSubTypeQQFriend;
             NSString*content=[NSString stringWithFormat:@"注册填邀请码获取积分,邀请码是:%@",[delegate.userInforDic objectForKey:@"inviteCode"]];
            [shareParams SSDKSetupQQParamsByText:content title:@"找防水师傅,就上宝师傅" url:[NSURL URLWithString:finaUrlString]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        }
            break;
            case 11:
            //qq空间
        {
            type=SSDKPlatformSubTypeQZone;
              NSString*content=[NSString stringWithFormat:@"注册填邀请码获取积分,邀请码是:%@",[delegate.userInforDic objectForKey:@"inviteCode"]];
            [shareParams SSDKSetupQQParamsByText:content title:@"找防水师傅,就上宝师傅" url:[NSURL URLWithString:finaUrlString]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        }
            break;
        case 12:
        {
            type=SSDKPlatformSubTypeWechatSession;
             NSString*content=[NSString stringWithFormat:@"注册填邀请码获取积分,邀请码是:%@",[delegate.userInforDic objectForKey:@"inviteCode"]];
            [shareParams SSDKSetupWeChatParamsByText:content title:@"找防水师傅,就上宝师傅" url:[NSURL URLWithString:finaUrlString] thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        }
            break;
            case 13:
        {
            type=SSDKPlatformSubTypeWechatTimeline;
            NSString*content=[NSString stringWithFormat:@"注册填邀请码获取积分,邀请码是:%@",[delegate.userInforDic objectForKey:@"inviteCode"]];
            [shareParams SSDKSetupWeChatParamsByText:content title:@"找防水师傅,就上宝师傅" url:[NSURL URLWithString:finaUrlString]  thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        }
            
            break;
        default:
            break;
    }
   
    
   
//       [shareParams SSDKSetupQQParamsByText:@"这么好的app，您值得拥有" title:@"这款app值得拥有" url:[NSURL URLWithString:finaUrlString]   thumbImage:[UIImage imageNamed:@"Icon.png"] image:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
//    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 
                 NSString *urlString=[self interfaceFromString:interface_shareApp];
             NSDictionary*dict=@{@"appKey":@"com.baoself.master",@"shareType":[NSString stringWithFormat:@"%lu",_currentTag]};
                 __weak typeof(self)weakSelf=self;
                 if (_currentTag==2||_currentTag==4) {
                    
                     [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                         NSDictionary*dict=(NSDictionary*)responseObject;
                         if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                             if ([[[[dict objectForKey:@"entity"] objectForKey:@"userShareDTO"] objectForKey:@"firstShare"] integerValue]==1) {
                                 
                                 [weakSelf requestGetIntral];
                             }else{
                             
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                     message:nil
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"确定"
                                                                           otherButtonTitles:nil];
                                 [alertView show];
                             
                             }
                         }
                         
                     } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                         
                     }];

                 }
                //                 NSString
                 
                 
                //                 NSDictionary*dict=@{@"appKey":};
                 
//                 [httpManager share]
                 
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


//首次分享获取积分
-(void)requestGetIntral{

    NSString*urlString=[self interfaceFromString:interface_getIntral];
    NSDictionary*dict=@{@"appKey":@"com.baoself.master",@"shareType":[NSString stringWithFormat:@"%lu",_currentTag]};
    if (_currentTag==2||_currentTag==4) {
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
                if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                delegate.integral=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"showIncreaImage" object:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
        }];
    }


}

@end
