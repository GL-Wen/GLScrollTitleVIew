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

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) NSMutableDictionary *contentViewMutableDictionary;

@property (nonatomic, assign) CGFloat titleHeight;

@end

@implementation GLTitleView

#pragma mark - Super

- (instancetype)initWithTitleArray:(NSArray *)titleArray titleHeight:(CGFloat)height
{
    if (self = [super init]) {
        
        self.titleNormalColor = [UIColor grayColor];
        self.titleHightColor  = [UIColor redColor];
        self.bottomLineColor  = [UIColor redColor];
        self.titleFont        = [UIFont systemFontOfSize:15];
        
        self.currentIndex      = 0;
        self.titleHeight       = height;
        self.isAutoSwitchTitle = YES;
        
        self.titleArray = titleArray;
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

- (void)updateSepLineColor
{
    NSInteger count = self.titleScrollView.titleButtonArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        GLButton *button = self.titleScrollView.titleButtonArray[i];
        
        if (i != count - 1) 
            button.sepLine.backgroundColor = self.sepLineColor;
    }
}

- (void)updateScrollTitleColor
{
    NSInteger count = self.titleScrollView.titleButtonArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        GLButton *button        = self.titleScrollView.titleButtonArray[i];
        button.titleNormalColor = self.titleNormalColor;
        button.titleHightColor  = self.titleHightColor;
        button.isHight          = self.currentIndex == i;
    }
}

- (void)updateScrollTitleFont
{
    NSInteger count = self.titleScrollView.titleButtonArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        GLButton *button        = self.titleScrollView.titleButtonArray[i];
        button.titleLabel.font  = self.titleFont;
    }
}

- (void)loadCustomView
{
    [self addSubview:_customView];
    
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)updateScrollTitleView
{
    __weak typeof(self) weakSelf = self;
    
    _titleScrollView = [[GLTitleScrollView alloc] initWithTitleArray:self.titleArray];
    _titleScrollView.backgroundColor                 = [UIColor whiteColor];
    _titleScrollView.titleBottomLine.backgroundColor = self.titleBottomLineColor;
    _titleScrollView.bottomLine.backgroundColor      = self.bottomLineColor;
    _titleScrollView.tapBlock = ^(NSUInteger index) {
        weakSelf.currentIndex = index;
    };
    
    [self updateScrollTitleColor];
    [self updateScrollTitleFont];
    
    [self addSubview:self.titleScrollView];
    [self addSubview:self.collectionView];
    
    CGFloat rightMargin = self.customView.intrinsicContentSize.width;
    
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.titleHeight));
        make.top.left.equalTo(self);
        make.right.equalTo(self).with.offset(-rightMargin);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(self.titleHeight, 0, 0, 0));
    }];
}

#pragma mark - Set

- (void)setSepLineColor:(UIColor *)sepLineColor
{
    _sepLineColor = nil;
    _sepLineColor = sepLineColor;
    
    [self updateSepLineColor];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = nil;
    _titleNormalColor = titleNormalColor;
    
    [self updateScrollTitleColor];
}

- (void)setTitleHightColor:(UIColor *)titleHightColor
{
    _titleHightColor = nil;
    _titleHightColor = titleHightColor;
    
    [self updateScrollTitleColor];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self updateCurrentIndex:currentIndex];
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = nil;
    _bottomLineColor = bottomLineColor;
    
    self.titleScrollView.bottomLine.backgroundColor = _bottomLineColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = nil;
    _titleFont = titleFont;
    
    [self updateScrollTitleFont];
}

- (void)setCustomView:(UIView *)customView
{
    _customView = nil;
    _customView = customView;
    
    self.titleScrollView.rightMargin = customView.frame.size.width;
    
    [self loadCustomView];
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = nil;
    _titleArray = titleArray;
    
    [self updateScrollTitleView];
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
        _collectionView.showsVerticalScrollIndicator = NO;
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
