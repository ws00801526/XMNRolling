//
//  XMNRollingItemViewCell.h
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/11/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRolling.h"

@interface XMNRollingItemViewCell : UICollectionViewCell <XMNRollingItemView>

@property (weak, nonatomic, readonly)   UIImageView *imageView;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end
