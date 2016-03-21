//
//  GLCollectionViewCell.m
//  AutoLayoutTest
//
//  Created by William on 16/3/17.
//  Copyright © 2016年 William. All rights reserved.
//

#import "GLCollectionViewCell.h"

@implementation GLCollectionViewCell

#pragma mark - Super

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [_cellContentView removeFromSuperview];
}

- (void)layoutSubviews
{
    NSLog(@"===== %@",self.subviews);
}

#pragma mark - Self

- (void)masCellContentViewLayout
{
    [_cellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - Set

- (void)setCellContentView:(UIView *)cellContentView
{
    _cellContentView = nil;
    _cellContentView = cellContentView;
    
    [self.contentView addSubview:_cellContentView];
    [self masCellContentViewLayout];
}

@end
