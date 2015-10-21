//
//  recommendStarsViewController.m
//  master
//
//  Created by jin on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "recommendStarsViewController.h"

@interface recommendStarsViewController ()<StarRatingViewDelegate,UITextViewDelegate>

@end

@implementation recommendStarsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _imageWidth=(SCREEN_WIDTH-20-30)/4;
    [self initData];
    [self customNV];
    [self requestToken];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customNV{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 20)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}


-(void)confirm{
   
    NSString*urlString=[self interfaceFromString:interface_comment];
    if (_tx.text.length==0) {
        [self.view makeToast:@"请填写评论内容" duration:1 position:@"center"];
        return;
    }
    if (_pictureArray.count==1) {
    NSMutableDictionary*parent=[[NSMutableDictionary alloc]initWithDictionary: @{@"content":_tx.text,@"scores[0].category.id":@"17",@"scores[1].category.id":@"18",@"scores[2].category.id":@"19",@"order.id":[NSString stringWithFormat:@"%lu",self.id],@"scores[0].score":[NSString stringWithFormat:@"%lu",_skillScore],@"scores[1].score":[NSString stringWithFormat:@"%lu",_serviceScore],@"scores[2].score":[NSString stringWithFormat:@"%lu",_peopleScore]}];
        if (self.token) {
           [parent setObject:self.token forKey:@"token"];
        }
            NSString*acceptSkillId;
            for ( NSInteger j=0; j<_skillArray.count; j++) {
                skillModel*model=_skillArray[j];
                
                if (acceptSkillId) {
                    [parent setObject:acceptSkillId forKey:@"acceptSkillId"];
                }
                if (model.isSelect==YES) {
                    if (acceptSkillId==nil) {
                      acceptSkillId=[NSString stringWithFormat:@"%lu",model.id];
                    }else{
                     acceptSkillId=[NSString stringWithFormat:@"%@,%lu",acceptSkillId,model.id];
                    
                }
            }
        }
        if (acceptSkillId) {
            [parent setObject:acceptSkillId forKey:@"acceptSkillId"];
        }
        [self flowShow];
    [[httpManager share]POST:urlString parameters:parent success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"评价成功" duration:1 position:@"center" Finish:^{
                [self popWithnimation:self.navigationController];
                [self flowHide];
            }];
        
        }
       
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        }];
    }else{
        [self flowShow];
        
        NSMutableDictionary*parent=[[NSMutableDictionary alloc]initWithDictionary: @{@"content":_tx.text,@"scores[0].category.id":@"17",@"scores[1].category.id":@"18",@"scores[2].category.id":@"19",@"order.id":[NSString stringWithFormat:@"%lu",self.id],@"scores[0].score":[NSString stringWithFormat:@"%lu",_skillScore],@"scores[1].score":[NSString stringWithFormat:@"%lu",_serviceScore],@"scores[2].score":[NSString stringWithFormat:@"%lu",_peopleScore]}];
        if (self.token) {
            
            [parent setObject:self.token forKey:@"token"];

        }
        if (_skillArray.count!=0) {
            NSString*acceptSkillId;
            for ( NSInteger j=0; j<_skillArray.count; j++) {
                skillModel*model=_skillArray[j];
                if (j==0) {
                    acceptSkillId=[NSString stringWithFormat:@"%lu",model.id];
                }else{
                    acceptSkillId=[NSString stringWithFormat:@"%@,%lu",acceptSkillId,model.id];
                }
            }
            [parent setObject:acceptSkillId forKey:@"acceptSkillId"];
        }
    [[httpManager share]POST:urlString parameters:parent constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSInteger i=1; i<_picDataArray.count; i++) {
           UIImage*newimage=_pictureArray[i];
        NSData*imageData= UIImageJPEGRepresentation(newimage, 0.1);
    [formData appendPartWithFileData:imageData name:@"files" fileName:
        [NSString stringWithFormat:@"peoplerecommends%u%@",i,@".jpg"] mimeType:@"image/jpg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"评价成功" duration:1 position:@"center" Finish:^{
                    [self popWithnimation:self.navigationController];
                    [self flowHide];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
            [self flowHide];
            
        }];
    
    }

}


