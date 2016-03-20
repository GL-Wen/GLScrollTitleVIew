//
//  ViewController.m
//  GLScrollTitleVIew
//
//  Created by William on 16/3/20.
//  Copyright © 2016年 William. All rights reserved.
//

#import "ViewController.h"
#import "GLTitleView.h"

@interface ViewController ()
<
GLTitleViewDelegate
>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    GLTitleView *titleView = [[GLTitleView alloc] initWithTitleArray:@[@"啊丫丫", @"啊丫丫", @"啊丫丫", @"啊丫丫",] titleHeight:39];
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
    contentView.backgroundColor = indexPath.row % 2 ? [UIColor redColor] : [UIColor blueColor];
    
    return contentView;
}

@end
