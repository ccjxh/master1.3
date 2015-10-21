//
//  AppDelegate+setting.m
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate+setting.h"

@implementation AppDelegate (setting)

-(void)setHomePageWithMessage:(BOOL)isHaveMessage Dict:(NSDictionary*)dict{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
     [delegate.signInfo addObserver:self forKeyPath:@"integral" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  context:NULL];  //积分回调
    findMasterViewController*hvc=[[findMasterViewController alloc]init];
    hvc.title=@"找师傅";
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:hvc];
    nc.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    nc.navigationBar.barStyle=1;
    orderViewController*ovc=[[orderViewController alloc]initWithNibName:@"orderViewController" bundle:nil];
    UINavigationController*nc1=[[UINavigationController alloc]initWithRootViewController:ovc];
    nc1.navigationBar.barTintColor=COLOR(67, 172, 219, 1);
    ovc.title=@"订单";
    [nc1.navigationController.navigationBar.layer setMasksToBounds:YES];
    //    nc1.navigationBar.barStyle=1;
    MyViewController*mvc=[[MyViewController alloc]init];
    UINavigationController*nc2=[[UINavigationController alloc]initWithRootViewController:mvc];
    nc2.navigationBar.barStyle=1;
    nc2.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    mvc.title=@"我的";
    UITabBarItem*item1=[[UITabBarItem alloc]initWithTitle:@"找师傅" image: [UIImage imageNamed:@"找师傅-未选择"] selectedImage: [self returnImageFromName:@"找师傅"]];
    UITabBarItem*item2=[[UITabBarItem alloc]initWithTitle:@"找活干" image: [UIImage imageNamed:@"找工作-未选择"] selectedImage: [self returnImageFromName:@"找工作"]];
    UITabBarItem*item3=[[UITabBarItem alloc]initWithTitle:@"我的" image: [UIImage imageNamed:@"我的-未选择"] selectedImage: [self returnImageFromName:@"我的"]];
    findWorkViewController*fvc=[[findWorkViewController alloc]init];
    fvc.title=@"找活干";
    UITabBarItem*friendItem=[[UITabBarItem alloc]initWithTitle:@"消息" image: [UIImage imageNamed:@"我的-未选择"] selectedImage: [self returnImageFromName:@"我的"]];
    UINavigationController*nc4=[[UINavigationController alloc]initWithRootViewController:fvc];
    nc4.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    nc4.navigationBar.barStyle=1;
    
    friendViewController*frvc=[[friendViewController alloc]init];
    frvc.title=@"消息";
    UINavigationController*friendNC=[[UINavigationController alloc]initWithRootViewController:frvc];
    friendNC.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    friendNC.navigationBar.barStyle=1;
    
    UITabBarController*cvc=[[UITabBarController alloc]init];
    cvc.viewControllers=@[nc,nc4,nc2];
    cvc.tabBar.selectedImageTintColor=COLOR(0, 166, 237, 1);
    nc.tabBarItem=item1;
    nc1.tabBarItem=item2;
    nc2.tabBarItem=item3;
    nc4.tabBarItem=item2;
    friendNC.tabBarItem=friendItem;
    self.window.rootViewController=cvc;
    if (isHaveMessage) {
        NSString*str=[dict objectForKey:PUSHKEY];
        NSArray*array=[str componentsSeparatedByString:@"\"type\":\""];
        NSString*type;
        if (array.count>1) {
            type=[array[1] componentsSeparatedByString:@"\"}"][0];
        }
        if ([type isEqualToString:@"masterOrderContact"]==YES||[type isEqualToString:@"masterOrderAccept"]==YES||[type isEqualToString:@"masterOrderReject"]==YES||[type isEqualToString:@"masterOrderFinish"]==YES||[type isEqualToString:@"masterOrderStop"]==YES||[type isEqualToString:@"masterOrderStop"]==YES) {
            cvc.selectedIndex=1;
            NSArray*sepArray=[str componentsSeparatedByString:@"\"entityId\":"];
            NSString*ID=[sepArray[1] componentsSeparatedByString:@","][0];
            MNextOrderDetailViewController*mvc=[[MNextOrderDetailViewController alloc]initWithNibName:@"orderDetailOrderViewController" bundle:nil];
            mvc.id=[ID integerValue];
            [nc1 pushViewController:mvc animated:NO];
            
        }else if ([type isEqualToString:@"personalPass"]==YES||[type isEqualToString:@"personalFail"]==YES||[type isEqualToString:@"masterPostPass"]==YES||[type isEqualToString:@"masterPostFail"]==YES||[type isEqualToString:@"foremanPostPass"]==YES||[type isEqualToString:@"foremanPostFail"]==YES||[type isEqualToString:@"managerPostPass"]==YES||[type isEqualToString:@"managerPostFail"]==YES){
            
        }else if ([type isEqualToString:@"requestRecommend"]==YES){
            cvc.selectedIndex=2;
            myRecommendPeopleViewController*rvc=[[myRecommendPeopleViewController alloc]initWithNibName:@"myRecommendPeopleViewController" bundle:nil];
            rvc.hidesBottomBarWhenPushed=YES;
            [nc2 pushViewController:rvc animated:NO];
        }else if ([type isEqualToString:@"projectAuditPass"]==YES||[type isEqualToString:@"projectAuditFail"]==YES){
            
            cvc.selectedIndex=2;
            myPublicViewController*mvc=[[myPublicViewController alloc]init];
            [nc2 pushViewController:mvc animated:NO];
        }
        
        if (!type) {
            CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"" message:@"当前账号在其他设备登陆,若非本人操作,你的登陆密码可能已经已经泄露,请及时修改密码.紧急情况可以联系客服" buttonTitles:@"确定", nil];
            [dialog showWithCompletion:^(NSInteger selectIndex) {
                
                [self setLogout];
                
            }];
        }
    }
}

-(UIImage*)returnImageFromName:(NSString*)name{
    
    UIImage *img = [UIImage imageNamed:name];
    img =  [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
    
}


@end