-(void)initData{

    if (!_dataArray ) {
        _dataArray=[[NSMutableArray alloc]initWithObjects:@"评星",@"认可的技能",@"内容",@"晒图", nil];
    }
    if (!_pictureArray) {
        _pictureArray=[[NSMutableArray alloc]init];
    }
    [_pictureArray addObject:@""];
    if (!_picDataArray) {
        _picDataArray=[[NSMutableArray alloc]init];
    }
    [_picDataArray addObject:@""];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {

        case 0:{
            if (indexPath.row==0) {
                return [self getStars:tableView Indexpath:indexPath];
            }
            else if (indexPath.row==1){
            return [self getStars:tableView Indexpath:indexPath];
            }
            else{
                return [self getStars:tableView Indexpath:indexPath];
            }
        }
        case 1:{
            
            return [self getSkillCellWithTableview:tableView];
            
        }
            break;
            
        case 2:{
        
            return [self getContent:tableView];
        }
        case 3:{
            
            return [self getPic:tableView];
        }
            
        default:
            break;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"ce"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==2) {
//    skillSelectViewController*svc=[[skillSelectViewController alloc]initWithNibName:@"skillSelectViewController" bundle:nil];
//    svc.Array=_skillArray;
//    svc.skillArray=^(NSMutableArray*values){
//        [_skillArray removeAllObjects];
//        for (NSInteger i=0; i<values.count; i++) {
//            skillModel*model=values[i];
//            [_skillArray addObject:model];
//        }
//        NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:2];
//        NSArray*array=@[path];
//        [self.tableview reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
//    };
//        [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
//  }
}

//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    
    if (_skillArray.count==0) {
        return cell;
    }
    UIView*view=(id)[self.view viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    for (NSInteger i=0; i<_skillArray.count; i++) {
        skillModel*model=_skillArray[i];
        NSInteger width=(SCREEN_WIDTH-20-30)/4;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 5+i/4*30, width-10, 35)];
        label.text=model.name;
        label.tag=200+i;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.layer.cornerRadius=10;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor lightGrayColor];
        label.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeStatus:)];
        tap.numberOfTapsRequired=1;
        [label addGestureRecognizer:tap];
        if (model.isSelect==YES) {
            label.textColor=[UIColor whiteColor];
            label.layer.backgroundColor=[UIColor orangeColor].CGColor;
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=YES;
        [view addSubview:label];
        [cell.contentView addSubview:view];
        cell.selectionStyle=0;
    }
    return cell;
}


-(void)changeStatus:(UITapGestureRecognizer*)tap{

    UILabel*label=(UILabel*)[tap view];
    skillModel*model=_skillArray[[tap view].tag-200];
    if (model.isSelect==YES) {
        model.isSelect=NO;
         label.textColor=[UIColor lightGrayColor];
        label.layer.backgroundColor=[UIColor whiteColor].CGColor;
        label.layer.borderColor=[UIColor blackColor].CGColor;
        
    }else{
        model.isSelect=YES;
        label.textColor=[UIColor whiteColor];
        label.layer.borderWidth=1;
        label.layer.cornerRadius=10;
        label.layer.borderColor=[UIColor orangeColor].CGColor;
        label.layer.backgroundColor=[UIColor orangeColor].CGColor;
    }
    

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 35;
    }
    if (indexPath.section==1) {
        return [self accountSkill];
    }
    if (indexPath.section==2) {
        return 80;
    }
    if (indexPath.section==3) {
        if (_pictureArray.count%3==0) {
            return _pictureArray.count/3*(_imageWidth+5)+20;
        }else{
        
            return (_pictureArray.count/3+1)*(_imageWidth+5)+20;
        }
    }
    
    return 109;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    if (section==1) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 200, 16)];
        label.text=@"认可的技能";
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:16];
        [view addSubview:label];
    }
    
    if (section==3) {
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 200, 16)];
        label.text=@"晒图";
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:16];
        [view addSubview:label];
    }
    view.backgroundColor=COLOR(228, 228, 228, 1);
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 20;
}


-(UITableViewCell*)getStars:(UITableView*)tableview Indexpath:(NSIndexPath*)indexpath{
    NSArray*array=@[@"专业技能",@"服务态度",@"个人诚信"];
    UITableViewCell*Cell=[tableview dequeueReusableCellWithIdentifier:@"Cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell"];
    }
    Cell.selectionStyle=0;
    UIView*view=(id)[self.view viewWithTag:10+indexpath.row];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:Cell.bounds];
    view.tag=10+indexpath.row;
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    label.text=array[indexpath.row];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:15];
    [view addSubview:label];
    TQStarRatingView*ratingview=[[TQStarRatingView alloc]initWithFrame:CGRectMake(90, 5 ,110, 30)numberOfStar:5];
    [ratingview setScore:0.5 withAnimation:YES];
    if (indexpath.row==0) {
        [ratingview setScore:_skillScore  withAnimation:YES];
    }
    if (indexpath.row==1) {
        
        
        [ratingview setScore:_serviceScore  withAnimation:YES];
        
        }
    if (indexpath.row==2) {
        [ratingview setScore:_peopleScore  withAnimation:YES];
        
    }
        ratingview.delegate=self;
        [ratingview setScore:0 withAnimation:YES];
        [view addSubview:ratingview];
    ratingview.tag=indexpath.row+20;
    view.userInteractionEnabled=YES;
    [Cell.contentView addSubview:view];
    return Cell;
}

