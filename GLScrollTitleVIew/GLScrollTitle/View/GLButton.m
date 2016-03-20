//
//  GLButton.m
//  AutoLayoutTest
//
//  Created by William on 16/3/17.
//  Copyright © 2016年 William. All rights reserved.
//

#import "GLButton.h"

@implementation GLButton

#pragma mark - Super

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.sepLine];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@.5);
            make.height.equalTo(self.mas_height).multipliedBy(.5);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width += 20;
    
    return size;
}

#pragma mark - Self

- (void)updateTitleColor
{
    [self setTitleColor:_isHight ? _titleHightColor : _titleNormalColor forState:UIControlStateNormal];
}

#pragma mark - Set

- (void)setIsHight:(BOOL)isHight
{
    _isHight = isHight;
    
    [self updateTitleColor];
}

#pragma mark - Get

- (UIView *)sepLine
{
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.backgroundColor = [UIColor clearColor];
    }
    return _sepLine;
}

@end
