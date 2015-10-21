//
//  NSObject+tool.h
//  master
//
//  Created by jin on 15/8/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (tool)<UITextFieldDelegate>

//技能显示cell
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView  SkillArray:(NSMutableArray*)skillArray;




//计算技能高度
-(CGFloat)accountSkillWithAllSkill:(NSMutableArray*)skillArray;




//计算图片高度
-(CGFloat)accountPictureFromArray:(NSMutableArray*)pictureArray;





//图片展示   
-(void)displayPhotosWithIndex:(NSInteger)index Tilte:(NSString*)title describe:(NSString*)describe ShowViewcontroller:(UIViewController*)vc UrlSarray:(NSMutableArray*)UrlArray ImageView:(UIImageView*)imageview;



//注册环信
-(void)regiloginWithUsername:(NSString*)name Password:(NSString*)password;




//环信登陆
-(void)HXLoginWithUsername:(NSString*)username Password:(NSString*)password;


//获得textview的高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;


-(void)updateOpinionWithDict:(NSDictionary*)dict UrlString:(NSString*)urlString;

@end
