//
//  ReportTableViewCell.m
//  master
//
//  Created by xuting on 15/7/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ReportTableViewCell.h"
#import "Toast+UIView.h"

@implementation ReportTableViewCell
{
    UITextField *_tx;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)reportBtn:(id)sender
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"欢迎填写举报内容!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    infoLabelRect.size.height-=40;
    _tx=[[UITextField alloc]initWithFrame:infoLabelRect];
    _tx.font=[UIFont systemFontOfSize:16];
    _tx.layer.borderColor=[[UIColor whiteColor]CGColor];
    _tx.layer.cornerRadius=7;
    _tx.layer.borderWidth=1;
    _tx.placeholder=@"在这里输入内容";
    [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor whiteColor];
    [contentView addSubview:_tx];
    CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
    txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
    txBounce.size.height=30;
    UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
    button.backgroundColor=contentView.backgroundColor;
    button.layer.borderColor=[[UIColor whiteColor]CGColor];
    button.layer.borderWidth=1;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(changeDEsscribe) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

-(void)changeDEsscribe
{
    //改变说明
    
    if (_tx.text.length==0) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"警告提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _introduce=_tx.text;
    NSDictionary*dict=@{@"problem":_tx.text,@"checkUser.id":[NSNumber numberWithInteger:self.id]};
    
    NSString*urlString=[self interfaceFromString:interface_reportInfo];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{

                [self makeToast:@"举报成功!" duration:2.0f position:@"center"];
                
            }];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}

/**计算服务介绍高度*/
-(CGFloat)accountIntrolduce{
    
    if (_tx.text.length==0) {
        return 50;
    }
    return [self accountStringHeightFromString:_tx.text Width:SCREEN_WIDTH-150]+20;
}
@end
