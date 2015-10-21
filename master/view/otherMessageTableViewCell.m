//
//  otherMessageTableViewCell.m
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "otherMessageTableViewCell.h"

@implementation otherMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadData{

//    NSString*temp=((EMTextMessageBody*)self.model.messageBodies.firstObject).text;
//    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
//    NSDate*date=[[NSDate alloc]initWithTimeIntervalSince1970:(self.model.timestamp-1)/1000];
//    NSDateFormatter*forrmater=[[NSDateFormatter alloc]init];
//    [forrmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    self.date.text=[forrmater stringFromDate:date];
//    self.tx.text=temp;
//    if ([self.model.from isEqualToString:model.mobile]==YES) {
//        self.backImage.image= [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
//        
//    }else{
//    
//    self.backImage.image= [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
//    }
//    
//    if (temp.length<=13) {
//        
//        self.imageWidth.constant=temp.length*15+25;
//        self.contentWidth.constant=self.imageWidth.constant-10;
//    }else{
//        self.imageWidth.constant=13*15+25;
//        self.contentWidth.constant=self.imageWidth.constant-10;
//        if ([[UIDevice currentDevice].systemName floatValue]>7) {
//            
//            
//        }
//        self.contentHeight.constant=[self heightForTextView:self.tx WithText:temp];
//        self.imageHeight.constant=self.contentHeight.constant;
////        self.imageHeight.constant=[self accountStringHeightFromString:temp Width:13*15+15]+15;
////        self.contentHeight.constant=[self accountStringHeightFromString:temp Width:13*15+15];
//        
//    }
    
    
}



- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(13*15+25, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}



@end
