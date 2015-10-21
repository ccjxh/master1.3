//
//  searchFriendViewController.m
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "searchFriendViewController.h"

@interface searchFriendViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation searchFriendViewController
{

    UISearchBar*_searchBar;
    NSMutableArray*_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataArray];
    [self createSearch];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createDataArray{

    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }

}

-(void)createSearch{

    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.placeholder=@"请输入要搜索的内容";
    _searchBar.delegate=self;
    _searchBar.returnKeyType=UIReturnKeyDone;
    [_searchBar becomeFirstResponder];
    self.navigationItem.titleView=_searchBar;
     [_searchBar becomeFirstResponder];
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{


    
    
}



-(void)cancle{

    [_searchBar resignFirstResponder];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;

}



@end
