//
//  XMNRolling.h
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/11/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#ifndef XMNRolling_h
#define XMNRolling_h

#import <UIKit/UIKit.h>

/**
 滚动类型
 */
typedef NS_OPTIONS(NSUInteger, XMNRollingMode) {
    
    /** 无额外滚动类型 */
    XMNRollingModeNone = 1 << 0,
    /** 自动滚动  2 */
    XMNRollingModeAuto = 1 << 1,
    /** 循环滚动  4*/
    XMNRollingModeInfiniteLoop = 1 << 2,
    /** 逆向滚动  8 */
    XMNRollingModeReverse = 1 << 3,
    /** 显示footerView 与XMNRollingModeInfinite 互斥  16*/
    XMNRollingModeFooter = 1 << 4,
    /** 默认滚动类型  自动滚动 + 无限滚动 */
    XMNRollingModeDefault = 6,
};

/**
 滚动方向
 
 - XMNRollingDirectionHorizontal: 水平方向滚动
 - XMNRollingDirectionVertical: 垂直方向滚动
 */
typedef NS_ENUM(NSUInteger, XMNRollingDirection) {
    
    /** 水平方向滚动 */
    XMNRollingDirectionHorizontal = UICollectionViewScrollDirectionHorizontal,
    /** 垂直方向滚动 */
    XMNRollingDirectionVertical = UICollectionViewScrollDirectionVertical,
};


/**
 XMNRollingPageControl对齐方式
 
 - XMNRollingPageControlAlignmentCenter: 居中对齐,默认对齐方式
 - XMNRollingPageControlAlignmentLeft: 居左对齐
 - XMNRollingPageControlAlignmentRight: 居右对齐
 */
typedef NS_ENUM(NSUInteger, XMNRollingPageControlAlignment) {
    
    XMNRollingPageControlAlignmentCenter = 0,
    XMNRollingPageControlAlignmentLeft,
    XMNRollingPageControlAlignmentRight,
};



/** footerView状态 */
typedef NS_ENUM(NSUInteger, XMNRollingFooterState) {
    /** 默认状态 */
    XMNRollingFooterStateIdle = 0,
    /** 触发状态 */
    XMNRollingFooterStateTrigger,
};

@protocol XMNRollingItem <NSObject>

@required
- (NSString *)imagePath;
- (NSString *)title;

@end

@protocol XMNRollingItemView <NSObject>

@property (strong, nonatomic, readonly) id<XMNRollingItem> item;

@required
- (void)configItemViewWithData:(id<XMNRollingItem>)item;

@end

@protocol XMNRollingPageControl <NSObject>

@property (assign, nonatomic) BOOL hidesForSinglePage;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UIColor   *pageIndicatorTintColor;
@property (strong, nonatomic) UIColor   *currentPageIndicatorTintColor;

@optional
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end


@protocol XMNRollingFooterView <NSObject>

@required
- (XMNRollingFooterState)state;
- (void)setState:(XMNRollingFooterState)state;
@end

#endif /* XMNRolling_h */
