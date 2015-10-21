//
//  PersonalAuthenticationViewController.m
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "PersonalAuthenticationViewController.h"
#import "ModifyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "PersonalDetailModel.h"
#import "requestModel.h"

@interface PersonalAuthenticationViewController ()
{
    NSArray *personalAuthorArr ;
    NSMutableArray *personalAuthoArr; //保存个人认证
    UIImage *selectImage; //选中的图片
    NSString *resourceURL; //存放图片路径
    BOOL isIdentity;  //判断身份证姓名是否填写
    BOOL isIdNo;  //判断身份证号码是否填写
    BOOL isNoImage;   //判断证件照是否上传
    BOOL isAuthorType;  //认证类型
    NSInteger _currentTag;//当前选择的照片
}
@end

@implementation PersonalAuthenticationViewController

-(void) viewWillAppear:(BOOL)animated
{
    [self flowShow];
}




-(void) viewDidAppear:(BOOL)animated
{
    [self flowHide];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAuthorType=NO;
    isIdentity=NO;
    isIdNo=NO;
    isNoImage=NO;
    
    self.personalAuthorTableView.delegate = self;
    self.personalAuthorTableView.dataSource = self;
    self.personalAuthorTableView.scrollEnabled = NO; //设置表格不被滑动
    [self.personalAuthorTableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"personalAuthorTableView"];
    
    personalAuthoArr = [[NSMutableArray alloc ]initWithObjects:@"",@"",@"",nil];
    personalAuthorArr = @[@"姓名",@"身份证号",@"证件照"];
    self.navigationItem.title = @"个人认证";
    
    //获取当前日期
//    NSDate *senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *locationString=[dateformatter stringFromDate:senddate];
//    self.contentLabel.text = [NSString stringWithFormat:@"于%@提交验证，工作人员将于一工作日内反馈认证结果。请耐心等候!",locationString];
    
    //导航栏按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(personalAuthorSureBtn)];
    [self CreateFlow];
}

#pragma mark - 个人认证确定按钮
-(void) personalAuthorSureBtn
{
    if ([[self.model.certification objectForKey:@"personal"]integerValue] == 1)
    {
        [self popWithnimation:self.navigationController];
    }
    else
    {
        [self flowShow];
        if (isIdentity && isIdNo && isNoImage)
        {
            [self requestPersonalAuthor];
        }
        else if(isIdentity == NO)
        {
            [self.view makeToast:@"请输入真实身份!" duration:2.0f position:@"center"];
            [self flowHide];
        }
        else if (isIdNo == NO)
        {
            [self.view makeToast:@"请输入真实身份证号码!" duration:2.0f position:@"center"];
            [self flowHide];
        }
        else if(isNoImage == NO)
        {
            [self.view makeToast:@"请上传证件照!" duration:2.0f position:@"center"];
            [self flowHide];
        }
    }
}

#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.model.certification objectForKey:@"personal"]integerValue] == 1)
    {
        [self.view makeToast:@"已认证或认证状态用户不支持修改个人信息!" duration:2.0f position:@"bottom"];
    }
    else
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            
            ModifyInfoViewController *ctl = [[ModifyInfoViewController alloc] init];
            if (indexPath.row == 0)
            {
                ctl.content = self.model.realName;
            }
            else
            {
                ctl.content = self.model.idNo;
            }
            ctl.index = indexPath.row + 3;
            ctl.flag = indexPath.row;
            ctl.modifyBasicInfoBlock = ^(NSString *content,long flag){
                
                [personalAuthoArr setObject:content atIndexedSubscript:flag];
                [self.personalAuthorTableView reloadData];
                if (indexPath.row == 0)
                {
                    self.model.realName = content;
                    NSString *urlString=[self interfaceFromString:interface_updateRealName];
                    NSDictionary *dict = @{@"realName":content};
                    [self isRequestSuccess:urlString :dict:indexPath.row];
                    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                                       model.realName=content;
                    [[dataBase share]addInformationWithModel:model];
                }
                else if (indexPath.row == 1)
                {
                    self.model.idNo = content;
                    NSString *urlString=[self interfaceFromString:interface_updateIDNo];
                    NSDictionary *dict = @{@"idNo":content};
                    [self isRequestSuccess:urlString :dict:indexPath.row];
                }
                [self.personalAuthorTableView reloadData];
            };
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
        else
        {
//            [self setUserHeaderIamge];
        }
    }
}

