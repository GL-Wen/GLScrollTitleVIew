//
//  GLScrollView.m
//  GLScrollTitleVIew
//
//  Created by William on 16/3/20.
//  Copyright © 2016年 William. All rights reserved.
//

#import "GLScrollView.h"

@interface GLScrollView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation GLScrollView

#pragma mark - Get

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor yellowColor];
    }
    return _contentView;
}

#pragma mark - Super

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.equalTo(self);
            make.width.equalTo(self);
        }];
    }
    return self;
}

@end
