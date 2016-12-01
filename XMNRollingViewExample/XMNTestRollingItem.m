//
//  XMNTestRollingItem.m
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/12/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNTestRollingItem.h"

@implementation XMNTestRollingItem

+ (XMNTestRollingItem *)itemWithImagePath:(NSString *)imagePath {
    
    XMNTestRollingItem *item = [[XMNTestRollingItem alloc] init];
    item.imagePath = imagePath;
    return item;
}

+ (NSArray <XMNTestRollingItem *> *)testSingleItems:(BOOL)isRemote {
    
    return @[[isRemote ? [self testRemoteItems] : [self testLocalItems] firstObject]];
}

+ (NSArray <XMNTestRollingItem *> *)testLocalItems {
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *localImages = @[@"1.jpg",@"2.jpeg",@"3.jpg",@"4.jpg",@"none.jpg"];
    
    [localImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[XMNTestRollingItem itemWithImagePath:obj]];
    }];
    return [NSArray arrayWithArray:array];
}

+ (NSArray <XMNTestRollingItem *> *)testRemoteItems {
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *localImages = @[@"http://g.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=a1ab21c9cefcc3ceb495c137a775fabe/37d12f2eb9389b50a9794db98335e5dde6116e53.jpg",@"http://f.hiphotos.baidu.com/zhidao/pic/item/8b82b9014a90f60326b707453b12b31bb051eda9.jpg",@"http://c.hiphotos.baidu.com/zhidao/pic/item/2f738bd4b31c870113fcdcf6217f9e2f0708ff5c.jpg",@"http://b.hiphotos.baidu.com/zhidao/pic/item/b21bb051f81986180f030a8049ed2e738bd4e66a.jpg",@"http://pic2.qiyipic.com/common/20130828/57b5da22128740ddac176e941c1b685d.jpg?src=focustat_4_20130527_10"];
    
    [localImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[XMNTestRollingItem itemWithImagePath:obj]];
    }];
    return [NSArray arrayWithArray:array];
}

+ (NSArray <XMNTestRollingItem *> *)testMixedItems {
    
    NSMutableArray *array  = [NSMutableArray array];
    [array addObjectsFromArray:[self testLocalItems]];
    [array addObjectsFromArray:[self testRemoteItems]];
    
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       
        int seed = arc4random_uniform(2) % 2;
        return seed ? NSOrderedAscending : NSOrderedDescending;
    }];
    return [NSArray arrayWithArray:array];
}


@end

