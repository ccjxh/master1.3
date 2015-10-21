//
//  findMaster.m
//  master
//
//  Created by jin on 15/8/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findMaster.h"
#import "UIImage+GIF.h"
#import "hotRankCollectionViewCell.h"
#import "PeoDetailViewController.h"
#define BUTTON_TAG 10
#define TIMELABEL_TAG 11
#define SCORELABELTAG 12
@implementation findMaster
{

    UIView*_noticeView;
    UIView*_firObjcView;
    UILabel*_timeLabel;//连续登陆label
    UILabel*_scoreLabel;//总积分标签
    UIScrollView*_backView;
    BOOL _isShowNotice;//是否显示通知
    UILabel*_signedButton;//签到button
    UIButton*_refershButton;
    UIButton*_opinionButton;

}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
    
        [self createScrollLabel];
        [self customUI];
        [self customCollection];
    }
    
    return self;

}



//工长
- (IBAction)workHead:(id)sender {
    
    if (self.workHeadBlock) {
        self.workHeadBlock();
    }
}


//师傅
- (IBAction)work:(id)sender {
    
    if (self.workBlock) {
        self.workBlock();
    }
    
}


-(void)customUI{

    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.backgroundColor=COLOR(232, 233, 232, 1);
    _firObjcView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_noticeView.frame), SCREEN_WIDTH, 48)];
    _opinionButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-113, _firObjcView.frame.size.height/2-10, 100, 20)];
    _opinionButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_opinionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_opinionButton setBackgroundColor:[UIColor whiteColor]];
    _opinionButton.layer.cornerRadius=5;
    [_opinionButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    if ([[delegate.signInfo objectForKey:@"signState"] integerValue]==1) {
            [_opinionButton setTitle:[NSString stringWithFormat:@"明日签到+%ld",[[delegate.signInfo objectForKey:@"nextDayIntegral"]integerValue]] forState:UIControlStateNormal];
            }
    else {
            [_opinionButton setTitle:[NSString stringWithFormat:@"今日签到+%ld",[[delegate.signInfo objectForKey:@"todayIntegral"] integerValue]] forState:UIControlStateNormal];
                _signedButton.userInteractionEnabled=YES;
            }
    [_firObjcView addSubview:_opinionButton];
        [UIView commitAnimations];
    _firObjcView.backgroundColor=COLOR(100, 172, 196, 1);
    _firObjcView.userInteractionEnabled=YES;
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 7.5, 150, 12)];
    _timeLabel.font=[UIFont systemFontOfSize:12];
    _timeLabel.textColor=[UIColor whiteColor];
    [_firObjcView addSubview:_timeLabel];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(_timeLabel.frame)+6, 12, 12)];
    imageview.image=[UIImage imageNamed:@"积分.png"];
    [_firObjcView addSubview:imageview];
    _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+5, CGRectGetMaxY(_timeLabel.frame)+6, 40, 12)];
    _scoreLabel.textColor=[UIColor whiteColor];
    _scoreLabel.font=[UIFont systemFontOfSize:12];
    [_firObjcView addSubview:_scoreLabel];
    [self addSubview:_firObjcView];

}



-(void)sign:(UIButton*)button{

    if (self.signin) {
        self.signin();
    }
}


-(void)createScrollLabel{

    _noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    _noticeView.backgroundColor=COLOR(16, 118, 162, 1);
    [self addSubview:_noticeView];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(13, 4, 12, 12)];
    imageview.image=[UIImage imageNamed:@"公告.png"];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+5,3, 30, 14)];
    label.text=@"公告:";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:12];
    [_noticeView addSubview:label];
    [_noticeView addSubview:imageview];
    _tv=[[CBAutoScrollLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 3, SCREEN_WIDTH-10-CGRectGetMaxX(label.frame), 14)];
    _tv.textColor = [UIColor whiteColor];
    _tv.labelSpacing = 70; // distance between start and end labels
    _tv.pauseInterval = 0; // seconds of pause before scrolling starts again
    _tv.scrollSpeed = 30;
    [_tv setFont:[UIFont systemFontOfSize:12]];
    [_noticeView addSubview:_tv];
 
}

