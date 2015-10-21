//
//  LoginViewController.h
//  BaoMaster
//
//  Created by xuting on 15/5/21.
//  Copyright (c) 2015年 xuting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *resignButton;
@property (weak, nonatomic) IBOutlet UIButton *help;
@property (weak, nonatomic) IBOutlet UIButton *forget;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