-(UITableViewCell*)getContent:(UITableView*)tableview{
    UITableViewCell*Cell=[tableview dequeueReusableCellWithIdentifier:@"cell13"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell13"];
    }
    UIView*view=(id)[self.view viewWithTag:55];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:Cell.bounds];
    view.tag=55;
    _tx=[[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, Cell.frame.size.height)];
    _tx.delegate=self;
    _tx.text=_content;
    _tx.textColor=[UIColor blackColor];
    _tx.font=[UIFont systemFontOfSize:15];
    [_tx addSubview:[self createPlace]];
    UILabel*label=(id)[self.view viewWithTag:56];
    if (_tx.text.length!=0) {
        if (label) {
            [label removeFromSuperview];
        }
    }
    view.userInteractionEnabled=YES;
    [view addSubview:_tx];
    [Cell.contentView addSubview:view];
    Cell.selectionStyle=0;
    return Cell;
    
}

-(void)textViewDidChange:(UITextView *)textView{
    UILabel*label=(id)[self.view viewWithTag:56];
    _content=textView.text;
    if (textView.text.length>0) {
        [label removeFromSuperview];
    }else{
        if (label) {
            
        }else{
        
            [textView addSubview:[self createPlace]];
        }
        
    }

}

-(UILabel*)createPlace{

    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    label.textColor=COLOR(228, 228, 228, 1);
    label.font=[UIFont systemFontOfSize:15];
    label.text=@"请输入评价的内容...";
    label.tag=56;
    return label;


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


-(UITableViewCell*)getPic:(UITableView*)tableview{
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"cell14"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell14"];
    }
    cell.selectionStyle=0;
    UIView*view=(id)[self.view viewWithTag:59];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.userInteractionEnabled=YES;
    view.tag=59;

    for (NSInteger i=0; i<self.pictureArray.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i%4*(_imageWidth+10), 10+i/4*(_imageWidth+10), _imageWidth, _imageWidth)];
        if (i==0) {
            [button setImage:[UIImage imageNamed:@"增加图片"] forState:UIControlStateNormal];
            button.backgroundColor=[UIColor blackColor];
            [button addTarget:self action:@selector(photos) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            continue;
        }else{
            UIImage*image=_pictureArray[i];
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%4*(_imageWidth+10), 10+i/4*(_imageWidth+10), _imageWidth, _imageWidth)];
            imageview.image=image;
            UIButton*deleButton=[[UIButton alloc]initWithFrame:CGRectMake(-7, -7, 17, 17)];
            [deleButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
            deleButton.tag=300+i;
//            [deleButton setImage:image forState:UIControlStateNormal];
            [deleButton addTarget:self action:@selector(dele:) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:deleButton];
            [view addSubview:imageview];
        }
        
    }
    [cell.contentView addSubview:view];
    return cell;
}


-(void)dele:(UIButton*)button{
   
    [_pictureArray removeObjectAtIndex:(button.tag-300)];
    NSIndexPath*path=[NSIndexPath indexPathForItem:0 inSection:4];
    NSArray*Array=@[path];
    [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];
}



-(void)photos{
    
    [self setUserHeaderIamge];

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
            
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            CGSize imagesize = image.size;
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            //将图片转换成二进制
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.1);
            [_pictureArray insertObject:imageNew atIndex:1];
            [_picDataArray addObject:imageData];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:3]; //指向cell2的path
            [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:
             UITableViewRowAnimationAutomatic];
//            NSString*urlString=[self interfaceFromString:interface_certainUpload];
//            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//            NSDictionary*dict=@{@"file":@"image",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"certificate",@"workId":[NSString stringWithFormat:@"%lu",delegate.id]};
//            
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


-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
    
    if (view.tag==20) {
        _skillScore=(NSInteger)(score/2*10);
        
        
    }else if (view.tag==21){
        _serviceScore=(NSInteger)(score/2*10);
        
        
    }else if (view.tag==22){
        _peopleScore=(NSInteger)(score/2*10);
    }
}


/**计算技能高度*/
-(CGFloat)accountSkill{
    
    if (_skillArray.count==0) {
        return 50;
    }
    else
    {
        if (_skillArray.count%4==0) {
            
            return self.skillArray.count/4*40+10;
        }
        else
        {
            return (self.skillArray.count/4+1)*40+10;
        }
    }
}


@end