#pragma mark - UITableViewDataSource
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        return 120;
    }
    return 44;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return personalAuthoArr.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInfoTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"personalAuthorTableView"];
    if (cell == nil)
    {
        cell=[[MyInfoTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"personalAuthorTableView"];
    }
   
    cell.listLabel.text = personalAuthorArr[indexPath.row];
    //设置右边箭头
    cell.normalButton.hidden=YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.listLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        if ([self.model.realName isEqualToString:@""])
        {
            cell.contentLabel.text = @"请输入真实姓名";
            cell.normalButton.hidden=YES;
            cell.contentLabel.textColor = [UIColor grayColor];
        }
        else
        {
            cell.contentLabel.text = self.model.realName;
            cell.contentLabel.textColor = [UIColor blackColor];
            isIdentity=YES;
        }
    }
     if (indexPath.row == 1)
    {
        if ([self.model.idNo isEqualToString:@""])
        {
            cell.contentLabel.text = @"请输入真实身份证";
            cell.normalButton.hidden=YES;
            cell.contentLabel.textColor = [UIColor grayColor];
        }
        else
        {
            cell.contentLabel.text = self.model.idNo;
            cell.normalButton.hidden=YES;
            cell.contentLabel.textColor = [UIColor blackColor];
            isIdNo=YES;
        }
    }
    else
    {
        if (self.model.idNoFile != nil)
        {
            isNoImage = YES;
        }
        if (indexPath.row==2) {
            
            
            NSArray*array=@[@"身份证正面照片",@"身份证背面照片"];
            for (UIView*view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            for (NSInteger i=0; i<array.count; i++) {
                UIImageView*photoImage=[[UIImageView alloc]initWithFrame:CGRectMake(13+i*100, 40, 70, 70)];
                photoImage.userInteractionEnabled=YES;
                photoImage.tag=40+i;
                photoImage.image=[UIImage imageNamed:array[i]];
                if (i==0&&self.model.idNoFile) {
                    [photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,self.model.idNoFile]] placeholderImage:[UIImage imageNamed:array[i]]];
                                                }
                if (i==1&&self.model.idNoBackFile) {
                    [photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,self.model.idNoBackFile]] placeholderImage:[UIImage imageNamed:array[i]]];
                }
                photoImage.contentMode =  UIViewContentModeScaleAspectFit;
//                photoImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                photoImage.clipsToBounds=YES;
                UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPhotos:)];
                tap.numberOfTapsRequired=1;
                tap.numberOfTouchesRequired=1;
                [photoImage addGestureRecognizer:tap];
                [cell.contentView addSubview:photoImage];
            }
            
            [self flowHide];
            
        }
       
    }
    return cell;
}


-(void)uploadPhotos:(UITapGestureRecognizer*)tap{

    _currentTag=[tap view].tag;
    if ([tap view].tag==40) {
        //正面照片
        [self setUserHeaderIamge];
        
    }else{
        //反面照片
    
        [self setUserHeaderIamge];
    }

}

