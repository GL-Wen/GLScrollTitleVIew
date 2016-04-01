//
//  GLScrollTitle.m
//  AutoLayoutTest
//
//  Created by William on 16/3/16.
//  Copyright © 2016年 William. All rights reserved.
//

#import "GLTitleView.h"
#import "GLTitleScrollView.h"
#import "GLButton.h"
#import "GLCollectionView.h"
#import "GLCollectionViewCell.h"

static NSString *const collectionCellIdentify = @"UICollectionViewCell";

@interface GLTitleView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) GLTitleScrollView *titleScrollView;
@property (nonatomic, strong) GLCollectionView  *collectionView;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) NSMutableDictionary *contentViewMutableDictionary;

@property (nonatomic, assign) CGFloat titleHeight;

@end

@implementation GLTitleView

#pragma mark - Super

- (instancetype)initWithTitleHeight:(CGFloat)height
{
    if (self = [super init]) {
        
        __weak typeof(self) weakSelf = self;
        self.titleScrollView.tapBlock = ^(NSUInteger index) {
            weakSelf.currentIndex = index;
        };
        
        [self addSubview:self.titleScrollView];
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomLine];
        
        [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
            make.left.top.right.equalTo(weakSelf);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf);
            make.height.equalTo(@1);
            make.top.equalTo(weakSelf).offset(height - 1);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(height, 0, 0, 0));
        }];
        
        self.titleHeight       = height;
        self.isAutoSwitchTitle = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [self updateItemSize];
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [self.titleScrollView updateConstraints];
    [super updateConstraints];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    
    if (currentIndex < 0)
        currentIndex = 0;
    
    if (currentIndex >= self.titleScrollView.scrollTitleArray.count)
        currentIndex = self.titleScrollView.scrollTitleArray.count - 1;
    
    [self updateCurrentIndex:currentIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.titleScrollView.updateIndex = currentIndex;
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleScrollView.scrollTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentify forIndexPath:indexPath];
    if (nil == collectionViewCell)
        collectionViewCell = [[GLCollectionViewCell alloc] init];
    
    id content = [self.contentViewMutableDictionary valueForKey:@(indexPath.row).stringValue];
    if (nil == content) {
        if ([self.delegate respondsToSelector:@selector(titleView:cellContentForItemAtIndexPath:)])
            content = [self.delegate titleView:self cellContentForItemAtIndexPath:indexPath];
            
        [self.contentViewMutableDictionary setValue:content forKey:@(indexPath.row).stringValue];
    }
    
    UIView *contentView = nil;
    if ([content isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)content;
        contentView = vc.view;
    }
    else if ([content isKindOfClass:[UIView class]]) {
        contentView = content;
    }
    
    collectionViewCell.cellContentView = contentView;
    
    if ([self.delegate respondsToSelector:@selector(titleView:scrollToContent:indexPath:)])
        [self.delegate titleView:self scrollToContent:content indexPath:indexPath];
    
    return collectionViewCell;
}

#pragma mark - Self

- (void)updateCurrentIndex:(NSUInteger)index
{
    CGPoint contentOffset = self.collectionView.contentOffset;
    contentOffset.x = index * self.collectionViewFlowLayout.itemSize.width;
    [self.collectionView setContentOffset:contentOffset animated:NO];
}

- (void)updateItemSize
{
    CGSize itemSize = self.frame.size;
    itemSize.height -= self.titleHeight;
    self.collectionViewFlowLayout.itemSize = itemSize;
}

- (void)loadCustomView
{
    [self addSubview:_customView];
    
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.titleScrollView);
    }];
    
    CGFloat rightMargin = self.customView.bounds.size.width;
    [self.titleScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-rightMargin);
    }];
}

#pragma mark - Set

- (void)setSepLineColor:(UIColor *)sepLineColor
{
    self.titleScrollView.sepLineColor = sepLineColor;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    self.titleScrollView.titleNormalColor = titleNormalColor;
}

- (void)setTitleHightColor:(UIColor *)titleHightColor
{
    self.titleScrollView.titleHightColor = titleHightColor;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self updateCurrentIndex:currentIndex];
    
    self.titleScrollView.updateIndex = currentIndex;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    self.bottomLine.backgroundColor = bottomLineColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    self.titleScrollView.titleFont = titleFont;
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView.superview)
        [_customView removeFromSuperview];
    
    _customView = nil;
    _customView = customView;
    
    [self loadCustomView];
}

- (void)setTitleArray:(NSArray *)titleArray
{
    if (!titleArray.count)
        return;
    
    self.titleScrollView.scrollTitleArray = titleArray;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    self.contentViewMutableDictionary = [NSMutableDictionary dictionary];
    [self.collectionView reloadData];
}

- (void)setTitleBottomLineColor:(UIColor *)titleBottomLineColor
{
    _titleBottomLineColor = nil;
    _titleBottomLineColor = titleBottomLineColor;
    
    self.titleScrollView.titleBottomLine.backgroundColor = _titleBottomLineColor;
}

- (void)setIsAutoSwitchTitle:(BOOL)isAutoSwitchTitle
{
    _isAutoSwitchTitle = isAutoSwitchTitle;
    
    self.collectionView.scrollEnabled = _isAutoSwitchTitle;
}

#pragma mark - Get

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor clearColor];
    }
    return _bottomLine;
}

- (GLTitleScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [GLTitleScrollView new];
    }
    return _titleScrollView;
}

- (UICollectionViewLayout *)collectionViewFlowLayout
{
    if (!_collectionViewFlowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing      = 0;
        
        _collectionViewFlowLayout = flowLayout;
    }
    return _collectionViewFlowLayout;
}

- (GLCollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[GLCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.pagingEnabled   = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[GLCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:collectionCellIdentify]];
        //不需要显示滚动条
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableDictionary *)contentViewMutableDictionary
{
    if (!_contentViewMutableDictionary) {
        _contentViewMutableDictionary = [NSMutableDictionary dictionary];
    }
    return _contentViewMutableDictionary;
}

@end
