//
//  keyboardMoreView.h
//  master
//
//  Created by jin on 15/9/10.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol keyboardMoreViewDelegate;

@interface keyboardMoreView : UIView

@property(nonatomic)id<keyboardMoreViewDelegate>delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;


@end

@protocol keyboardMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(keyboardMoreView *)moreView;
- (void)moreViewPhotoAction:(keyboardMoreView *)moreView;
- (void)moreViewLocationAction:(keyboardMoreView *)moreView;
- (void)moreViewAudioCallAction:(keyboardMoreView *)moreView;
- (void)moreViewVideoCallAction:(keyboardMoreView *)moreView;

@end

