//
//  keyboardBar.h
//  master
//
//  Created by jin on 15/9/10.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 8
#define kVerticalPadding 5
#define kTouchToRecord NSLocalizedString(@"message.toolBar.record.touch", @"hold down to talk")
#define kTouchToFinish NSLocalizedString(@"message.toolBar.record.send", @"loosen to send")
#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
@protocol keyboardBarDelegate;

@interface keyboardBar : UIView


@property (strong, nonatomic) UIButton *recordButton;

@property(nonatomic)id<keyboardBarDelegate>delegate;//键盘的代理

/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 *  更多的附加页面
 */
@property (strong, nonatomic) UIView *moreView;

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;

/**
 *  录音的附加页面
 */
@property (strong, nonatomic) UIView *recordView;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return DXMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

/**
 *  取消触摸录音键
 */
- (void)cancelTouchRecord;

@end


@protocol keyboardBarDelegate<NSObject>

@optional

/**
 *  在普通状态和语音状态之间进行切换时，会触发这个回调函数
 *
 *  @param changedToRecord 是否改为发送语音状态
 */
- (void)didStyleChangeToRecord:(BOOL)changedToRecord;

///**
// *  点击“表情”按钮触发
// *
// *  @param isSelected 是否选中。YES,显示表情页面；NO，收起表情页面
// */
//- (void)didSelectedFaceButton:(BOOL)isSelected;
//
///**
// *  点击“更多”按钮触发
// *
// *  @param isSelected 是否选中。YES,显示更多页面；NO，收起更多页面
// */
//- (void)didSelectedMoreButton:(BOOL)isSelected;

/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction:(UIView *)recordView;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction:(UIView *)recordView;

@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;


@end


