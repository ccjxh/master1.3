//
//  BasicInfoViewController.m
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "ModifyInfoViewController.h" //修改基本信息界面
#import "ModifySexViewController.h" //修改性别界面
#import "PersonalAuthenticationViewController.h" //修改个人认证界面
#import "PeoDetailViewController.h"
#import "requestModel.h" //判断请求是否成功
#import "PersonalDetailModel.h" //解析个人信息详情model
#import "ProvinceTableViewController.h" //省份界面
#import "nameViewController.h"
#import "ChangeDateViewController.h"
#import "MyInformationTableViewCell.h"
#import "personRecommendTableViewCell.h"


@interface BasicInfoViewController ()
{
    UITableView *myInfoTableView;
    PersonalDetailModel *personalDetailModel; //保存个人基本信息model
    UIImage *selectIamge; //更换头像图片
    UIImage *headimag;  //头像
    BOOL isAuthorType; //判断个人认证状态
}
@end

@implementation BasicInfoViewController

-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    
}

-(void)update{
    
    [self requestPersonalDetail];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"basic" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self receiveNotice];
    self.title=@"基本信息";
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
       //注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateRegion:) name:@"basic" object:nil];
    isAuthorType = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    myInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myInfoTableView.delegate = self;
    myInfoTableView.dataSource = self;
    myInfoTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
//    myInfoTableView.scrollEnabled = NO; //设置tableview不被滑动
    [self.view addSubview:myInfoTableView];
    [self CreateFlow];
    [self requestPersonalDetail];
    [myInfoTableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"myInfoTableView"];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];

    
}

