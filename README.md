该视图需要使用第三方自动布局工具类Masonry，使用步骤如下

1.#import "GLTitleView.h"

2.加载视图

    GLTitleView *titleView = [[GLTitleView alloc] initWithTitleArray:@[@"啊丫丫", @"啊丫丫", @"啊丫丫", @"啊丫丫",] titleHeight:39];
    titleView.sepLineColor = [UIColor lightGrayColor];
    titleView.delegate     = self;
    [self.view addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
3.实现contentView代理协议
    #pragma mark - GLTitleViewDelegate

    - (id)titleView:(GLTitleView *)titleView cellContentForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        id content = nil;//view或者ViewController
        return content;
    }
