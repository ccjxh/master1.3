//
//  RegisteredViewController.h
//  BaoMaster
//
//  Created by xuting on 15/5/21.
//  Copyright (c) 2015年 xuting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteredViewController : RootViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileButton;
@property (weak, nonatomic) IBOutlet UIView *countButton;
@property (weak, nonatomic) IBOutlet UIView *passwordButton;
@property (weak, nonatomic) IBOutlet UIView *rePasswordButton;
@property (weak, nonatomic) IBOutlet UIView *recommButton;
@property (weak, nonatomic) IBOutlet UITextField *recommendTextfile;

@property (nonatomic,assign) int states; //判断是注册还是忘记密码按钮

@end
