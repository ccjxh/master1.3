//
//  ModifyInfoViewController.m
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ModifyInfoViewController.h"

@interface ModifyInfoViewController ()

@end

@implementation ModifyInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.modifyInfoTextField.text = self.content;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.modifyInfoTextField.clearButtonMode = UITextFieldViewModeAlways;
    if (self.index == 0)
    {
        self.navigationItem.title = @"电话号码";
        self.modifyInfoTextField.placeholder = @"请输入正确的电话号码";
        if (self.oldMobile) {
            self.modifyInfoTextField.text=self.oldMobile;
                    }
        
    }
    else if (self.index == 1)
    {
        self.navigationItem.title = @"QQ号";
        self.modifyInfoTextField.placeholder = @"请输入正确的QQ号";
    }
    else if (self.index == 2)
    {
        self.navigationItem.title = @"微信号";
        self.modifyInfoTextField.placeholder = @"请输入正确的微信号";
    }
    else if (self.index == 3)
    {
        self.navigationItem.title = @"真实姓名";
        self.modifyInfoTextField.placeholder = @"请输入正确的姓名";
    }
    else  if(self.index == 4)
    {
        self.navigationItem.title = @"身份证";
        self.modifyInfoTextField.placeholder = @"请输入正确的身份证号";
    }
    else if (self.index == 5)
    {
        self.navigationItem.title = @"联系人";
        self.modifyInfoTextField.placeholder = @"请输入联系人";
        if (self.oldName) {
            self.modifyInfoTextField.text=self.oldName;
        }
    }
    else if (self.index == 6)
    {
        self.navigationItem.title = @"备注";
        self.modifyInfoTextField.placeholder = @"请输入备注信息";
        if (self.oldName) {
            self.modifyInfoTextField.text=self.oldName;
        }
    }
    else if (self.index==7){
        self.navigationItem.title = @"所在城市";
        self.modifyInfoTextField.placeholder = @"点击选择城市";
    }
    else if (self.index==8){
        self.navigationItem.title = @"详细地址";
        self.modifyInfoTextField.placeholder = @"点击添加详细地址";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(modifySureButton)];
}
#pragma mark - 修改确定按钮
-(void) modifySureButton
{
    [self.view endEditing:YES];
    switch (self.index)
    {
        case 0:  //判断手机号码是否正确
        {
            NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            
            if ([phoneTest evaluateWithObject: self.modifyInfoTextField.text] )
            {
                _modifyBasicInfoBlock(self.modifyInfoTextField.text,0);
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.view makeToast:@"请输入正确的手机号码" duration:2.0 position:@"center"];
            }

        }
            break;
        case 1:  //判断QQ号是否正确
        {
            NSString *emailRegex =@"[1-9][0-9]{4,}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
            
            if ( self.modifyInfoTextField.text.length<=12|| self.modifyInfoTextField.text.length == 0)   //判断qq是否为空
            {
//                NSLog(@"%@",self.modifyInfoTextField.text);
                self.modifyBasicInfoBlock(self.modifyInfoTextField.text,1);
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.view makeToast:@"请输入正确的QQ号" duration:2.0 position:@"center"];
            }
        }
            break;
        case 2: //判断微信号是否为空
        {
            if (self.modifyInfoTextField.text.length != 0)
            {
                self.modifyBasicInfoBlock(_modifyInfoTextField.text,2);
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.view makeToast:@"请输入正确的微信号" duration:2.0 position:@"center"];
            }
        }
            break;
        case 3:  //判断真实姓名是否为空
        {
            if (self.modifyInfoTextField.text.length != 0)
            {
                self.modifyBasicInfoBlock(self.modifyInfoTextField.text,0);
//                NSLog(@"111%@",self.modifyInfoTextField.text);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.view makeToast:@"请输入真实姓名" duration:2.0 position:@"center"];
            }
        }
            break;
        case 4:  //判断身份证号码是否正确
        {
            if ([self verifyIDCardNumber:self.modifyInfoTextField.text]) {
                self.modifyBasicInfoBlock(self.modifyInfoTextField.text,1);
                [self.navigationController popViewControllerAnimated:YES];
            } else{
                
                [self.view makeToast:@"请输入正确的身份证号码" duration:2.0 position:@"center"];
            }

        }
            break;
        case 5: //判断联系人是否为空
        {
            if (self.modifyInfoTextField.text.length != 0)
            {
                self.modifyBasicInfoBlock(self.modifyInfoTextField.text,0);
//                NSLog(@"111%@",self.modifyInfoTextField.text);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.view makeToast:@"请输入联系人" duration:2.0 position:@"center"];
            }
        }
            break;
        case 6:  //判断备注信息是否为空
        {
            if (self.modifyInfoTextField.text.length != 0)
            {
                self.modifyBasicInfoBlock(self.modifyInfoTextField.text,0);
//                NSLog(@"111%@",self.modifyInfoTextField.text);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.view makeToast:@"请输入备注信息" duration:2.0 position:@"center"];
            }
        }
            break;
        default:
            break;
    }
}

-(BOOL)isQQNumber  {
    NSString *qqRegex = @"^[0-9]+$";
    
    NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqRegex];
    
    return [qqTest evaluateWithObject:self];

}

#pragma mark - 验证身份证是否正确
- (BOOL)verifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

@end
