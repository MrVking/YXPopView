//
//  YXPopView.h
//  YXPopView
//
//  Created by shiqin on 2017/1/4.
//  Copyright © 2017年 mifo. All rights reserved.


#import <UIKit/UIKit.h>


@interface YXPopView : UIView

@property (strong) UIFont * titleLabFont;

@property (strong) UIColor * titleLabColor;

@property (strong) UIFont * subTitleLabFont;

@property (strong) UIColor * subTitleLabColor;

@property (assign) NSTextAlignment cellLabAlignment;


+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle dataArray:(NSArray *)array clickRow:(void(^)(NSInteger row))click;

+ (void)dismiss;

@end