-(void) upDateRegion:(NSNotification *)nof
{
    NSDictionary *dict =  nof.object;
    [requestModel requestRegionInfo:[dict objectForKey:@"regionId"]];
    NSArray *arr = [[dict objectForKey:@"region"] componentsSeparatedByString:@"-"];
    NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
    [pDict setObject:arr[0] forKey:@"name"];
    NSMutableDictionary *cDict = [NSMutableDictionary dictionary];
    [cDict setObject:arr[1] forKey:@"name"];

//    NSMutableDictionary *rDict = [NSMutableDictionary dictionary];
//    [rDict setObject:arr[2] forKey:@"name"];
    
    personalDetailModel.nativeProvince = pDict;
    personalDetailModel.nativeCity = cDict;
    
    [myInfoTableView reloadData];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }
    return 50;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 20;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 5;
    }
    else if (section == 2)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
      
        MyInformationTableViewCell*firstCell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
        if (!firstCell) {
            firstCell=[[[NSBundle mainBundle]loadNibNamed:@"MyInformationTableViewCell" owner:nil options:nil]lastObject];
            }
        
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,personalDetailModel.icon];
        firstCell.selectionStyle=0;
        firstCell.name.text=personalDetailModel.realName;
        [firstCell.headImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:headImageName]];
        [firstCell.headImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        firstCell.headImage.contentMode =  UIViewContentModeScaleAspectFill;
        firstCell.headImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        firstCell.headImage.clipsToBounds=YES;
        firstCell.headImage.layer.cornerRadius=firstCell.headImage.frame.size.width/2;
        firstCell.headImage.layer.masksToBounds=YES;
        firstCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return firstCell;

    }
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    
    if (indexPath.section==3) {
       
        personRecommendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"personRecommendTableViewCell" owner:nil options:nil]lastObject];
        }

       
        if ([[[delegate.userInforDic objectForKey:@"certification"] objectForKey:@"personal"]integerValue] == 0)
        {
            //                self.contentLabel.text = @"未认证";personalState
            if ([[[delegate.userInforDic objectForKey:@"certification"] objectForKey:@"personalState"]integerValue] == 0)
            {
                cell.status.text = @"未认证";
                cell.status.textColor=COLOR(251, 128, 20, 1);
                cell.imageWidth.constant=20;
            }
            else
            {
                cell.status.text = @"认证中";
                cell.status.textColor=[UIColor grayColor];
                cell.imageWidth.constant=0;
            }
        }
        else
        {
            cell.status.text = @"已认证";
             cell.imageWidth.constant=0;
            cell.status.textColor = [UIColor grayColor];
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
        }
    
    
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoTableView"];
       if (cell == nil)
    {
        cell = [[MyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myInfoTableView"];
    }
    //设置cell无点击效果
    cell.normalButton.hidden=YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [requestModel isNullPersonalDetail:personalDetailModel];
    [cell upDateWithModel:indexPath.section :indexPath.row :personalDetailModel :personalDetailModel.icon:isAuthorType];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model= [[dataBase share]findPersonInformation:delegate.id];
    switch (indexPath.section)
    {
        case 0:
        {
            [self setUserHeaderIamge];
        }
            break;
        case 1:
        {
            if (model.personal==1||model.personalState==1) {
                [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                return;
            }

            if (indexPath.row==0) {
                if (model.personal==0&&model.personalState==0) {
                nameViewController*nvc=[[nameViewController alloc]initWithNibName:@"nameViewController" bundle:nil];
                nvc.origin=model.realName;
                nvc.contentChange=^(NSString*name){
                        personalDetailModel.realName=name;
                        [myInfoTableView reloadData];
                    };
                [self pushWinthAnimation:self.navigationController Viewcontroller:nvc];
                }else{
                
                    [self.view makeToast:@"已认证或认证中的用户不可修改姓名" duration:1.5f position:@"center"];
                }
            }
            
           else if (indexPath.row == 1)
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                
                ModifySexViewController *ctl = [[ModifySexViewController alloc] init];
                ctl.gendarValueBlock = ^(long gendarId,long tag){
                    NSString *urlString = [self interfaceFromString:interface_updateGendar];
                    NSDictionary *dict = @{@"gendar":[NSNumber numberWithLong:gendarId]};
                    [requestModel isRequestSuccess:urlString :dict : myInfoTableView];
                    if (gendarId == 0)
                    {
                        personalDetailModel.gendar = @"男";
                    }
                    else
                    {
                        personalDetailModel.gendar = @"女";
                    }
                    
                    [myInfoTableView reloadData];
                };
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            }
            else if(indexPath.row==2)
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                

                ProvinceTableViewController *ctl = [[ProvinceTableViewController alloc] init];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"1" forKey:@"type"];
                [defaults synchronize];
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            }else if (indexPath.row==3){
            
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                

                ChangeDateViewController*cvc=[[ChangeDateViewController alloc]init];
                cvc.isfuture=YES;
                cvc.isPass=YES;
                if (model.birthday) {
                    cvc.oldDate=model.birthday;
                    
                }
                cvc.blockDateValue=^(NSString*date){
                        [self flowShow];
                        NSString*urlString=[self interfaceFromString:interface_updateBirthday];
                  NSArray*temp=[date componentsSeparatedByString:@"-"];
                  NSString*birthday=[NSString stringWithFormat:@"%@/%@/%@",temp[0],temp[1],temp[2]];
                   NSDictionary*dict=@{@"birthday":birthday};
                  [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                      NSDictionary*dict=(NSDictionary*)responseObject;
                      [self flowHide];
                      if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                          
                          if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                              delegate.integrity=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
                              
                                }
                          if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                              if (delegate.integral-[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue]>0) {
                                  delegate.integral= [[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"showIncreaImage" object:nil];
                              }
                          }

                          [self.view makeToast:@"更新成功" duration:1 position:@"center" Finish:^{
                             
                              personalDetailModel.birthday=date;
                              [myInfoTableView reloadData];
                          }];
                      }else{
                      
                          [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                            [self flowHide];
                            [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
                            
                    }];
                };
                
                [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
            }
        }
            break;
        case 2:
        {
            ModifyInfoViewController *ctl = [[ModifyInfoViewController alloc] init];
            ctl.index = indexPath.row;
            if (indexPath.row == 0)
            {
                
                return;
            
            }
            else if (indexPath.row == 1)
            {
                ctl.content = personalDetailModel.qq;
            }
            else
            {
                ctl.content = personalDetailModel.weChat;
            }
            ctl.modifyBasicInfoBlock = ^(NSString *content,long tag){
                
                if (indexPath.row == 0)
                {
                    
                }
                else if (indexPath.row == 1)
                {
                    personalDetailModel.qq = content;
                    NSString *urlString = [self interfaceFromString:interface_updateQQ];
                    NSDictionary *dict = @{@"qq":content};
                    [requestModel isRequestSuccess:urlString :dict : myInfoTableView];
                }
                else
                {
                    personalDetailModel.weChat = content;
                    NSString *urlString = [self interfaceFromString:interface_updateweChat];
                    NSDictionary *dict = @{@"weChat":content};
                    [requestModel isRequestSuccess:urlString :dict : myInfoTableView];
                }
                [myInfoTableView reloadData];
            };
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
        case 3:
        {
            
            if ([[personalDetailModel.certification objectForKey:@"personal"]intValue] == 0 && [[personalDetailModel.certification objectForKey:@"personalState"]intValue] == 0 )
            {
                PersonalAuthenticationViewController *ctl = [[PersonalAuthenticationViewController alloc] init];
                ctl.model = personalDetailModel;
                ctl.authorTypeBlock = ^(BOOL authorType){
                    isAuthorType = authorType;
                    [myInfoTableView reloadData];
                };
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            }
            else
            {
                [self.view makeToast:@"已认证或认证状态用户不支持修改个人认证!" duration:2.0f position:@"center"];
                
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 更换头像
- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"预览头像", nil];
        
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 255)
    {
        
        UIImagePickerControllerSourceType sourceType;
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
        {
            switch (buttonIndex)
            {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    case 2:
                {
                
                    if (personalDetailModel.icon) {
                        
                        NSIndexPath*index=[NSIndexPath indexPathForItem:0 inSection:0];
                        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,personalDetailModel.icon];
                        NSMutableArray*urlArray=[[NSMutableArray alloc]initWithObjects:urlString, nil];
                        MyInformationTableViewCell*cell=(MyInformationTableViewCell*)[myInfoTableView cellForRowAtIndexPath:index];
                        [self displayPhotosWithIndex:index.row Tilte:@"" describe:@"" ShowViewcontroller:self UrlSarray:urlArray ImageView:cell.headImage];
                        
                    }else{
                     
                        [self.view makeToast:@"您还没有上传头像" duration:1 position:@"center"];
                    }
                    
                }
                case 3:
                    // 取消
                    return;
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }
            else
            {
                return;
            }
        }
        
        // 跳转到相机或相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //设置拍照后的图片可被编辑
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self flowShow];
//        NSLog(@"image info : %@",info);
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            CGFloat length;
            if (image.size.width>image.size.height) {
                length=image.size.height;
            }else{
            
                length=image.size.width;
            }
            CGSize imagesize = CGSizeMake(length, length);
             UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            [self flowShow];
            //将图片转换成二进制
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.5);
            if (selectIamge == nil)
            {
                selectIamge = [UIImage imageWithData:imageData];
                NSString*urlString=[self interfaceFromString:interface_uploadHeadImage];
                NSDictionary *dict = @{@"file":@"2",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"icon",@"workId":personalDetailModel.id};
                [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSData *data = UIImageJPEGRepresentation(selectIamge, 0.5);
                    [formData appendPartWithFileData:data name:@"file" fileName:[@"2" stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self flowHide];
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                        [self.view makeToast:@"头像更换成功" duration:1 position:@"center" Finish:^{
                        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                           NSDictionary *entityDic = responseObject[@"entity"];
                            NSDictionary *attachmentDic = entityDic[@"user"];
                            personalDetailModel.icon = attachmentDic[@"icon"];
                            if (self.block) {
                                self.block(@"",personalDetailModel.icon);                    }
                            [myInfoTableView reloadData];
                      if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                          delegate.integrity=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
                          
                            }

                        if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                                if (delegate.integral-[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue]>0) {
                                    delegate.integral= [[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"showIncreaImage" object:nil];
                                }
                            }
 
                        }];
                    }else{
                    
                        [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     NSLog(@" 结果 ===== %@",error);
                    [self flowHide];

                }];
            }
        }
    }];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 请求个人详情
-(void) requestPersonalDetail
{
    [self flowShow];
    NSString *urlString = [self interfaceFromString:interface_personalDetail];
    [[httpManager share] GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary *dict = (NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSDictionary *entityDic = [dict objectForKey:@"entity"];
            NSDictionary *userDic = [entityDic objectForKey:@"user"];
            personalDetailModel = [[PersonalDetailModel alloc] init];
            [personalDetailModel setValuesForKeysWithDictionary:userDic];
            [myInfoTableView reloadData];
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
       
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
         [self.view makeToast:@"当前网络不好" duration:1 position:@"center"];
    }];
}

@end
