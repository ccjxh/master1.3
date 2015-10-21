//
//  descriteViewController.h
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface descriteViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextView *tx;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property(nonatomic)peojectCaseModel*model;
@end
