//
//  myIntegralListView.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myIntegralListView.h"
#import "myIntegralListCellTableViewCell.h"
#import "myIntrgalListModel.h"
#import "IntegralDetailTableViewHeaderCell.h"

@implementation myIntegralListView
{
    
    NSMutableDictionary*_dict;//保存section是否展开的字典

}

-(id)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createUI];
        
    }

    return self;
}


-(void)createUI{

    _tableview=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=COLOR(237, 238, 240, 1);
    _tableview.separatorStyle=0;
    [self addSubview:_tableview];
//    [_tableview registerClass:[IntegralDetailTableViewHeaderCell class] forCellReuseIdentifier:@"SuperCell"];
//    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SubCell"];

//    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_tableview).with.offset=64;
//        make.left.equalTo(_tableview).with.offset=0;
//        make.right.equalTo(_tableview).with.offset=0;
//        make.bottom.equalTo(_tableview).with.offset=0;
//    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        
        return 1;
    }else{
    
        return _dataArray.count;
    
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 27;

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSArray*Array=@[@"当前总积分",@"积分明细"];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(13, 5, 120, 16)];
    label.textColor=[UIColor blackColor];
    label.text=Array[section];
    label.font=[UIFont boldSystemFontOfSize:16];
    [view addSubview:label];
    return view;
    
}


-(void)show:(UIButton*)button{

    if (self.changeDictValue) {
        self.changeDictValue(button.tag);
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    myIntrgalListModel*model=_dataArray[indexPath.section];
//    static NSString *cellIdentifier = @"SubCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = COLOR(237, 238, 240, 1);
////    IntegralLogEntity *entity = _dataSource[indexPath.section];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",model.type,model.readme];
//    cell.selectionStyle=0;
//    cell.textLabel.font = [UIFont systemFontOfSize:13];
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.textLabel.textColor = COLOR(109, 109, 109, 1);
//    return cell;
    if (indexPath.section==0) {
        
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"Cell"];
        UILabel*lable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-113, cell.contentView.frame.size.height/2-15, 100, 28)];
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        lable.text=[NSString stringWithFormat:@"%lu",[[delegate.signInfo objectForKey:@"totalIntegral"] integerValue]];
        lable.textColor=COLOR(249, 190, 84, 1);
        lable.textAlignment=NSTextAlignmentRight;
        lable.font=[UIFont systemFontOfSize:25];
        [cell.contentView addSubview:lable];
        return cell;
    }
    
    
    return [self getTableviewcellWithTableview:tableView IndexPath:indexPath];

}


-(UITableViewCell*)getTableviewcellWithTableview:(UITableView*)tableview IndexPath:(NSIndexPath*)indexpath{

    myIntrgalListModel*model=_dataArray[indexpath.row];
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    UIView*view=(id)[cell.contentView viewWithTag:20];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.contentView.bounds];
    view.tag=20;
    UILabel*typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 4.5, 120, 15)];
    typeLabel.textColor=COLOR(104, 104, 104, 1);
    typeLabel.font=[UIFont systemFontOfSize:15];
    typeLabel.text=model.type;
    [view addSubview:typeLabel];
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 24, 180, 15)];
    timeLabel.textColor=COLOR(104, 104, 104, 1);
    timeLabel.font=[UIFont systemFontOfSize:13];
    timeLabel.text=model.createTime;
    [view addSubview:timeLabel];
    UILabel*countLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-133, (cell.contentView.frame.size.height-16)/2, 120, 16)];
    countLabel.font=[UIFont systemFontOfSize:20];
    countLabel.textAlignment=NSTextAlignmentRight;
    if (model.value>0) {
        countLabel.text=[NSString stringWithFormat:@"+%lu",model.value];
    }else{
        
        countLabel.text=[NSString stringWithFormat:@"-%lu",model.value];
    }
    countLabel.textColor=model.value>0?COLOR(249, 190, 87, 1):COLOR(109, 217, 251, 1);
    [view addSubview:countLabel];
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(10, cell.contentView.frame.size.height-1, SCREEN_WIDTH-15, 1)];
    lineView.backgroundColor=COLOR(205, 205, 205, 1);
    [view addSubview:lineView];
    [cell.contentView addSubview:view];
    cell.selectionStyle=0;
    return cell;
}

-(void)reloadData{

    [_tableview reloadData];
    
}


#pragma mark - SLExpandableTableViewDatasource

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    myIntrgalListModel*model=_dataArray[section];
    static NSString *CellIdentifier = @"SuperCell";
    IntegralDetailTableViewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[IntegralDetailTableViewHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    cell.date=model.createTime;
    NSString*count;
    if (model.value>0) {
        count=[NSString stringWithFormat:@"+%lu积分",+model.value];
    }else{
    
        count=[NSString stringWithFormat:@"+%lu积分",-model.value];
    }
    cell.count=count;
    cell.expandable = YES;
    cell.selectionStyle=0;
    return cell;

    
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.expandableSections addIndex:section];
        [tableView expandSection:section animated:YES];
    });
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
//    [self.expandableSections removeIndex:section];
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    myIntrgalListModel*model=_dataArray[indexPath.section];
//    if (indexPath.row == 0) {   //父cell高
//        return 44;
//    }else{                      //子cell高
////        IntegralLogEntity *entity = _dataSource[indexPath.section];
////        NSString *word = entity.describe;
//////        DDLogVerbose(@"word:%@", word);
////        CGSize size = [model.readme sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tableView.frame.size.width - 40, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
////        return MAX(size.height, 44);
//        
//        
//    }
    return 44;
}


#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.sectionsArray.count;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSArray *dataArray = self.sectionsArray[section];
//    return dataArray.count + 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    NSArray *dataArray = self.sectionsArray[indexPath.section];
//    cell.textLabel.text = dataArray[indexPath.row - 1];
//    
//    return cell;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        [self.sectionsArray removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
