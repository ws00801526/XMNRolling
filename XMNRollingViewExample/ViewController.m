//
//  ViewController.m
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/11/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "ViewController.h"

#import "XMNRollingView.h"

#import "YYWebImage.h"

#import "UIImageView+YYWebImage.h"

@interface ViewController ()

/** 测试代码生成rollingView */
@property (weak, nonatomic)   XMNRollingView *rollingView;
/** 测试xib 加载rollingView */
@property (weak, nonatomic) IBOutlet XMNRollingView *rollingViewXIB;

@property (assign, nonatomic) XMNRollingTestMode testMode;
@property (copy, nonatomic, readonly)   NSArray<XMNTestRollingItem *> *testItems;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** 切换测试数据类型 */
    self.testMode = XMNRollingTestModeLocal;
    
    /** 清空网络图片缓存 */
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    
    /** 测试代码生成rollingView */
    //    XMNRollingView *rollingView = [[XMNRollingView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    //    [rollingView setItems:self.testItems];
    //    rollingView.rollingDirection = XMNRollingDirectionHorizontal;
    //    [self.view addSubview:self.rollingView = rollingView];
    
    /** 测试只有一个item */
    self.rollingViewXIB.items = self.testItems;
    
    /** 测试网络数组 */
    
    /** 测试使用placeholder */
    self.rollingViewXIB.placeholder = [UIImage imageNamed:@"placeholder.jpg"];
    
    /** 测试tapBlock */
    self.rollingViewXIB.tapBlock = ^(id<XMNRollingItem> item, NSInteger index){
        
        NSLog(@"you tap item :%@",item);
        NSLog(@"you tap index :%d",(int)index);
    };
    
    /** 测试自定义加载图片功能 */
    [self.rollingViewXIB setLoadRemoteBlock:^(UIImageView *imageView, id<XMNRollingItem> item, UIImage *placeholder) {
        
        [imageView yy_setImageWithURL:[NSURL URLWithString:[item imagePath]] placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }];
    
    /** 测试替换pageControl */
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor greenColor];
    pageControl.hidesForSinglePage = YES;
    self.rollingViewXIB.pageControl = (UIView<XMNRollingPageControl> *)pageControl;
    /** 测试隐藏pageControl */
//    self.rollingViewXIB.pageControl = nil;
    
    /** 测试 更改pageControlAlignment */
    self.rollingViewXIB.pageControlAlignment = XMNRollingPageControlAlignmentCenter;
    
    /** 测试更改rollingView 滚动方向 */
//    self.rollingViewXIB.rollingDirection = XMNRollingDirectionVertical;
    
    /** 测试修改rollingMode */
    self.rollingViewXIB.rollingMode =  XMNRollingModeFooter |
    XMNRollingModeAuto |
    XMNRollingModeReverse |
    XMNRollingModeInfiniteLoop;
    
    /** 测试footer出发block */
    [self.rollingViewXIB setFooterTrigerBlock:^{
       
        NSLog(@"footer triger");
    }];
}

#pragma mark - Getter

- (NSArray <XMNTestRollingItem *> *)testItems {
    
    switch (self.testMode) {
        case XMNRollingTestModeRemote:
            return [XMNTestRollingItem testRemoteItems];
            break;
        case XMNRollingTestModeSingle:
            return [XMNTestRollingItem testSingleItems:NO];
        case XMNRollingTestModeMixed:
            return [XMNTestRollingItem testMixedItems];
        default:
            return [XMNTestRollingItem testLocalItems];
            break;
    }
}

@end
