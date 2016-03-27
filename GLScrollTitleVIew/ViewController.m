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

@end

@implementation ViewController

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

- (id)titleView:(GLTitleView *)titleView cellContentForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id content = nil;
    switch (indexPath.row) {
        case 0:
        {
            content = [GLScrollView new];
        }
            break;
            
        case 1:
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            GLListTableViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"listVc"];
            
            content = vc;
        }
            break;
            
        default:
            break;
    }
    
    return content;
}

- (void)titleView:(GLTitleView *)titleView scrollToContent:(id)content indexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"====content -->%@,\nindexPath -->%@",content,indexPath);
}

@end
