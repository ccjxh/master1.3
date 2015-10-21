//
//  pictureModel.h
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**单张图片数据模型*/
@interface pictureModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger fileSize;
@property(nonatomic)NSString*resource;
@property(nonatomic)NSString*workId;
@property(nonatomic)BOOL isSelect;
@end
