//
//  XMNRollingView.h
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/11/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRolling.h"

IB_DESIGNABLE

@interface XMNRollingView : UIView

@property (assign, nonatomic, readonly) NSInteger currentIndex;

/** 自动滚动时滚动间隔  默认5.0s*/
@property (assign, nonatomic) IBInspectable CGFloat duration;
@property (assign, nonatomic) XMNRollingMode rollingMode;
@property (assign, nonatomic) XMNRollingDirection rollingDirection;
/** 设置image边距 默认UIEdgeInsetZero */
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (assign, nonatomic) CGFloat cornerRadius;


@property (strong, nonatomic) IBInspectable UIImage *placeholder;
@property (copy, nonatomic)   NSArray<id<XMNRollingItem>> *items;

@property (copy, nonatomic)   void(^tapBlock)(id<XMNRollingItem> item, NSInteger index);
@property (copy, nonatomic)   void(^footerTrigerBlock)();

@property (copy, nonatomic)   void(^loadRemoteBlock)(UIImageView *imageView, id<XMNRollingItem> item, UIImage *placeholder);

/** 需要实现自定义UICollectionView时设置, 使用时需要先注册对应class,identifier */
@property (copy, nonatomic)   UICollectionViewCell<XMNRollingItemView> *(^customItemViewBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property (strong, nonatomic) UICollectionReusableView<XMNRollingFooterView> *footerView;

/** 可以自定义pageControl, 不设置默认使用UIPageControl */
@property (weak, nonatomic)   UIView<XMNRollingPageControl> *pageControl;
/** 设置pageControl对齐方式 */
@property (assign, nonatomic) XMNRollingPageControlAlignment pageControlAlignment;


- (void)registerItemViewClass:(Class)clazz
           forReuseIdentifier:(NSString *)identifier;
- (void)registerItemViewNib:(UINib *)nib
         forReuseIdentifier:(NSString *)identifier;
@end
