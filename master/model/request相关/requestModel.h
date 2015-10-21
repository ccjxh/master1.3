//
//  requestModel.h
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalDetailModel.h"
#import "MasterDetailModel.h"

@interface requestModel : NSObject
{
    MBProgressHUD *progressHUD;
}
#pragma mark - 判断请求是否成功
+(void) isRequestSuccess : (NSString*)url : (NSDictionary*)dict  :(UITableView*) tableView;

#pragma mark - 判断个人信息详情是否为空
+(void)isNullPersonalDetail : (PersonalDetailModel *)personalDetailModel;

#pragma mark - 判断师傅详情是否为空
+(void) isNullMasterDetail : (personDetailViewModel *)masterDetailModel;

#pragma mark - 显示个人信息头像和证件照
+(UIImageView *) isDisplayPersonalInfoImage : (NSString *)urlString;

#pragma mark - 判断国籍是否更新成功
+(void) requestRegionInfo : (NSNumber *) regionId;

#pragma mark - 取消收藏
+(void) cancelcollect : (NSNumber *) Id;
@end
