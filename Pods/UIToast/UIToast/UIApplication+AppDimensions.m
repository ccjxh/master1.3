//
//  UIApplication+AppDimensions.m
//  UIToast
//
//  Created by Francesco Perrotti-Garcia on 2/3/15.
//  Copyright (c) 2015 Francesco Perrotti-Garcia. All rights reserved.
//

#import "UIApplication+AppDimensions.h"

// UIApplication category by Sam (http://stackoverflow.com/users/590956/sam)

@implementation UIApplication (AppDimensions)

+ (CGSize)currentSize {
    return [UIApplication
        sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO) {
        size.height -= MIN(application.statusBarFrame.size.width,
                           application.statusBarFrame.size.height);
    }
    return size;
}

@end
