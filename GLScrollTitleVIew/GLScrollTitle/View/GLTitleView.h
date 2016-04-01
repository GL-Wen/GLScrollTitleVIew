//
//  GLScrollTitle.h
//  AutoLayoutTest
//
//  Created by William on 16/3/16.
//  Copyright © 2016年 William. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLTitleView;
@protocol GLTitleViewDelegate <NSObject>
@optional

- (UIView *)titleView:(GLTitleView *)titleView cellContentViewForItemAtIndexPath:(NSIndexPath *)indexPath;

//兼容返回viewController
- (id)titleView:(GLTitleView *)titleView cellContentForItemAtIndexPath:(NSIndexPath *)indexPath;

//当前滚动视图
- (void)titleView:(GLTitleView *)titleView scrollToContent:(id)content indexPath:(NSIndexPath *)indexPath;

@end

@interface GLTitleView : UIView

//分割线颜色（不为空默认显示标题之间分割线）
@property (nonatomic, strong) UIColor *sepLineColor;

//底部横线背景色
@property (nonatomic, strong) UIColor *bottomLineColor;

//标题普通状态颜色
@property (nonatomic, strong) UIColor *titleNormalColor;

//标题高亮状态颜色
@property (nonatomic, strong) UIColor *titleHightColor;

//菜单底部视图横线
@property (nonatomic, strong) UIColor *titleBottomLineColor;

//用户自定义view
@property (nonatomic, strong) UIView *customView;

//标题大小
@property (nonatomic, strong) UIFont *titleFont;

//标题容器
@property (nonatomic, strong) NSArray *titleArray;

//当前索引值
@property (nonatomic, assign) NSUInteger currentIndex;

//是否自动切换标题（滚动子视图的时候），默认开启
@property (nonatomic, assign) BOOL isAutoSwitchTitle;

@property (nonatomic, weak) id<GLTitleViewDelegate> delegate;

/*!
 *  @author William, 16-03-16 21:03:10
 *
 *  初始化titleView视图
 *
 *  @param height     title视图高度
 *
 *  @return titleView视图对象
 *
 *  @since 1.0
 */
- (instancetype)initWithTitleHeight:(CGFloat)height;

@end
