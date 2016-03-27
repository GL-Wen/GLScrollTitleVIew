//
//  GLTitleScrollView.m
//  AutoLayoutTest
//
//  Created by William on 16/3/17.
//  Copyright © 2016年 William. All rights reserved.
//

#import "GLTitleScrollView.h"
#import "GLButton.h"

@interface GLTitleScrollView ()

@property (nonatomic, strong) UIView         *titleScrollContentView;

@end

@implementation GLTitleScrollView

#pragma mark - Super

- (instancetype)initWithTitleArray:(NSArray *)titleArray
{
    if (self = [super init]) {
        
        if (!titleArray.count)
            return nil;
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.scrollTitleArray = titleArray;
        [self updateTitles];
        
        [self addSubview:self.titleScrollContentView];
        [self.titleScrollContentView addSubview:self.titleBottomLine];
        [self.titleScrollContentView addSubview:self.bottomLine];
        
        __weak typeof(self) weakSelf = self;
        
        [weakSelf.titleScrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakSelf);
            make.top.left.right.equalTo(weakSelf);
        }];
        
        GLButton *button = self.titleButtonArray[0];
        [weakSelf.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.bottom.equalTo(weakSelf.titleScrollContentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(button.intrinsicContentSize.width, 2));
        }];
        
        [weakSelf.titleBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.bottom.equalTo(weakSelf.titleScrollContentView.mas_bottom);
            make.left.right.equalTo(weakSelf.titleScrollContentView);
        }];
    }
    return self;
}

- (void)updateConstraints
{
    [self updateTitleScrollContentViewLayout];
    [super updateConstraints];
}

#pragma mark - Self

- (void)updateTitles
{
    UIView *previousView = nil;
    
    NSInteger count = self.scrollTitleArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        NSString *title = self.scrollTitleArray[i];
        
        GLButton *button = [GLButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollContentView addSubview:button];
        
        [self.titleButtonArray addObject:button];
        
        if (previousView) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleScrollContentView);
                make.left.equalTo(previousView.mas_right).with.offset(0);
            }];
        }
        else
        {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleScrollContentView);
                make.left.equalTo(self.titleScrollContentView).with.offset(0);
            }];
        }
        
        previousView = button;
    }
    
    previousView = [self.titleButtonArray lastObject];
    [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleScrollContentView.mas_right);
    }];
}

- (void)updateTitleScrollContentViewLayout
{
    CGFloat width = 0;
    for (UIButton *btn in self.titleButtonArray) {
        width += btn.intrinsicContentSize.width;
    }
    
    UIView *previousView = [self.titleButtonArray lastObject];
    
    //如果titles的总宽度小于父视图的宽度，那么等分title视图的宽度
    if (width < self.superview.superview.frame.size.width - self.rightMargin) {
        
        width = self.superview.superview.frame.size.width - self.rightMargin;
        
        CGSize size      = CGSizeZero;
        CGFloat sepWidth = width / (CGFloat)self.titleButtonArray.count;
        
        __weak typeof(self) weakSelf = self;
        for (UIButton *btn in self.titleButtonArray) {
            
            size       = btn.intrinsicContentSize;
            size.width = sepWidth;
            
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(size);
            }];
            
            previousView = btn;
        }
        
        previousView = self.titleButtonArray[0];
        
        [weakSelf.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(sepWidth, 2));
        }];
    }
}

- (void)updateTitleIndex
{
    if (self.updateIndex >= self.titleButtonArray.count)
        return;
    
    GLButton *button = self.titleButtonArray[self.updateIndex];
    [self updateTitleScrollViewContentOffsetWithButton:button];
    
    CGRect frame = [self.titleScrollContentView convertRect:button.frame toView:self.superview];
    
    if (frame.origin.x > self.superview.frame.size.width / 2. || frame.origin.x < self.superview.frame.size.width / 2.) {
        
        CGPoint contentOffset = self.contentOffset;
        contentOffset.x += frame.origin.x - self.frame.size.width / 2. + button.frame.size.width / 2.;
        
        if (contentOffset.x < 0)
            contentOffset.x = 0;
        else if (contentOffset.x > self.contentSize.width - self.frame.size.width)
            contentOffset.x = self.contentSize.width - self.frame.size.width;
        
        [self setContentOffset:contentOffset animated:YES];
    }
}

- (void)updateTitleScrollViewContentOffsetWithButton:(GLButton *)button
{
    [self.titleButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GLButton *btn = obj;
        btn.isHight = btn == button;
    }];
    
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(button);
        make.centerX.equalTo(button);
        make.bottom.equalTo(self.titleScrollContentView.mas_bottom);
        make.height.equalTo(@2);
    }];
    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self layoutIfNeeded];
    } completion:NULL];
}

#pragma mark - Action

- (void)buttonOnClick:(GLButton *)button
{
    NSUInteger index = [self.titleButtonArray indexOfObject:button];
    if (self.tapBlock) 
        self.tapBlock(index);
    
    self.updateIndex = index;
}

#pragma mark - Set

- (void)setUpdateIndex:(NSUInteger)updateIndex
{
    _updateIndex = updateIndex;
    
    [self updateTitleIndex];
}

#pragma mark - Get

- (NSMutableArray *)titleButtonArray
{
    if (!_titleButtonArray) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

- (UIView *)titleScrollContentView
{
    if (!_titleScrollContentView) {
        _titleScrollContentView = [UIView new];
    }
    return _titleScrollContentView;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor redColor];
    }
    return _bottomLine;
}

- (UIView *)titleBottomLine
{
    if (!_titleBottomLine) {
        _titleBottomLine = [UIView new];
    }
    return _titleBottomLine;
}

@end
