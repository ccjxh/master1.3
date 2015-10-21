//
//  requestModel.m
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "requestModel.h"

@implementation requestModel

+(void) isRequestSuccess : (NSString*)url : (NSDictionary*)dict :(UITableView*) tableView
{
    [[httpManager share] POST:url parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200){
            [delegate requestInformation];
          //integral
            if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                delegate.integrity=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
                    }
            if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                if (delegate.integral-[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue]>0) {
                    delegate.integral= [[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                    NSDictionary*parent=@{@"value":[NSString stringWithFormat:@"%lu",delegate.integral]};
                    NSNotification*noction=[[NSNotification alloc]initWithName:@"showIncreaImage" object:nil userInfo:parent];
                    [[NSNotificationCenter defaultCenter]postNotification:noction];
                }
            }
            
            
        } else {

        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

+(void)isNullPersonalDetail : (PersonalDetailModel *)personalDetailModel
{
    if (personalDetailModel.gendar == nil) {
        personalDetailModel.gendar = @"";
    }
    if(personalDetailModel.qq == nil){
        personalDetailModel.qq = @"";
    }
    if (personalDetailModel.mobile == nil){
        personalDetailModel.mobile = @"";
    }
    if (personalDetailModel.weChat == nil){
        personalDetailModel.weChat = @"";
    }
    if (personalDetailModel.idNo == nil){
        personalDetailModel.idNo = @"";
    }
    if (personalDetailModel.realName == nil) {
        personalDetailModel.realName = @"";
    }
    //    if (personalDetailModel.certification == nil) {
    //        personalDetailModel.certification = @"";
    //    }
}

+(void) isNullMasterDetail : (personDetailViewModel *)masterDetailModel
{
    if (masterDetailModel.qq == nil) {
        masterDetailModel.qq = @"";
    }
    if (masterDetailModel.realName == nil) {
        masterDetailModel.realName = @"";
    }
    if (masterDetailModel.idNo == nil) {
        masterDetailModel.idNo = @"";
    }
    if (masterDetailModel.mobile == nil) {
        masterDetailModel.mobile = @"";
    }
    if (masterDetailModel.weChat == nil) {
        masterDetailModel.weChat = @"";
    }
    if (masterDetailModel.age == nil) {
        masterDetailModel.age = 0;
    }
    if (masterDetailModel.id == nil) {
        masterDetailModel.id = 0;
    }
    if (masterDetailModel.gendar == nil) {
        masterDetailModel.gendar = @"";
    }
    if (masterDetailModel.idNoFile == nil) {
        masterDetailModel.idNoFile = @"";
    }
    if (masterDetailModel.icon == nil) {
        masterDetailModel.icon = @"";
    }
    if (masterDetailModel.iconId == nil) {
        masterDetailModel.gendar = @"";
    }
    if (masterDetailModel.idNoId == nil) {
        masterDetailModel.idNoId = 0;
    }
}

+(UIImageView *) isDisplayPersonalInfoImage:(NSString *)urlString
{
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.frame = CGRectMake(SCREEN_WIDTH-100, 10, 60, 60);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,urlString]];
    [headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:headImageName]];
//    dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
//    dispatch_async(queue, ^{
//        //将URL转换成二进制
//        NSData *resultData = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [UIImage imageWithData:resultData];
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            headImage.image = img;
//        });
//    });
    return headImage;
}

+(void) requestRegionInfo : (NSNumber *) regionId
{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *urlString = [self interfaceFromString:interface_updateRegion];
    NSDictionary *dict = @{@"regionId":regionId};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        if ([[objDic objectForKey:@"rspCode"]integerValue] == 200)
        {
            
            if ([[[objDic objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                delegate.integrity=[[[[objDic objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
            }
            if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                if (delegate.integral-[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue]>0) {
                    delegate.integral= [[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                    NSDictionary*parent=@{@"value":[NSString stringWithFormat:@"%lu",delegate.integral]};
                    NSNotification*noction=[[NSNotification alloc]initWithName:@"showIncreaImage" object:nil userInfo:parent];
                    [[NSNotificationCenter defaultCenter]postNotification:noction];
                }
            }

            NSLog(@"国籍更新成功!");
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

+(void) cancelcollect : (NSNumber *) Id
{
    NSString *urlString = [self interfaceFromString:interface_cancelCollect];
    [[httpManager share] POST:urlString parameters:Id success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        NSDictionary *objDic = (NSDictionary *)responseObject;
//        if (<#condition#>) {
//            <#statements#>
//        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

@end
