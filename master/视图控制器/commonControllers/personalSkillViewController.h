//
//  personalSkillViewController.h
//  master
//
//  Created by jin on 15/8/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "skillSelectViewController.h"

@interface personalSkillViewController : skillSelectViewController
@property(nonatomic)NSMutableArray*allSkills;//此人一共有多少个技能
@property(nonatomic,copy)void (^selectSkills)(NSMutableArray*selecteds);
@end
