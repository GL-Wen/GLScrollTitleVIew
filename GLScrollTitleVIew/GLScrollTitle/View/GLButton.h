//
//  GLButton.h
//  AutoLayoutTest
//
//  Created by William on 16/3/17.
//  Copyright © 2016年 William. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLButton : UIButton

@property (nonatomic, strong) UIView *sepLine;

@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleHightColor;

//是否处于高亮状态（选择状态）
@property (nonatomic, assign) BOOL isHight;

@end
