//
//  mySelfMessageTableViewCell.m
//  master
//
//  Created by jin on 15/9/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "mySelfMessageTableViewCell.h"

@implementation mySelfMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{

//    
//    NSString*temp=((EMTextMessageBody*)self.model.messageBodies.firstObject).text;
//    NSDate*date=[[NSDate alloc]initWithTimeIntervalSince1970:(self.model.timestamp-1)/1000];
//    NSDateFormatter*forrmater=[[NSDateFormatter alloc]init];
//    [forrmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    self.content.text=temp;
//    self.date.text=[forrmater stringFromDate:date];
//     self.backImahe.image= [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
//    if (temp.length<=13) {
//        
//        self.imageWidth.constant=temp.length*15+25;
//        self.contentWidth.constant=self.imageWidth.constant-10;
//        
//    }else{
//        
//        self.imageWidth.constant=13*15+25;
//        self.contentWidth.constant=self.imageWidth.constant-10;
//        CGFloat height= [self heightForTextView:self.content WithText:temp];
//        self.contentHeight.constant=height+15;
//        self.backHeight.constant=height;
//        
//    }
//    
}


- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(13*15+25, CGFLOAT_MAX);
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

@end
