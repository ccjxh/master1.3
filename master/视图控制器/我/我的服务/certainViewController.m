//
//  certainViewController.m
//  master
//
//  Created by jin on 15/8/12.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "certainViewController.h"
#import "projectCaseAddViewController.h"
#import "certainTableViewCell.h"

@interface certainViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation certainViewController
{

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"证书管理";
    [self customNavigation];
    [self CreateFlow];
    [self request];
    [self noData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customNavigation{

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
    [button setTitle:@"新增" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(setUserHeaderIamge) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}




- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }else  {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 255) {
        
        UIImagePickerControllerSourceType sourceType;
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            
            switch (buttonIndex) {
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
            
        }else {
            
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }else {
                
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
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.5);
                //将图片转换成二进制
                NSString*urlString=[self interfaceFromString:interface_certainUpload];
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                NSDictionary*dict=@{@"file":@"image",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"certificate",@"workId":[NSString stringWithFormat:@"%lu",delegate.id]};
                [self flowShow];
                [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:imageData name:@"file" fileName:[@"imagess" stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    
                    
                    
                    [self request];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [self flowHide];
                    [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
                }];
            }
        
    }];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




-(void)request{
    
    self.noDataView.hidden=YES;
    [self flowShow];
        if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    
    NSString*urlString=[self interfaceFromString:interface_myServicerDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        //明星工程解析
        NSArray*pictureArray=[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certificate" ];
        
        //证书解析
        for (NSInteger i=0; i<pictureArray.count; i++) {
            NSDictionary*tempDict=pictureArray[i];
            certificateModel*tempModel=[[certificateModel alloc]init];
            [tempModel setValuesForKeysWithDictionary:tempDict];
            [_dataArray addObject:tempModel];
        }
        
        if (_dataArray.count==0) {
            self.noDataView.hidden=NO;
        }
        
        [_tableview reloadData];
        [self flowHide];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    certainTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"certainTableViewCell" owner:nil options:nil]lastObject];
    }
    certificateModel*model=_dataArray[indexPath.row];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,model.resource]];
    [Cell.contentImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ic_icon_default"]];
    [Cell.contentImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    Cell.contentImage.contentMode =  UIViewContentModeScaleAspectFill;
    Cell.contentImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    Cell.contentImage.clipsToBounds=YES;
    return Cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [PhotoBroswerVC show:self type:3 index:indexPath.row photoModelBlock:^NSArray *{
        
        NSMutableArray*Array=[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<_dataArray.count; i++) {
            certificateModel*model=_dataArray[i];
            NSString*temp=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
            [Array addObject:temp];
        }
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:Array.count];
        for (NSUInteger i = 0; i< Array.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = @"证书";
            pbModel.image_HD_U = Array[i];
            certainTableViewCell*cell=(certainTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            pbModel.sourceImageView = cell.contentImage;
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentIndexPath=indexPath;
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:@"删除提示" message:@"是否删除这张证书" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alter show];
    
    
   }


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        [self flowShow];
        certificateModel*model=_dataArray[_currentIndexPath.row];
        NSString*urlString=[self interfaceFromString:interface_deleCommon];
        NSDictionary*dict=@{@"ids":[NSString stringWithFormat:@"%lu",model.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] intValue]==200) {
                [self.view makeToast:@"删除成功" duration:1 position:@"center" Finish:^{
                    [self request];
                }];
            }else{
            
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            
            [self flowHide];
            [self.view makeToast:@"当前网络不好" duration:1 position:@"center"];
            
        }];
    }else{
    
        NSArray*Array=@[_currentIndexPath];
        [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];
    
    }
    


}

@end
