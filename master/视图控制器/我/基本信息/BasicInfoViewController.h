//
//  BasicInfoViewController.h
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
typedef void (^informationBlock)(NSString*name,NSString*icon);
@interface BasicInfoViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,copy)informationBlock block;
@end