-(void)reloadData{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _timeLabel.text=[NSString stringWithFormat:@"您已经连续签到了%lu天",[[delegate.signInfo objectForKey:@"renewDay"] integerValue]];
    
    if ([[delegate.signInfo objectForKey:@"signState"] integerValue]==1) {
        [_opinionButton setTitle:[NSString stringWithFormat:@"明日签到+%ld",[[delegate.signInfo objectForKey:@"nextDayIntegral"]integerValue]] forState:UIControlStateNormal];
        _opinionButton.userInteractionEnabled=NO;
    }
    else {
        
        [_opinionButton setTitle:[NSString stringWithFormat:@"今日签到+%ld",[[delegate.signInfo objectForKey:@"todayIntegral"] integerValue]] forState:UIControlStateNormal];
        _signedButton.userInteractionEnabled=YES;
    }
    
    _scoreLabel.text=[NSString stringWithFormat:@"%lu",delegate.integral ];
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    if (_isShowNotice==NO) {
        _noticeView.frame=CGRectMake(_noticeView.frame.origin.x, _noticeView.frame.origin.y, _noticeView.frame.size.width, 0);
    }else{
        _noticeView.frame=CGRectMake(_noticeView.frame.origin.x, _noticeView.frame.origin.y, _noticeView.frame.size.width, 20);
    }
    _firObjcView.frame=CGRectMake(0, CGRectGetMaxY(_noticeView.frame), SCREEN_WIDTH, 48);
    _backView.frame=CGRectMake(0, CGRectGetMaxY(_firObjcView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-24-140);
    [UIView commitAnimations];
   
}


-(void)hideNotice{

    _isShowNotice=NO;
    [self reloadData];

}

-(void)showNotice{

    _isShowNotice=YES;
    [self reloadData];

}

-(void)customCollection{

    _backView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_firObjcView.frame), SCREEN_WIDTH, 600-24-60-10)];
    _backView.bounces=YES;
    _backView.userInteractionEnabled=YES;
    UIView*tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155)];
    tempView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:tempView];
    NSArray*title=@[@"工长",@"师傅"];
    NSArray*contentArray=@[@"待办、管理现场进度、进度把控",@"工程施工、专业技能"];
    for (NSInteger i=0; i<title.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 5+i*70, SCREEN_WIDTH-40, 70)];
        button.backgroundColor=[UIColor whiteColor];
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
        if (i==1) {
            imageview.frame=CGRectMake(15, 15, 45, 45);
        }
        imageview.image=[UIImage imageNamed:title[i]];
        [button addSubview:imageview];
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+15, 17, 100, 20)];
        if (i==0) {
            nameLabel.frame=CGRectMake(CGRectGetMaxX(imageview.frame)+15, 12, 100, 20);
        }
        nameLabel.text=title[i];
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.textColor=[UIColor blackColor];
        UILabel*functionLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+15, CGRectGetMaxY(nameLabel.frame), 200, 20)];
        functionLabel.font=[UIFont systemFontOfSize:14];
        functionLabel.textColor=[UIColor lightGrayColor];
        functionLabel.text=contentArray[i];
        [button addSubview:functionLabel];
        [button addSubview:nameLabel];
        if (i==0) {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, 1)];
            view.backgroundColor=COLOR(217, 217, 217, 1);
            [button addSubview:view];
        }
        tempView.userInteractionEnabled=YES;
        button.tag=40+i;
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:button];
    }
    
    [self addSubview:_backView];
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    CGFloat space=(SCREEN_WIDTH-180-45)/4;
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setItemSize:CGSizeMake(SCREEN_WIDTH/2, 75)];
    _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, _backView.frame.size.height-100-100-15) collectionViewLayout:layout];
    _collection.showsVerticalScrollIndicator=NO;
    _collection.scrollEnabled=NO;
    NSInteger height=CGRectGetMaxY(_collection.frame);
    [_backView setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
    _collection.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:_collection];
    _collection.delegate=self;
    _collection.dataSource=self;
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13, 18, 90, 16)];
    label.text=@"热度排行榜";
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:16];
    [_collection addSubview:label];
    [ _collection setCollectionViewLayout:layout animated:YES];
    UINib *nib=[UINib nibWithNibName:@"hotRankCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:@"cell"];
    [_collection registerNib:nib forCellWithReuseIdentifier:@"noSkill"];
    _refershButton=[[UIButton alloc]initWithFrame:CGRectMake(_collection.bounds.size.width/2-80, _collection.bounds.size.height/2-30 , 160, 60)];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(60, 0, 40, 40)];
    imageview.image=[UIImage imageNamed:@"表情.jpg"];
    _refershButton.backgroundColor=[UIColor whiteColor];
    [_refershButton addSubview:imageview];
    UILabel*messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 40, 160, 40)];
    messageLabel.text=@"暂无数据，点击刷新";
    messageLabel.textAlignment=NSTextAlignmentCenter;
    messageLabel.textColor=[UIColor lightGrayColor];
    messageLabel.font=[UIFont systemFontOfSize:15];
    [_refershButton addSubview:messageLabel];
