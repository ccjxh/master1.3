//
//  serviceAdressCell.m
//  master
//
//  Created by jin on 15/9/25.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "serviceAdressCell.h"
#import "serviceAdressModel.h"
@implementation serviceAdressCell
{
    UILabel*_label;
    UIView*_content;
    CGFloat _YPonit;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 20)];
        _label.text=@"服务区域";
        _label.textColor=[UIColor blackColor];
        _label.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label];
        _content=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 5, SCREEN_WIDTH-120, 20)];
        [self.contentView addSubview:_content];
    }
    
    return self;

}



-(void)reloadDataWithModel:(model *)model{

    serviceAdressModel*adressModel=(serviceAdressModel*)model;
    NSString*cityString=nil;
    NSString*townString=nil;
    for (NSInteger i=0; i<adressModel.serviceArray.count; i++) {
       
        NSMutableArray*array=adressModel.serviceArray[i];
        for (NSInteger j=0; j<array.count; j++) {
            AreaModel*model=array[j];
            
            if (j==0) {
                
                cityString=[NSString stringWithFormat:@"%@:",model.name];
                
            }
            else if (j==1) {
                
                townString=model.name;
                
            }
            else if (j==array.count-1){
                townString=[NSString stringWithFormat:@"%@,%@",townString,model.name];
                
            }
            else{
                townString=[NSString stringWithFormat:@"%@,%@",townString,model.name];
            }
            
        }
        
        UILabel* cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, _YPonit, 100, 17)];
        cityLabel.text=cityString;
        
        cityLabel.font=[UIFont systemFontOfSize:16];
        cityLabel.numberOfLines=0;
        cityLabel.textColor=[UIColor blackColor];
        CGFloat height=[self accountStringHeightFromString:townString Width:SCREEN_WIDTH-140];
        UILabel*townLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, _YPonit, SCREEN_WIDTH-110-30, height)];
        _YPonit+=height;
        townLabel.font=[UIFont systemFontOfSize:16];
        townLabel.textColor=[UIColor blackColor];
        townLabel.numberOfLines=0;
        townLabel.text=townString;
        townLabel.textAlignment=NSTextAlignmentRight;
        [_content addSubview:cityLabel];
        [_content addSubview:townLabel];
        [self.contentView addSubview:_content];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

}

@end
