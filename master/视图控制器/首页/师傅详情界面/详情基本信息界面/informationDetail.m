//
//  informationDetail.m
//  master
//
//  Created by jin on 15/8/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "informationDetail.h"
#import "requestModel.h"

@implementation informationDetail

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self initUI];
        [self createHead];
        
    }
    
    return self;

}



-(void)initUI{

    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-110)];
    self.tableview.backgroundColor=COLOR(246, 246, 246, 1);
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=0;
    [self addSubview:self.tableview];
   
}


-(void)createHead{

    self.contentLabel.textColor=COLOR(201, 201, 201, 1);
    self.checkButton.backgroundColor=COLOR(22, 167, 232, 1);
    [self.checkButton addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count==4) {
        if (section==1) {
            return 1;
        }
        if (section==2) {
            return 5;
        }
    }
    if (self.dataArray.count==3) {
        if (section==1) {
            return 5;
        }
    }
    
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 115;
    }else if (indexPath.section==1)
    {
        if (self.dataArray.count==3) {
            return [self returnInformationHeightWith:indexPath];
        }else{
            
            NSMutableArray*temp=[[NSMutableArray alloc]init];
            for (NSInteger i=0; i<self.model.certificate.count; i++) {
                certificateModel*model=[[certificateModel alloc]init];
                [model setValuesForKeysWithDictionary:self.model.certificate[i]];
                [temp addObject:model];
            }
            return [self accountPictureFromArray:temp];
        }
        
    }else if (indexPath.section==2){
        if (self.dataArray.count==3) {
            return 40;
        }else{
            
            return [self returnInformationHeightWith:indexPath];
        }
        
    }
    
    return 40;

}



-(CGFloat)returnInformationHeightWith:(NSIndexPath*)indexPath{

    if (indexPath.row==0) {
        NSMutableArray*skillArray=[[NSMutableArray alloc]init];
        for (NSInteger i=0; i<[[self.model.service objectForKey:@"servicerSkills"] count]; i++){
            skillModel*model=[[skillModel alloc]init];
            [model setValuesForKeysWithDictionary:[self.model.service objectForKey:@"servicerSkills"][i]];
            [skillArray addObject:model];
        }
        
        return [self accountSkillWithAllSkill:skillArray]-25;
    }
        else if (indexPath.row==4){
        
        if ([self accountStringHeightFromString:[self.model.service objectForKeyedSubscript:@"serviceDescribe"] Width:SCREEN_WIDTH-110]>16) {
            
            return [self accountStringHeightFromString:[self.model.service objectForKeyedSubscript:@"serviceDescribe"] Width:SCREEN_WIDTH-110]+40;
        }
            
        return 60;
    }
    return 30;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return 0;
    }
    return 20;

}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    label.backgroundColor=COLOR(246, 246, 246, 1);
    return label;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    peopleDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"peopleDetailTableViewCell"];
    if (cell1 == nil)
    {
        cell1=[[[NSBundle mainBundle]loadNibNamed:@"peopleDetailTableViewCell" owner:nil options:nil]lastObject];
        
    }
    __weak typeof(peopleDetailTableViewCell*)weCell=cell1;
    cell1.displayBlock=^(NSString*iconString){
    
        if (self.headImageBlock) {
            self.headImageBlock(iconString,weCell);
        }
    
    };
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //这里需要修改
    
    [requestModel isNullMasterDetail:self.model];
    [cell1 upDateWithModel:self.model];
    if (indexPath.section==0) {
        return cell1;
        
    }else if (indexPath.section==1){
        if (self.dataArray.count==4) {
            return [self getCertainCellWithTableview:tableView];
        }else if (self.dataArray.count==3){
            UITableViewCell*cell=[self getTableViewCellWithTable:tableView IndexPath:indexPath];
            cell.selectionStyle=0;
            return cell;
        }
    }else if (indexPath.section==2){
        
        if (self.dataArray.count==3) {
            return [self getCheckCell:tableView];
        }else{
            
            return [self getTableViewCellWithTable:tableView IndexPath:indexPath];
        }
    }
    if (indexPath.section==3) {
        
        return [self getCheckCell:tableView];
        
    }
    
    return nil;
}



-(void)check{

    if (self.checkBlock) {
        self.checkBlock();
    }

}



