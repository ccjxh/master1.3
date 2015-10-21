//
//  projectCaseAddViewController.m
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "projectCaseAddViewController.h"
#import "TableViewCell.h"
@interface projectCaseAddViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@end

@implementation projectCaseAddViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestToken];
    _currentTableview=self.tableview;
    self.tableview.separatorStyle=0;
    [self initData];
    [self initUI];
    NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:0];
    nameTableViewCell*cell=(nameTableViewCell*)[self.tableview cellForRowAtIndexPath:path];
    [cell.tx becomeFirstResponder];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{

    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}

-(void)confirm{
    
    UITextField*tx1=(id)[self.view viewWithTag:10];
    UITextView*tx2=(id)[self.view viewWithTag:11];
    [tx1 resignFirstResponder];
    [tx2 resignFirstResponder];
    if (self.type==0) {
    if (tx1.text.length==0) {
        [self.view makeToast:@"案例名称不能为空" duration:1 position:@"center"];
        [self flowHide];
        return;
    }
    if (tx2.text.length==0) {
        [self.view makeToast:@"案例说明不能为空" duration:1 position:@"center"];
        [self flowHide];
        return;
    }
    if (_picArray.count<=1) {
        [self.view makeToast:@"案例图片不能为空" duration:1 position:@"center"];
        return;
    }
        
        [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_projectUpload];
    NSDictionary*dict=@{@"caseName":tx1.text,@"introduce":tx2.text,@"type":[NSString stringWithFormat:@"%lu",self.caseType]};
    if (self.token) {
            dict=@{@"caseName":tx1.text,@"introduce":tx2.text,@"type":[NSString stringWithFormat:@"%lu",self.caseType],@"token":self.token};
        }
        
    [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i=1; i<_picArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(_picArray[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"files" fileName:[NSString stringWithFormat:@"image%lu.jpg",i] mimeType:@"image/jpg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"提交成功" duration:1 position:@"center" Finish:^{
                [self popWithnimation:self.navigationController];
                if (self.refershBlocl) {
                    self.refershBlocl();
                }
            }];
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self flowHide];
                [self.view makeToast:@"网络异常，请稍候重试" duration:1 position:@"center"];
        }];
    }
    if (self.type==1) {
        NSString*urlStrng=[self interfaceFromString:interface_adminProjecrCase];
    NSDictionary*dict=@{@"caseName":tx1.text,@"introduce":tx2.text,@"id":[NSString stringWithFormat:@"%lu",self.wordId]};
        [[httpManager share]POST:urlStrng parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"修改成功" duration:1 position:@"center" Finish:^{
                    
                    
                        if (self.describChangeBlock) {
                            self.describChangeBlock(tx2.text);
                        }
                    
                    [self popWithnimation:self.navigationController];
                }];
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
        }];
        
    }

}




-(NSString*)requestToken{
    
    __block NSString*token;
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    return token;
}



-(void)initData{
    if (!_picArray) {
        _picArray=[[NSMutableArray alloc]init];
    }
    [_picArray addObject:@""];
    if (!_imageArray) {
        _imageArray=[[NSMutableArray alloc]init];
    }
    UIImage*image=[UIImage imageNamed:@"增加图片"];
    [_imageArray addObject:image];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type==0) {
    return 3;
    }
    if (self.type==1) {
        return 2;
    }
    return 1;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==0||self.type==1) {
    if (indexPath.section<=1) {
        if (indexPath.section==0) {
            nameTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"nameTableViewCell" owner:nil options:nil]lastObject];
                cell.selectionStyle=0;
            }
            if (self.name) {
                cell.tx.text=self.name;
            }
            cell.tx.borderStyle=UITextBorderStyleNone;
                cell.tx.tag=10;
            return cell;
        }
        if (indexPath.section==1) {
            projectCaseAddTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"projectCaseAddTableViewCell" owner:nil options:nil]lastObject];
                cell.tx.placeholder=@"请输入";
                cell.selectionStyle=0;
            }
            if (self.introlduce) {
                cell.tx.text=self.introlduce;
            }
            cell.tx.tag=11;
            cell.tx.delegate=self;
            return cell;
            }
    
        }
    }
    TableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[TableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    cell.picArray=_picArray;
    cell.block=^(NSInteger blockType,id objc){
        switch (blockType) {
            case 1:
            {
            //拍照
                [self setUserHeaderIamge];
            }
                break;
                case 2:
            {
            //删除
                UIImage*image=(UIImage*)objc;
                [self.picArray removeObject:image];
                
                
                NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:2];
                NSArray*array=@[path];
                [self.tableview reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                
                break;
            default:
                break;
        }
    
    };
    [cell reloadData];
    return cell;
    
}

-(void)createLabel:(UITableView*)tableview{
    NSIndexPath*path=[NSIndexPath indexPathForRow:0 inSection:1];
    projectCaseAddTableViewCell*cell=(projectCaseAddTableViewCell*)[tableview cellForRowAtIndexPath:path];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:15];
    label.text=@"请输入";
    [cell.tx addSubview:label];
    label.tag=30;
}

-(void)textViewDidChange:(UITextView *)textView{

    UILabel*label=(id)[self.view viewWithTag:30];
    if (textView.text.length==0) {
        if (!label) {
            [self createLabel:_currentTableview];
        }
    }else{
        if (label) {
            [label removeFromSuperview];
        }
    
    }


}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 NSInteger width=(SCREEN_WIDTH-30)/3;
    if (indexPath.section==0) {
        if (self.type==2) {
            if (_picArray.count%3==0) {
                return _picArray.count/3*(width+5)+20;
            }else{
                
                return (_picArray.count/3+1)*(width+5)+20;
            }
        }
        return 54;
    }else if (indexPath.section==1){
    
        return 60;
    }else if (indexPath.section==2){
        if (_picArray.count%3==0) {
            return _picArray.count/3*(width+5)+10;
        }else{
        
            return (_picArray.count/3+1)*(width+5)+10;
        }
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;

}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray*array=@[@"工程案例名称",@"工程案例说明",@"工程案例照片"];
    return array[section];
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
//        imagePickerController.sourceType = sourceType;
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
            [self.picArray insertObject:image atIndex:1];
            NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:2];
            NSArray*Array=@[path];
            [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];
            //将图片转换成二进制
            
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
