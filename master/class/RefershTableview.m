//
//  RefershTableview.m
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RefershTableview.h"


@interface RefershTableview()
@property(nonatomic,copy)void(^pulldownBlock)(UITableView*tableview);
@property(nonatomic,copy)void(^pullupBlock)(UITableView*tableview);
@end

@implementation RefershTableview


-(void)dealloc{

    _pulldownBlock=nil;
    _pullupBlock=nil;
    
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    if (self=[super initWithFrame:frame style:style]) {
        
        
        
    }
    
    return self;

}


/*
 设置下拉刷新
 **/
-(void)setIsSupportPulldown:(BOOL)isSupportPulldown{
    if (!isSupportPulldown) {
        
//    }else{
//    
//        __weak typeof(self)WeSelf=self;
//        [self addPullToRefreshActionHandler:^{
//            if (WeSelf.pulldownBlock) {
//                WeSelf.pulldownBlock(WeSelf);
//            }
//            
//        } ProgressImagesGifName:@"Preloader_10@2x.gif" LoadingImagesGifName:@"run@2x.gif" ProgressScrollThreshold:10 LoadingImageFrameRate:10];
    }
//
}


-(void)setIsSupportPullup:(BOOL)isSupportPullup{

    if (!isSupportPullup) {
        
    }else{
    
      __weak typeof(self)WeSelf=self;
        [self addInfiniteScrollingWithActionHandler:^{
            if (WeSelf.pullupBlock) {
                WeSelf.pullupBlock(WeSelf);
            }
            
        }];
    }

}


-(void)tablePullDownWithBlock:(void (^)(UITableView *))block{

    _pulldownBlock=block;

}

-(void)tablePullUpWithBlock:(void (^)(UITableView *))block{
 
    _pullupBlock=block;
    
}


@end
