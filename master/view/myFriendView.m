//
//  myFriendView.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myFriendView.h"

@implementation myFriendView

//-(instancetype)initWithFrame:(CGRect)frame{
//
//    if (self=[super initWithFrame:frame]) {
//        [self createUI];
//        
//    }
//    
//    return self;
//
//}
//
//
//-(void)createUI{
//
//    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    self.tableview.dataSource=self;
//    self.tableview.delegate=self;
//    [self addSubview:self.tableview];
//    [self setupHeaderWithTableview:self.tableview];
//    [self setupFooter:self.tableview];
//   
//}
//
//
//
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return _dataArray.count+1;
//
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 60;
//
//}
//
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//   
//    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!Cell) {
//        Cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
//    }
//    
//    if (indexPath.section==0) {
//       Cell.textLabel.text=@"系统助手";
//        return Cell;
//    }
////    EMBuddy*body=_dataArray[indexPath.section-1];
////    Cell.textLabel.text=body.username;
//    return Cell;
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (self.friendDidSelect) {
//        self.friendDidSelect(indexPath);
//    }
//
//}
//
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section==0) {
//        return NO;
//    }
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        if (self.delegateFriend) {
//            self.delegateFriend(indexPath);
//        }
//        
////        [dataArray removeObjectAtIndex:indexPath.row];
////        // Delete the row from the data source.
////        [testTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
////        
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}

@end