-(UITableViewCell*)getTableViewCellWithTable:(UITableView*)table IndexPath:(NSIndexPath*)indexpath{
    
     NSArray*Array=@[@"专业技能",@"电话",@"期望薪资",@"日程",@"服务介绍"];
    commendTableViewCell*Cell=[table dequeueReusableCellWithIdentifier:@"CELL"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"commendTableViewCell" owner:nil options:nil]lastObject];
    }
    Cell.selectionStyle=0;
    Cell.name.text=Array[indexpath.row];
    NSMutableArray*skillArray=[[NSMutableArray alloc]init];
    if (indexpath.row==0) {
        for (NSInteger i=0; i<[[self.model.service objectForKey:@"servicerSkills"] count]; i++){
            skillModel*model=[[skillModel alloc]init];
            [model setValuesForKeysWithDictionary:[self.model.service objectForKey:@"servicerSkills"][i]];
            [skillArray addObject:model];
        }
        UITableViewCell*cell= [self getSkillCellWithTableview:table SkillArray:skillArray];
        cell.selectionStyle=0;
        
        return cell;
    
    }
    
    
    if (indexpath.row==1) {
        if (self.model.mobile) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.model.mobile];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            Cell.content.attributedText=str;
            Cell.content.textColor=COLOR(74, 166, 216, 1);
        }
        
        return Cell;
    
    }
    
    if (indexpath.row==2) {
        
        if ([[[self.model.service objectForKey:@"payType"] objectForKey:@"name"] isEqualToString:@"面议"]==YES) {
            Cell.content.text=@"面议";
            Cell.contentStr=@"面议";
            return Cell;
            
        }else if (![[self.model.service objectForKey:@"payType"] objectForKey:@"name"]){
        Cell.content.text=@"";
            return Cell;
        }else {
        
            
            Cell.content.text=[NSString stringWithFormat:@"%.2f%@",[[self.model.service objectForKey:@"expectPay"] floatValue],[[self.model.service objectForKey:@"payType"] objectForKey:@"name"]];
        }
        Cell.contentStr=[NSString stringWithFormat:@"%.2f%@",[[self.model.service objectForKey:@"expectPay"] floatValue],[[self.model.service objectForKey:@"payType"] objectForKey:@"name"]];
        return Cell;
    }
        if (indexpath.row==3) {
            
            Cell.content.text=[self.model.service objectForKey:@"workStatus"];
            
            return Cell;
        }
//        if (indexpath.row==4) {
//            
//            NSString*adressStr;
//            for (NSInteger i=0; i<[[self.model.service objectForKey:@"serviceRegions"] count]; i++) {
//                if (i==0) {
//                    adressStr=[self.model.service objectForKey:@"serviceRegions"][0];
//                }else{
//                    
//                    adressStr=[NSString stringWithFormat:@"%@、%@",adressStr,[self.model.service objectForKey:@"serviceRegions"][i]];
//                }
//                
//            }
//            Cell.contentStr=adressStr;
//            Cell.content.text=adressStr;
//            [Cell reloadData];
//            return Cell;
//        }
        if (indexpath.row==4) {
            Cell.content.text=@"";
            if ([self.model.service objectForKey:@"serviceDescribe"]) {
                Cell.content.text=[self.model.service objectForKey:@"serviceDescribe"];
                Cell.contentStr=[self.model.service objectForKey:@"serviceDescribe"];
            }
            [Cell reloadData];
            return Cell;
 
        }


    UITableViewCell*Cell1=[table dequeueReusableCellWithIdentifier:@"CELL1"];
        return Cell1;

}


-(UITableViewCell*)getCertainCellWithTableview:(UITableView*)tableView{
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell1"];
    }
    cell.selectionStyle=0;
    cell.detailTextLabel.numberOfLines=0;
    UIView*view=(id)[self viewWithTag:45];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=45;
    for (NSInteger i=0; i<self.model.certificate.count; i++) {
        CGFloat height;
        NSInteger width=(SCREEN_WIDTH-40)/4;
        certificateModel*model=[[certificateModel alloc]init];
        NSDictionary*temp=self.model.certificate[i];
        [model setValuesForKeysWithDictionary:temp];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        if (self.model.certificate.count%4==0) {
            height=self.model.certificate.count/4*40;
        }
        else{
            height=(self.model.certificate.count/4+1)*40;
            
        }
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 10+i/4*(width+5), width, width)];
        imageview.tag=20+i;
        imageview.userInteractionEnabled=YES;
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString]];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(open:)];
        tap.numberOfTapsRequired=1;
        imageview.tag=30+i;
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.clipsToBounds=YES;
        [imageview addGestureRecognizer:tap];
        [view addSubview:imageview];
    }
    view.userInteractionEnabled=YES;
    cell.selectionStyle=0;
    [cell.contentView addSubview:view];
    return cell;
}


-(void)open:(UITapGestureRecognizer*)tap{

    if (self.imageDisplay) {
        UIImageView*imageview=(UIImageView*)[self viewWithTag:[tap view].tag];
        self.imageDisplay([tap view].tag-30,imageview,self.model);
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (self.tableDisSelected) {
        self.tableDisSelected(indexPath,self.model);
    }
}



-(UITableViewCell*)getCheckCell:(UITableView*)tableview {
    
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    cell.textLabel.text=@"内容信息不实?";
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    UIView*view=(id)[self viewWithTag:10];
    if (view) {
        
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH-120, cell.frame.size.height)];
    view.userInteractionEnabled=YES;
    view.tag=10;
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-70, view.frame.size.height/2-15, 60, 30)];
    [button setTitle:@"举报" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    button.layer.cornerRadius=5;
    [button setTitleColor:COLOR(74, 166, 216, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [cell.contentView addSubview:view];
    cell.selectionStyle=0;
    return cell;
}





@end
