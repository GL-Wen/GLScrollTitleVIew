//
//  ViewController.m
//  GLScrollTitleVIew
//
//  Created by William on 16/3/20.
//  Copyright © 2016年 William. All rights reserved.
//

#import "ViewController.h"
#import "GLTitleView.h"
#import "GLScrollView.h"
#import "GLListTableViewController.h"

@interface ViewController ()
<
GLTitleViewDelegate
>

@property (nonatomic, strong) NSMutableArray *contentsArray;

@end

@implementation ViewController

#pragma mark - Get

- (NSMutableArray *)contentsArray
{
    if (!_contentsArray) {
        _contentsArray = [NSMutableArray array];
    }
    return _contentsArray;
}

#pragma mark - Super

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    GLTitleView *titleView = [[GLTitleView alloc] initWithTitleArray:@[@"菜单1", @"菜单2"] titleHeight:39];
    titleView.sepLineColor = [UIColor lightGrayColor];
    titleView.delegate     = self;
    [self.view addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLTitleViewDelegate

- (UIView *)titleView:(GLTitleView *)titleView cellContentViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *contentView = [UIView new];
    switch (indexPath.row) {
        case 0:
        {
            contentView = [GLScrollView new];
        }
            break;
            
        case 1:
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            GLListTableViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"listVc"];
            contentView = vc.tableView;
            
            [self.contentsArray addObject:vc];
        }
            break;
            
        default:
            break;
    }
    
    return contentView;
}

@end
