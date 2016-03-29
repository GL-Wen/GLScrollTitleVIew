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

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation GLTitleScrollView

#pragma mark - Super

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.titleNormalColor = [UIColor grayColor];
        self.titleHightColor  = [UIColor redColor];
        self.titleFont        = [UIFont systemFontOfSize:15];
        
        [self addSubview:self.titleScrollContentView];
        [self.titleScrollContentView addSubview:self.titleBottomLine];
        [self.titleScrollContentView addSubview:self.bottomLine];
        
        __weak typeof(self) weakSelf = self;
        [weakSelf.titleScrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsZero);
            make.height.equalTo(weakSelf);
        }];
        
        [weakSelf.titleBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.bottom.equalTo(weakSelf.titleScrollContentView.mas_bottom);
            make.left.right.equalTo(weakSelf.titleScrollContentView);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [self updateTitleScrollContentViewLayout];
    [super layoutSubviews];
}

#pragma mark - Self

- (void)updateTitles
{
    [self.titleButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleButtonArray removeAllObjects];
    
    UIView *previousView = nil;
    
    NSInteger count = self.scrollTitleArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        NSString *title = self.scrollTitleArray[i];
        
        GLButton *button = [GLButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleNormalColor = self.titleNormalColor;
        button.titleHightColor  = self.titleHightColor;
        button.titleLabel.font  = self.titleFont;
        [self.titleScrollContentView addSubview:button];
        
        [self.titleButtonArray addObject:button];
        
        if (previousView) {
            
            [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_left).offset(0);
            }];
            
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
        
        button.isHight                 = 0 == i;
        
        if (i == count - 1)
            continue;
        
        button.sepLine.backgroundColor = self.sepLineColor;
    }
    
    [previousView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleScrollContentView);
    }];
    
    previousView = self.currentIndex < self.titleButtonArray.count ? self.titleButtonArray[self.currentIndex] : nil;
    if (previousView) {
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(previousView);
            make.centerX.equalTo(previousView);
            make.bottom.equalTo(self.titleScrollContentView.mas_bottom);
            make.height.equalTo(@2);
        }];
    }
}

- (void)updateTitleScrollContentViewLayout
{
    if (!self.titleButtonArray.count) 
        return;

    CGFloat width = 0;
    for (UIButton *btn in self.titleButtonArray) {
        width += btn.intrinsicContentSize.width;
    }
    
    UIView *previousView = nil;
    
    NSInteger count = self.titleButtonArray.count;
    __weak typeof(self) weakSelf = self;
    
    //如果titles的总宽度小于父视图的宽度，那么等分title视图的宽度
    if (width < self.bounds.size.width) {
        width = self.bounds.size.width;
        
        for (UIButton *btn in self.titleButtonArray) {
            
            CGSize contentSize = btn.intrinsicContentSize;
            contentSize.width = width / (CGFloat)count;
            
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(contentSize);
            }];
            
            previousView = btn;
        }
        
        previousView = self.titleButtonArray[0];
        [weakSelf.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(previousView);
        }];
    }
}

- (void)updateTitleIndex:(BOOL)animation
{
    if (self.currentIndex >= self.titleButtonArray.count)
        return;
    
    GLButton *button = self.titleButtonArray[self.currentIndex];
    [self updateTitleScrollViewContentOffsetWithButton:button isAnimation:animation];
    
    CGRect frame = [self.titleScrollContentView convertRect:button.frame toView:self.superview];
    
    if (frame.origin.x > self.superview.frame.size.width / 2. || frame.origin.x < self.superview.frame.size.width / 2.) {
        
        CGPoint contentOffset = self.contentOffset;
        contentOffset.x += frame.origin.x - self.frame.size.width / 2. + button.frame.size.width / 2.;
        
        if (contentOffset.x > self.contentSize.width - self.frame.size.width)
            contentOffset.x = self.contentSize.width - self.frame.size.width;
        
        if (contentOffset.x < 0)
            contentOffset.x = 0;
        
        [self setContentOffset:contentOffset animated:YES];
    }
}

- (void)updateTitleScrollViewContentOffsetWithButton:(GLButton *)button isAnimation:(BOOL)animation
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
    
    if (!animation)
        return;
    
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
    
    self.currentIndex = index;
    [self updateTitleIndex:YES];
}

#pragma mark - Set

- (void)setUpdateIndex:(NSUInteger)updateIndex
{
    self.currentIndex = updateIndex;
    [self updateTitleIndex:NO];
}

- (void)setScrollTitleArray:(NSArray *)scrollTitleArray
{
    _scrollTitleArray = nil;
    _scrollTitleArray = scrollTitleArray;
    
    [self updateTitles];
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
        _titleBottomLine.backgroundColor = [UIColor clearColor];
    }
    return _titleBottomLine;
}

@end
