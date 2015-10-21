//
//  MyInfoTableViewCell.m
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "MyInfoTableViewCell.h"
#import "requestModel.h"

@implementation MyInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)normal:(id)sender {
    
    if (self.normalBlock) {
        self.normalBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) upDateWithModel:(long)section :(long)row :(PersonalDetailModel *)model :(NSString *)urlString :(BOOL)type
{
    
    //设置右边箭头
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*inforModel=[[dataBase share]findPersonInformation:delegate.id];
    self.listLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    switch (section)
    {
        case 0:
        {
            self.listLabel.text = @"头像";
           UIImageView *image = [requestModel isDisplayPersonalInfoImage:urlString ];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 60, 60)];
            imageView.image = [UIImage imageNamed:@"头像背景遮罩"];
            imageView.contentMode=3;
            [self.contentView addSubview:image];
            [self.contentView addSubview:imageView];
            
        }
            break;
        case 1:
        {
            
            if (row==0) {
                
                if (inforModel.personalState==1||inforModel.personal==1) {
                    
                    self.accessoryType = 0;;
                    self.toRihgt.constant=20;
                    
                }else{
                    
                    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    self.toRihgt.constant=-10;
                }

                self.listLabel.text=@"姓名";
                self.contentLabel.text=@"点击填写姓名";
//                self.contentLabel.textColor = [UIColor grayColor];
                if ([model.realName isEqualToString:@""]) {
                    self.contentLabel.text=@"";
                }else{
                    self.contentLabel.text=@"";
                    self.contentLabel.text=model.realName;
                    
                }
                
            }
            
           else if (row == 1)
            {
                
                self.listLabel.text = @"性别";
                if ([model.gendar isEqualToString:@""])
                {
                    self.contentLabel.text = @"请选择性别";
                    self.contentLabel.textColor = [UIColor grayColor];
                }
                else
                {
                    self.contentLabel.text = model.gendar;
                    self.contentLabel.textColor = [UIColor blackColor];
                    
                }
                
                if (inforModel.personalState==1||inforModel.personal==1) {
                    
                    self.accessoryType = 0;;
                    self.toRihgt.constant=20;
                    
                }else{
                    
                    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    self.toRihgt.constant=-10;
                }

              
            }
            else if(row==2)
            {
                
                if (inforModel.personalState==1||inforModel.personal==1) {
                    
                    self.accessoryType = 0;;
                    self.toRihgt.constant=20;
                    
                }else{
                    
                    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    self.toRihgt.constant=-10;
                }

                self.listLabel.text = @"籍贯";
                self.contentLabel.text=@"点击选择籍贯";
                NSString *str = [model.nativeProvince objectForKey:@"name"];
                str = [str stringByAppendingFormat:@"-%@",[model.nativeCity objectForKey:@"name"]];
                self.contentLabel.text = str;
                
                
            }else if (row==3){
                
                if (inforModel.personalState==1||inforModel.personal==1) {
                    
                    self.accessoryType = 0;;
                    self.toRihgt.constant=20;
                    
                }else{
                    
                    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    self.toRihgt.constant=-10;
                }

                self.listLabel.text=@"年龄";
                NSString*age;
                self.contentLabel.text=@"点击选择选择出生日期";
                 if (model.birthday) {
                NSArray*birthdayArray=[model.birthday componentsSeparatedByString:@"-"];
                NSString*second=birthdayArray[1];
                NSString*first=birthdayArray[0];
                NSString*third=birthdayArray[2];
                NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-mm-dd"];
                NSString*Date=[formatter stringFromDate:[NSDate date]];
                NSArray*currentTimeArray=[Date componentsSeparatedByString:@"-"];
                NSString*currentFirst=currentTimeArray[0];
                 NSString*currentSecond=currentTimeArray[1];
                 NSDate *date = [NSDate date];
                  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                  NSDateComponents *comps = [[NSDateComponents alloc] init] ;
                  NSInteger unitFlags = NSYearCalendarUnit |
                  NSMonthCalendarUnit |
                  NSDayCalendarUnit |
                  NSWeekdayCalendarUnit |
                  NSHourCalendarUnit |
                  NSMinuteCalendarUnit |
                  NSSecondCalendarUnit;
                  comps = [calendar components:unitFlags fromDate:date];
                  int week = [comps weekday];
                  int year=[comps year];
                  int month = [comps month]; 
                  int day = [comps day];
                  
                  if (day>[third intValue]) {
                      age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]];
                      if (year==[first intValue]) {
                          age=@"0岁";
                      }
                      
                  }
                  else  if ([currentSecond integerValue]>[second integerValue]){
                    self.contentLabel.text = model.birthday;
                    age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]];
                         if (year==[first intValue]) {
                             age=@"0岁";
                         }
                }else{
                    age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]+1];
                    if (year==[first intValue]) {
                        age=@"0岁";
                        
                        }
                    }
                     
                     
                     self.contentLabel.text=age;
                }
            }else if (row==4){
            
                if (inforModel.personalState==1||inforModel.personal==1) {
                    
                    self.accessoryType = 0;;
                    self.toRihgt.constant=20;
                    
                }else{
                    
                    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    self.toRihgt.constant=-10;
                }

                self.listLabel.text=@"岗位";
//                self.contentLabel.textColor=[UIColor lightGrayColor];
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                switch (delegate.userPost) {
                    case 1:
                        self.contentLabel.text=@"雇主";
                        break;
                        case 2:
                        self.contentLabel.text=@"师傅";
                        break;
                        case 3 :
                        self.contentLabel.text=@"工长";
                        break;
                    default:
                        break;
                }
            
            }
        }
            break;
        case 2:
        {
            if (inforModel.personalState==1||inforModel.personal==1) {
                
                self.accessoryType = 0;;
                self.toRihgt.constant=20;
                
            }else{
                
                self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                self.toRihgt.constant=-10;
            }

            if (row == 0)
            {
                self.listLabel.text = @"电话号码";
                if([model.mobile isEqualToString:@""])
                {
                    self.contentLabel.text = @"请输入电话号码";
                    self.contentLabel.textColor = [UIColor grayColor];
                }
                else
                {
                    self.contentLabel.text = model.mobile;
//                    self.contentLabel.textColor = [UIColor lightGrayColor];
                }
            }
            else if (row == 1)
            {
                self.listLabel.text = @"QQ号";
                if([model.qq isEqualToString:@""])
                {
                    self.contentLabel.text = @"请输入QQ号";
                    self.contentLabel.textColor = [UIColor grayColor];
                }
                else
                {
                    self.contentLabel.text = model.qq;
                    self.contentLabel.textColor = [UIColor blackColor];
                }
            }
            else
            {
                self.listLabel.text = @"微信号";
                if([model.weChat isEqualToString:@""])
                {
                    self.contentLabel.text = @"请输入微信号";
                    self.contentLabel.textColor = [UIColor grayColor];
                }
                else
                {
                    self.contentLabel.text = model.weChat;
                    self.contentLabel.textColor = [UIColor blackColor];
                }
            }
        }
            break;
        case 3:
        {
            self.listLabel.text = @"个人认证";
//            NSLog(@"%@",[model.certification objectForKey:@"personal"]);
            if ([[model.certification objectForKey:@"personal"] intValue] == 0 && [[model.certification objectForKey:@"company"] intValue] == 0)
            {
//                self.contentLabel.text = @"未认证";
                if ([[model.certification objectForKey:@"personalState"] intValue] == 0 && [[model.certification objectForKey:@"companyState"] intValue] == 0)
                {
                    self.contentLabel.text = @"未认证";
                }
                else
                {
                    self.contentLabel.text = @"认证中";
                }
            }
//            else  if ([[model.certification objectForKey:@"personal"] intValue] == 0&&[[model.certification objectForKey:@"personalState"] intValue] == 1)
//            {
//                self.contentLabel.text = @"认证中";
//                self.contentLabel.textColor = [UIColor grayColor];
//            }
            else
            {
                self.contentLabel.text = @"已认证";
                self.contentLabel.textColor = [UIColor grayColor];
            }
        }
            break;
        default:
            break;
    }
    
   
   
}
@end
