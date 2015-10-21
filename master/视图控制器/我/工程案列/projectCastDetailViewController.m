//
//  projectCastDetailViewController.m
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "projectCastDetailViewController.h"
#import "projectCaseCollectionViewCell.h"
#import "picdisplayViewController.h"
#import "projectCaseAddViewController.h"

@interface projectCastDetailViewController ()<UIAlertViewDelegate>

@end

@implementation projectCastDetailViewController



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.isRefersh=YES;
    [self initDate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
    
    if (self.type!=1) {
        [self customNv];  
    }
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initDate{
    
    
    
    [self flowShow];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    if (!_deleArray) {
        _deleArray=[[NSMutableArray alloc]init];
    }
    [_deleArray removeAllObjects];
       NSString*urlString=[self interfaceFromString:interface_IDmasterProjectCase];
    NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",(long)self.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if (self.isRefersh) {
            [_dataArray removeAllObjects];
        }
        NSArray*array=[dict objectForKey:@"entities"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*inforDic=array[i];
            pictureModel*model=[[pictureModel alloc]init];
            [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"attachment"]];
            [_dataArray addObject:model];
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionview reloadData];
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            self.isRefersh=NO;
            [self flowHide];
            
        });
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        self.isRefersh=NO;
        [self flowHide];
    }];
}

-(void)initUI{

    NSInteger YOrigin;
    if ([[[UIDevice currentDevice]systemVersion ]floatValue]>8) {
        YOrigin=64;
    }else{
        YOrigin=64;
    }
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 5+YOrigin, SCREEN_WIDTH-10, [self accountStringHeightFromString:self.introlduce Width:SCREEN_WIDTH-10]+10)];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.layer.cornerRadius=10;
    label.tag=200;
    label.backgroundColor=COLOR(228, 228, 228, 1);
    label.text=self.introlduce;
    label.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=1;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing=1;
    layout.minimumLineSpacing=1;
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);//设置其边界
    self.collectionview.collectionViewLayout=layout;
    self.collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-label.frame.origin.y-label.frame.size.height) collectionViewLayout:layout];
    self.collectionview.backgroundColor=[UIColor whiteColor];
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    [self.view addSubview:self.collectionview];
    UINib*nib=[UINib nibWithNibName:@"projectCaseCollectionViewCell" bundle:[NSBundle mainBundle]]; 
    [self.collectionview registerNib:nib  forCellWithReuseIdentifier:@"Cell"];
   
}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
        
        return;
    }

    switch (buttonIndex) {
        case 0:
        {
            //说明修改
            projectCaseAddViewController*pvc=[[projectCaseAddViewController alloc]initWithNibName:@"projectCaseAddViewController" bundle:nil];
            pvc.type=1;
            pvc.wordId=self.id;
            pvc.introlduce=self.introlduce;
            pvc.describChangeBlock=^(NSString*str){
            
                
                UILabel*label=(id)[self.view viewWithTag:200];
                label.text=str;
            
            };
            pvc.name=self.name;
            [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
        
        }
            break;
            case 1:
        {
            //删除照片
            _isShow=YES;
            [self customNv];
            [self.collectionview reloadData];
            
        }
            break;
            case 2:
        {
        //添加新照片
            [self setUserHeaderIamge];
            
        }
            break;
            case 3:
        {
        //取消
            
        }
            break;
        default:
            break;
    }


}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pictureModel*model=_dataArray[indexPath.row];
    projectCaseCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.isExitImageBack=NO;
    cell.picModel=model;
    if (self.type==3) {
        
        model=[[pictureModel alloc]init];
        certificateModel*temp=_dataArray[indexPath.row];
        model.id=temp.id;
        model.resource=temp.resource;
        
    }
    cell.isShow=_isShow;
    cell.type=1;
    cell.isSel=model.isSelect;
    cell.block=^{
    _currentIndexPath=indexPath;
        if (model.isSelect) {
            model.isSelect=NO;
        }else{
            model.isSelect=YES;
        }
        [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        [self.collectionview reloadData];
    };
    
    [cell reloadPic];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    [PhotoBroswerVC show:self type:3 index:indexPath.row photoModelBlock:^NSArray *{
        
        NSMutableArray*Array=[[NSMutableArray alloc]init];
        
        for (NSInteger i=0; i<_dataArray.count; i++) {
            pictureModel*model=_dataArray[i];
            NSString*temp=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
            [Array addObject:temp];
        }
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:Array.count];
        for (NSUInteger i = 0; i< Array.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = @"工程说明:";
            if (self.type==3) {
                pbModel.title=@"";
            }
            pbModel.desc = self.introlduce;
            pbModel.image_HD_U = Array[i];
            
            //源frame
            
            projectCaseCollectionViewCell*cell=(projectCaseCollectionViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
//            UIImageView *imageV =(UIImageView *) weakSelf.contentView.subviews[i];
            pbModel.sourceImageView = cell.photos;
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return CGSizeMake((SCREEN_WIDTH-20)/3, (SCREEN_WIDTH-20)/3);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;

}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;

}

-(void)customNv{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
   PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    if (model.skillState!=0&&self.isStars==YES) {
        return;
    }
    
    NSString*title;
    if (_isShow==YES) {
        title=@"删除";
    }else{
        title=@"管理";
    }
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(manager:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}

-(void)manager:(UIButton*)button{
    if ([button.titleLabel.text isEqualToString:@"管理"]==YES) {
        
        UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"工程案例管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改说明",@"删除照片",@"添加新照片", nil];
        [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    }else if([button.titleLabel.text isEqualToString:@"删除"]==YES){
        self.isShow=NO;
        for (NSInteger i=0; i<_dataArray.count; i++) {
            pictureModel*model=_dataArray[i];
            if (model.isSelect==YES) {
                [_deleArray addObject:model];
            }
        }
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"删除提示" message:[NSString stringWithFormat:@"是否删除%lu张照片",(unsigned long)_deleArray.count] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        [self customNv];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            //确定按钮点击时间
            if (_dataArray.count!=0) {
            NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
            NSString*urlString=[self interfaceFromString:interface_deleCommon];
            NSString*temp;
            for (NSInteger i=0; i<_deleArray.count; i++) {
                pictureModel*model=_deleArray[i];
                
                 if (i==0) {
                    temp=[NSString stringWithFormat:@"%lu",(long)model.id];
                }
                else{
                
                    temp=[NSString stringWithFormat:@"%@,%lu",temp,model.id];
                    
                }
                                                         }
                [dict setObject:temp forKey:@"ids"];
                
                
                
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    self.isRefersh=YES;
                    [self initDate];
                }
               [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                    [self.view makeToast:@"当前网络欠佳，请稍后重试" duration:1 position:@"center"];
                
                        }];
            }

        }
            break;
            
        default:
            break;
    }

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


#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //        NSLog(@"image info : %@",info);
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            CGSize imagesize = image.size;
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            
            //将图片转换成二进制
            [self flowShow];
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.5);
            NSString*urlString=[self interfaceFromString:interface_onePicture];
        NSDictionary*dict=@{@"moduleType":@"com.bsf.common.domain.projectcase.MasterProjectCase",@"category":@"case",@"workId":[NSString stringWithFormat:@"%lu",self.id]};
            [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:[@"imagess" stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self flowHide];
                NSDictionary*dict=(NSDictionary*)responseObject;
        
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    [self.view makeToast:@"上传成功" duration:1 position:@"center" Finish:^{
                        
                    }];
                }
                self.isRefersh=YES;
                [self initDate];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
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

@end
