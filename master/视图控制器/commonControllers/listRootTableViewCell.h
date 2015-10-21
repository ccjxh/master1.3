//
//  listRootTableViewCell.h
//  master
//
//  Created by jin on 15/5/20.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listRootTableViewCell : UITableViewCell
{
    
    UIImageView*headImageView;
    UILabel*nameLabel;
    UIImageView*personalImageview;
    UILabel*workType;
    UIButton*phoneButton;
    UILabel*skillLabel;
    UIImageView*moneyImage;
    UILabel*exterLabel;//期望薪资
    UILabel*experienceLabel;//工作经验
}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *exLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skillImage;

@property (weak, nonatomic) IBOutlet UIImageView *flag;//是否显示为处理标志
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIImageView *statImage;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Backimageview;
@property(nonatomic)NSInteger type;//0为首页列表  1为推荐的人
@property(nonatomic)peoplr*model;
@property(nonatomic)NSInteger dealStatus;//是否处理
@property(nonatomic)BOOL isShow;

-(void)reloadData;
@end
