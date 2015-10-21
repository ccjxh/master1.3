//
//  messageView.m
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "messageView.h"
#import "otherMessageTableViewCell.h"
#import "mySelfMessageTableViewCell.h"
#import "imageCellTableViewCell.h"

@implementation messageView
{

    NSMutableDictionary*_typeDict;//装着数据源类型的字典

}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
//        [self createTableview];
        
    }
    
    return self;

}



-(void)initData{

    if (!_typeDict) {
        _typeDict=[[NSMutableDictionary alloc]init];
    }
   
}


//-(void)createTableview{
//
//    /* 对话列表 */
//    self.chatListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
//    self.chatListTable.dataSource = self;
//    self.chatListTable.delegate = self;
//    self.chatListTable.backgroundColor = [GJGCChatInputPanelStyle mainBackgroundColor];
//    self.chatListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self addSubview:self.chatListTable];
////    [self setupHeaderWithTableview:self.chatListTable];
//    
//    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
//    tap.numberOfTapsRequired=1;
//    tap.numberOfTouchesRequired=1;
//    [self addGestureRecognizer:tap];
//    
//    /* 输入面板 */
//    self.inputPanel = [[GJGCChatInputPanel alloc]initWithPanelDelegate:self];
//    self.inputPanel.frame = (CGRect){0,GJCFSystemScreenHeight-self.inputPanel.inputBarHeight,GJCFSystemScreenWidth,self.inputPanel.inputBarHeight+216};
//    GJCFWeakSelf weakSelf = self;
//    [self.inputPanel configInputPanelKeyboardFrameChange:^(GJGCChatInputPanel *panel,CGRect keyboardBeginFrame, CGRect keyboardEndFrame, NSTimeInterval duration,BOOL isPanelReserve) {
//        
//        /* 不要影响其他不带输入面板的系统视图对话 */
//        if (panel.hidden) {
//            return ;
//        }
//        
//        [UIView animateWithDuration:duration animations:^{
//            
//            weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight  - keyboardEndFrame.size.height;
//            
//            if (keyboardEndFrame.origin.y == GJCFSystemScreenHeight) {
//                
//                if (isPanelReserve) {
//                    
//                    weakSelf.inputPanel.gjcf_top = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight ;
//                    
//                    weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight ;
//                    
//                }else{
//                    
//                    weakSelf.inputPanel.gjcf_top = GJCFSystemScreenHeight - 216 - weakSelf.inputPanel.inputBarHeight ;
//                    
//                    weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight  - 216;
//                }
//                
//            }else{
//                
//                weakSelf.inputPanel.gjcf_top = weakSelf.chatListTable.gjcf_bottom;
//                
//            }
//            
//        }];
//        
//        [weakSelf.chatListTable scrollRectToVisible:CGRectMake(0, weakSelf.chatListTable.contentSize.height - weakSelf.chatListTable.bounds.size.height, weakSelf.chatListTable.gjcf_width, weakSelf.chatListTable.gjcf_height) animated:NO];
//        
//    }];
//    
//    [self.inputPanel configInputPanelRecordStateChange:^(GJGCChatInputPanel *panel, BOOL isRecording) {
//        
//        if (isRecording) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                                
//                weakSelf.chatListTable.userInteractionEnabled = NO;
//                
//            });
//            
//        }else{
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                weakSelf.chatListTable.userInteractionEnabled = YES;
//                
//            });
//        }
//        
//    }];
//    
//    [self.inputPanel configInputPanelInputTextViewHeightChangedBlock:^(GJGCChatInputPanel *panel, CGFloat changeDelta) {
//        
//        panel.gjcf_top = panel.gjcf_top - changeDelta;
//        
//        panel.gjcf_height = panel.gjcf_height + changeDelta;
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            
//            weakSelf.chatListTable.gjcf_height = weakSelf.chatListTable.gjcf_height - changeDelta;
//            
//            [weakSelf.chatListTable scrollRectToVisible:CGRectMake(0, weakSelf.chatListTable.contentSize.height - weakSelf.chatListTable.bounds.size.height, weakSelf.chatListTable.gjcf_width, weakSelf.chatListTable.gjcf_height) animated:NO];
//        }];
//        
//    }];
//
////    [self addSubview:self.inputPanel];
//    /* 观察输入面板变化 */
////    [self.inputPanel addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//    
//    [self.chatListTable addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
//}
//
//
////-(void)chatInputPanel:(GJGCChatInputPanel *)panel sendTextMessage:(NSString *)text{
////
////    [self.delegate sendMessage:text];
////}
////
////-(void)hideKeyBoard{
////    
////    __weak typeof(self)weakSelf=self;
////    [UIView animateWithDuration:0.2 animations:^{
////        
////        weakSelf.inputPanel.gjcf_top = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight ;
////        
////        weakSelf.chatListTable.gjcf_height = GJCFSystemScreenHeight - weakSelf.inputPanel.inputBarHeight ;
////        [self.inputPanel reserveState];
////        
////    }];
////
////}
//
//
//#pragma mark - 属性变化观察
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"frame"] && object == self.inputPanel) {
//        
//        CGRect newFrame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
//        CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;
//        //50.f 高度是输入条在底部的时候显示的高度，在录音状态下就是50
//        if (newFrame.origin.y < GJCFSystemScreenHeight - 50.f - originY) {
//            
//            self.inputPanel.isFullState = YES;
//            
//        }else{
//            
//            self.inputPanel.isFullState = NO;
//        }
//    }
//    
//    if ([keyPath isEqualToString:@"panGestureRecognizer.state"] && object == self.chatListTable) {
//        
//        UIGestureRecognizerState state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
//        
//        switch (state) {
//            case UIGestureRecognizerStateBegan:
//            case UIGestureRecognizerStateChanged:
//            {
//
//            
//            }
//                break;
//            case UIGestureRecognizerStateCancelled:
//            case UIGestureRecognizerStateEnded:
//            {
//
//            
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}
//
//#pragma mark - 输入动作变化
//- (void)inputBar:(GJGCChatInputBar *)inputBar changeToAction:(GJGCChatInputBarActionType)actionType
//{
//    CGFloat originY = GJCFSystemNavigationBarHeight + GJCFSystemOriginYDelta;
//    
//    switch (actionType) {
//        case GJGCChatInputBarActionTypeRecordAudio:
//        {
//            if (self.inputPanel.isFullState) {
//                
//                [UIView animateWithDuration:0.26 animations:^{
//                    
//                    self.inputPanel.gjcf_top = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;
//                    
//                    self.chatListTable.gjcf_height = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - originY;
//                    
//                }];
//                
//                [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
//            }
//        }
//            break;
//        case GJGCChatInputBarActionTypeChooseEmoji:
//        case GJGCChatInputBarActionTypeExpandPanel:
//        {
//            if (!self.inputPanel.isFullState) {
//                
//                [UIView animateWithDuration:0.26 animations:^{
//                    
//                    self.inputPanel.gjcf_top = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - 216 - originY;
//                    
//                    self.chatListTable.gjcf_height = GJCFSystemScreenHeight - self.inputPanel.inputBarHeight - 216 - originY;
//                    
//                }];
//                
//                [self.chatListTable scrollRectToVisible:CGRectMake(0, self.chatListTable.contentSize.height - self.chatListTable.bounds.size.height, self.chatListTable.gjcf_width, self.chatListTable.gjcf_height) animated:NO];
//                
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return [[self.convenit loadAllMessages] count];
//
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return 1;
//}
//
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    EMMessage*message=[self.convenit loadAllMessages][indexPath.section];
//    EMTextMessageBody*body=message.messageBodies[0];
//    if (body.messageBodyType==1) {
//    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
//    if ([model.mobile isEqualToString:message.from]==YES) {
//        static NSString*shortCell=@"shortCell";
//        static NSString*longCell=@"longCell";
//        NSString*temp;
//        
//        if ([((EMTextMessageBody*)message.messageBodies.firstObject).text length]<=13) {
//            
//            temp=shortCell;
//            
//            
//        }else{
//        
//            temp=longCell;
//            
//        }
//        
//        mySelfMessageTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:temp];
//        if (!cell) {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"mySelfMessageTableViewCell" owner:nil  options:nil]lastObject];
//            [cell setRestorationIdentifier:temp];
//        }
//        cell.selectionStyle=0;
//        cell.model=message;
//        [cell reloadData];
//        return cell;
//        
//    }
//         
//    otherMessageTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!Cell) {
//        
//       Cell=[[[NSBundle mainBundle]loadNibNamed:@"otherMessageTableViewCell" owner:nil options:nil]lastObject];
//    }
//        
//    Cell.selectionStyle=0;
//    Cell.model=message;
//    [Cell reloadData];
//        return Cell;
//    }else{
//    
//        imageCellTableViewCell*cell=[[[NSBundle mainBundle]loadNibNamed:@"imageCellTableViewCell" owner:nil options:nil]lastObject];
//        
////    cell.contentImage sd_setImageWithURL:[] placeholderImage:<#(UIImage *)#>
//        return nil;
//    }
//    
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    EMMessage*message=[self.convenit loadAllMessages][indexPath.section];
//    EMTextMessageBody*body=message.messageBodies[0];
//    if (body.messageBodyType==1) {
//        NSString*temp=((EMTextMessageBody*)message.messageBodies.firstObject).text;
//        if (temp.length<=13) {
//            return 75;
//        }else{
//            
//            return 75+[self heightForTextView:nil WithText:temp]+16;
//        }
//    }
//    
//    return 50;
//}
//
//
//- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
//    
//    
//    float fPadding = 16.0; // 8.0px x 2
//    CGSize constraint = CGSizeMake(13*15+25, CGFLOAT_MAX);
//    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    float fHeight = size.height + 16.0;
//    return fHeight;
//    
//    
//}
//
//
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    label.backgroundColor=self.chatListTable.backgroundColor;
//    return label;
//
//}
//

@end