//    _refershButton.backgroundColor=[UIColor blackColor];
    [_refershButton addTarget:self action:@selector(refershData) forControlEvents:UIControlEventTouchUpInside];
    _refershButton.hidden=YES;
    [_collection addSubview:_refershButton];
    [_collection reloadData];
    [_collection bringSubviewToFront:_refershButton];

}



-(void)refershData{

    if (self.refershHotRank) {
        self.refershHotRank();
    }

}


-(void)showNoDataPiceure{

    _refershButton.hidden=NO;

}


-(void)hideNoDataPicture{

    _refershButton.hidden=YES;

}

-(void)push:(UIButton*)button{

    switch (button.tag) {
        case 40:
        {
            if (self.workHeadBlock) {
                self.workHeadBlock();
            }

        }
            break;
          case 41:
        {
            if (self.workBlock) {
                self.workBlock();
            }
        }
            break;
        default:
            break;
    }
   

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _hotArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MasterDetailModel*model=_hotArray[indexPath.row];
    NSArray*Array=@[@"first",@"second",@"third",@"fifth",@"fiveth",@"sixth"];
    if ([[model.certification objectForKey:@"personal"] integerValue]==1) {
        static  NSString*cellName=@"cell";
        hotRankCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
        cell.model=model;
        [cell reloadData];
        cell.skillpicture.hidden=NO;
        if (indexPath.row>1) {
            cell.vHine.hidden=YES;
        }else{
            cell.vHine.hidden=NO;
        }
        if (indexPath.row>2) {
            cell.rankWidth.constant=8;
            cell.rankHeight.constant=14;
            cell.rankTop.constant=30.5;
            cell.headImage.frame=CGRectMake(cell.headImage.frame.origin.x-1, cell.headImage.frame.origin.y, 45, 45);
        }else{
            cell.rankWidth.constant=10;
            cell.rankHeight.constant=30;
            cell.rankTop.constant=23;
        }
        cell.rankImage.image=[UIImage imageNamed:Array[indexPath.row]];
        return cell;
    }
    
        static NSString*result=@"noSkill";
        hotRankCollectionViewCell*noSkillCell=[collectionView dequeueReusableCellWithReuseIdentifier:result forIndexPath:indexPath];
        noSkillCell.model=model;
        [noSkillCell reloadData];
        noSkillCell.skillpicture.hidden=YES;
    if (indexPath.row>1) {
        noSkillCell.vHine.hidden=YES;
    }else{
        
        noSkillCell.vHine.hidden=NO;
        
    }
        if (indexPath.row>2) {
            noSkillCell.rankWidth.constant=8;
            noSkillCell.rankHeight.constant=14;
            noSkillCell.rankTop.constant=30.5;
            noSkillCell.headImage.frame=CGRectMake(noSkillCell.headImage.frame.origin.x-1, noSkillCell.headImage.frame.origin.y,45,45);
        }else{
            noSkillCell.rankWidth.constant=10;
            noSkillCell.rankHeight.constant=30;
            noSkillCell.rankTop.constant=23;
        }
        noSkillCell.rankImage.image=[UIImage imageNamed:Array[indexPath.row]];
        return noSkillCell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)sectio9
{
    
    return UIEdgeInsetsMake(52, 0, 0, 0);
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.push) {
        self.push(indexPath);
    }
    
}

@end
