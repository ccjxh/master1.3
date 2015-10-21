//
//  datePcikView.m
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "datePcikView.h"

@implementation datePcikView


-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self=[super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;

}


/*
 确定按钮被点击
 **/
- (IBAction)certain:(id)sender {
  
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (self.certainBlock) {
        self.certainBlock([formatter stringFromDate:self.datepick.date]);
    }
    
}



/*
 取消按钮被点击
 **/
- (IBAction)cancel:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}




@end
