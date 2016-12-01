//
//  XMNRollingItemViewCell.m
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/11/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingItemViewCell.h"

@interface XMNRollingItemViewCell ()

@property (strong, nonatomic) id<XMNRollingItem> item;
@property (weak, nonatomic)   UIImageView *imageView;


@end

@implementation XMNRollingItemViewCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.imageView = imageView];
    }
    return self;
}

#pragma mark - Method

- (void)configItemViewWithData:(id<XMNRollingItem>)item {
    
    self.item = item;
    
    if ([item respondsToSelector:@selector(imagePath)]) {
        NSString *imagePath = [item imagePath];
        /** 直接加载固定图片 */
        UIImage *image = [UIImage imageNamed:imagePath];
        if (!image) {
            NSURL *imageURL = [NSURL URLWithString:imagePath];
            if ([imageURL isFileURL]) {
                /** 加载本地文件图片 */
                image = [UIImage imageWithContentsOfFile:imagePath];
            }else {
                /** 不处理网络图片,需要用户自定义处理 */
            }
        }
        self.imageView.image = image;
    }
}

@end