#pragma mark - 判断请求是否成功
-(void) isRequestSuccess : (NSString*)url : (NSDictionary*)dict : (long)row
{
    [[httpManager share] POST:url parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200)
        {
            [self.view makeToast:@"更新成功" duration:1.5f position:@"center"];
//            NSLog(@"保存成功");
            if (row == 0)
            {
                isIdentity = YES;
            }
            else if (row == 1)
            {
                isIdNo = YES;
            }
        }
        else
        {
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
//            NSLog(@"保存失败");
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}
#pragma mark - 更换头像
- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self flowShow];
//        NSLog(@"image info : %@",info);
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"])
        {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            CGFloat length;
            if (image.size.width>image.size.height) {
                length=image.size.height;
            }else{
                
                length=image.size.width;
            }
            CGSize imagesize = CGSizeMake(length, length);
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            //将图片转换成二进制
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.1);
            selectImage=nil;
            if (selectImage == nil)
            {
                selectImage = [UIImage imageWithData:imageData];
                NSString*urlString=[self interfaceFromString:interface_uploadHeadImage];
                NSDictionary *dict;
                NSString*type;
                if (_currentTag==40) {
                    type=@"idNo";
                    if (self.model.idNoId==nil) {
    
                        dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNo",@"workId":self.model.id};
                    }else{
                        dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNo",@"workId":self.model.id,@"removeFileId":self.model.idNoId};
                    }
                    
                }else{
                    type=@"idNoBack";
                    if (self.model.idNoBackFileId==nil) {
                    dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNoBack",@"workId":self.model.id,};
                    }else{
                    dict=@{@"file":@"3",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"idNoBack",@"workId":self.model.id,@"removeFileId":self.model.idNoBackFileId};
                    
                    }
                }
                
                    [self flowShow];
                [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSData *data = UIImageJPEGRepresentation(selectImage, 0.5);
                    [formData appendPartWithFileData:data name:@"file" fileName:[@"3" stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    NSLog(@"++++++%@",responseObject);
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [delegate requestInformation];
                    NSDictionary*postDict=@{@"picture":image};
                    NSNotification*notiction=[[NSNotification alloc]initWithName:@"headRefersh" object:nil userInfo:postDict];
                    [[NSNotificationCenter defaultCenter]postNotification:notiction];
                    //                    headimag=image;
                    
                    [self requestInfor];
                    }
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                   
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@" 结果 ===== %@",error);
                    [self flowHide];
                }];
            }
        }
    }];
}

-(void)requestInfor{

    NSString*urlString=[self interfaceFromString:interface_personalDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
             [self flowHide];
            if (_currentTag==40) {
                self.model.idNoFile=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoFile"];
                self.model.idNoId=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoId"];
            }else{
                
                self.model.idNoBackFile=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoBackFile"];
                self.model.idNoBackFileId=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"idNoBackFileId"];
            }
            
        }
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [[dataBase share]updateInformationWithId:delegate.id Attribute:@"personalState" Content:@"1"];
        [self.personalAuthorTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
         [self flowHide];
        
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
    
//    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 判断个人认证是否正确
-(void) requestPersonalAuthor
{
     AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    NSMutableDictionary*parent=[delegate.userInforDic objectForKey:@"certification"];
    [parent setObject:@"1" forKey:@"personalState"];

    NSString *urlString = [self interfaceFromString:interface_uploadIdentity];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
       
        [self flowHide];
        NSDictionary*objDic=(NSDictionary*)responseObject;
        NSString *str = [objDic objectForKey:@"msg"];
        if ([[objDic objectForKey:@"rspCode"] integerValue]==200)
        {
            NSMutableDictionary*parent=[delegate.userInforDic objectForKey:@"certification"];
            [parent setObject:@"1" forKey:@"personalState"];
            [[dataBase share]updateInformationWithId:delegate.id Attribute:@"personalState" Content:@"1"];
            [self.view makeToast:@"资料已提交，请耐心等候!" duration:2.0f position:@"center"];
            if (self.authorTypeBlock)
            {
                isAuthorType = YES;
                self.authorTypeBlock(isAuthorType);
            }
            [self popWithnimation:self.navigationController];
            
        }
        else if ([[objDic objectForKey:@"rspCode"] integerValue]==500)
        {
            [self.view makeToast:str duration:2.0f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
    }];
}



@end
