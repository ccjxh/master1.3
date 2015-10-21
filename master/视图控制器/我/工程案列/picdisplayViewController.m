//
//  picdisplayViewController.m
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "picdisplayViewController.h"

@interface picdisplayViewController ()

@end

@implementation picdisplayViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor=[UIColor blackColor];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    [self flowShow];
    self.scrollview.pagingEnabled=YES;
    self.scrollview.contentSize=CGSizeMake(SCREEN_WIDTH*self.dataArray.count, self.scrollview.frame.size.height);
    for (NSInteger i=0;i<_dataArray.count; i++) {
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, 320)];
        pictureModel*model=_dataArray[i];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        UIPinchGestureRecognizer*pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
        imageview.contentMode=1;
        imageview.userInteractionEnabled=YES;
        [imageview addGestureRecognizer:pinchGestureRecognizer];
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [self.scrollview addSubview:imageview];
    }
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-25, self.view.frame.origin.y+20, 20, 20)];
    [button setImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    [self flowHide];
}

- (void) handlePinches:(UIPinchGestureRecognizer*)paramSender{
    //UIPinchGestureRecognizer其中有两个比较重要的变量 scale 和 velocity,前者是一个比例范围,后者是一个变化速率的,也就是说每次变化的一个像素点。
    if (paramSender.state == UIGestureRecognizerStateEnded){
        self.currentScale = paramSender.scale;
    } else if (paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f){
        paramSender.scale = self.currentScale;
    }
    if (paramSender.scale != NAN && paramSender.scale != 0.0){
        paramSender.view.transform = CGAffineTransformMakeScale(paramSender.scale,
                                                                paramSender.scale);
    }
}


-(void)pop{

    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
