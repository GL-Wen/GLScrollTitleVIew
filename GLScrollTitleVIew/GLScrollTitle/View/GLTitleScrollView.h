//
//  GLTitleScrollView.h
//  AutoLayoutTest
//
//  Created by William on 16/3/17.
//  Copyright © 2016年 William. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleButtonTapIndexBlcok)(NSUInteger index);

@interface GLTitleScrollView : UIScrollView

//title容器
@property (nonatomic, strong) NSArray *scrollTitleArray;

//标题视图容器
@property (nonatomic, strong) NSMutableArray *titleButtonArray;

@property (nonatomic, strong) UIView *titleBottomLine;

@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleHightColor;
@property (nonatomic, strong) UIColor *sepLineColor;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, copy) titleButtonTapIndexBlcok tapBlock;

@property (nonatomic, assign) NSUInteger updateIndex;

@end
