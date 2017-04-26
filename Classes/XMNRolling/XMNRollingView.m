//
//  XMNRollingView.m
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/11/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingView.h"
#import "XMNRollingFooterView.h"
#import "XMNRollingItemViewCell.h"

static const NSInteger kXMNRollingMaxSections = 20;
static const NSInteger kXMNRollingDuration = 1.f;

@interface XMNRollingView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic)   UIImageView *emptyView;
@property (weak, nonatomic)   UICollectionView *collectionView;
@property (weak, nonatomic, readonly)   UICollectionViewFlowLayout *collectionViewLayout;

@property (copy, nonatomic)   NSArray<NSLayoutConstraint *> *pageControlConstraints;


@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) CGFloat footerSpace;
@property (assign, nonatomic, getter=isReverseRolling) BOOL reverseRolling;

@property (assign, nonatomic, readonly) NSInteger currentSection;
@property (assign, nonatomic, readonly) BOOL shouldShowFooter;
@property (assign, nonatomic, readonly) BOOL shouldInfiniteLoop;
@property (assign, nonatomic, readonly) BOOL shouldReverse;
@property (assign, nonatomic, readonly) BOOL shouldAuto;

@end

@implementation XMNRollingView
@synthesize rollingMode = _rollingMode;
@synthesize footerView = _footerView;

#pragma mark - Life Cycle

- (instancetype)init {
    
    return [self initWithMode:XMNRollingModeDefault
                    direction:XMNRollingDirectionHorizontal
                        items:nil
                        frame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {

        _duration = kXMNRollingDuration;
        _rollingMode = XMNRollingModeDefault;
        _rollingDirection = XMNRollingDirectionHorizontal;
        _pageControlAlignment = XMNRollingPageControlAlignmentCenter;

        [self setupUI];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithMode:XMNRollingModeDefault
                    direction:XMNRollingDirectionHorizontal
                        items:nil
                        frame:frame];
}

- (instancetype)initWithMode:(XMNRollingMode)mode
                   direction:(XMNRollingDirection)direction
                       items:(NSArray *)items
                       frame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        
        _duration = kXMNRollingDuration;
        _rollingMode = mode;
        _rollingDirection = direction;
        _items = [items copy];
        _pageControlAlignment = XMNRollingPageControlAlignmentCenter;
        
        [self setupUI];
        [self setup];
    }
    return self;
}


#pragma mark - Override Method

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    NSLog(@"did set frame");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.emptyView.frame = self.bounds;
    self.collectionView.frame = self.bounds;
    self.collectionViewLayout.itemSize = self.bounds.size;
    NSLog(@"did layout subviews");
}

- (void)didMoveToSuperview {
    
    if (self.superview) {
        self.collectionView.backgroundColor = self.backgroundColor = self.superview.backgroundColor;
    }
}

#pragma mark - Method

- (void)setup {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.pageControl.numberOfPages = self.items.count;

    if (self.shouldAuto) { /** 如果允许自动滚动 开启自动滚到定时器 */
        self.timer = [NSTimer timerWithTimeInterval:self.duration target:self selector:@selector(hanldeTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.duration]];
        [self.timer fire];
    }
    
    /** 增加emptyView配置 */
    if (!self.items || !self.items.count) {
        
        if (self.emptyView) {
            self.emptyView.image = self.placeholder;
        }else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.placeholder];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:self.emptyView = imageView];
        }
        /** 重新排序位置 */
        [self bringSubviewToFront:self.emptyView];
        [self bringSubviewToFront:self.pageControl];
        return;
    }
    
    if (self.shouldShowFooter) {
        self.collectionViewLayout.footerReferenceSize = CGSizeMake(40, self.collectionViewLayout.itemSize.height);
    }
    
    /** 如果有数据,则直接删除emptyView */
    [self.emptyView removeFromSuperview];

    /** 判断collectionView 是否可以滚动, 一张图片时 默认有应该不可以滚动 */
    self.collectionView.scrollEnabled = (self.items.count > 1) || self.shouldShowFooter;
    
    [self.collectionView reloadData];
    
    if (self.shouldInfiniteLoop && self.items.count && self.items.count >= 1) {
    
        /** 需要使用GCD方式,否则collectionView不会滚动到具体位置 */
        __weak typeof(*&self) wSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(*&wSelf) self = wSelf;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[self.collectionView numberOfSections]/2]
                                        atScrollPosition:self.rollingDirection == XMNRollingDirectionVertical ? UICollectionViewScrollPositionCenteredVertically : UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        });
    }
}

- (void)setupUI {
    
    [self setupCollectionView];
    [self setupPageControl];
    
    [self.collectionView reloadData];
}

/**
 初始化collectionView
 */
- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
    flowLayout.scrollDirection = (UICollectionViewScrollDirection)self.rollingDirection;
    flowLayout.minimumLineSpacing = .0f;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView = collectionView];
    
    [self.collectionView registerClass:[XMNRollingFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XMNRollingFooterView"];
    [self.collectionView registerClass:[XMNRollingItemViewCell class] forCellWithReuseIdentifier:@"XMNRollingItemViewCell"];
}

/**
 初始化默认的pageControl
 */
- (void)setupPageControl {
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.items.count;
    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl = (UIView<XMNRollingPageControl> *)pageControl;
}

/**
 更新pageControl的自动布局约束
 */
- (void)updatePageControlConstraint {
    
    if (self.pageControl && self.pageControl.superview) {
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self removeConstraints:self.pageControlConstraints];
        
        NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
        
        switch (self.pageControlAlignment) {
            case XMNRollingPageControlAlignmentLeft:
                [constraints addObject:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:15.f]];
                break;
            case XMNRollingPageControlAlignmentRight:
                [constraints addObject:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:-15.f]];
                break;
            default:
                [constraints addObject:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
                break;
        }
        
        [self addConstraints:self.pageControlConstraints = [NSArray arrayWithArray:constraints]];
    }
}

#pragma mark - Events 

- (void)hanldeTimerAction {
    
    NSLog(@"timer fired");
    BOOL animated = YES;
    NSIndexPath *nextIndexPath = [self  nextRollingIndexPath:&animated];
    
    if (nextIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath
                                    atScrollPosition:self.rollingDirection == XMNRollingDirectionVertical ? UICollectionViewScrollPositionCenteredVertically : UICollectionViewScrollPositionCenteredHorizontally
                                            animated:animated];
    }
}



/**
 计算下一个滚动的indexPath

 @param animated 是否需要动画 inout 参数
 @return 下一个滚动的indexPath 可能为nil
 */
- (NSIndexPath *)nextRollingIndexPath:(inout BOOL *)animated {

    if (self.isReverseRolling) {
        return [self nextReverseingIndexPath:animated];
    }
    NSInteger section = self.currentSection;
    NSInteger item = self.currentIndex;
    NSLog(@"\n before scroll item :%d \n  section :%d \n",(int)item,(int)section);
    item ++;
    if (item >= self.items.count) {
        item = 0;
        section ++;
    }
    
    if (section >= [self.collectionView numberOfSections]) {
        
        if (self.shouldReverse) {
            self.reverseRolling = YES;
            return [self nextRollingIndexPath:animated];
        }else {
            section = 0;
            *animated = NO;
        }
    }
    
    if (item < self.items.count && section < [self.collectionView numberOfSections]) {

        NSLog(@"\n after scroll item :%d \n  section :%d \n",(int)item,(int)section);
        return [NSIndexPath indexPathForItem:item inSection:section];
    }
    return nil;
}


/**
 计算逆向滚动时,下一个滚动的indexPath

 @param animated 是否动画 inout参数
 @return 下一个可以滚动的indexPath 可能为空
 */
- (NSIndexPath *)nextReverseingIndexPath:(inout BOOL *)animated {
    
    NSInteger section = self.currentSection;
    NSInteger item = self.currentIndex;
    NSLog(@"\n before scroll item :%d \n  section :%d \n",(int)item,(int)section);
    item --;
    if (item < 0) {
        item = self.items.count - 1;
        section --;
    }
    if (section < 0) {
        if (self.shouldReverse) {
            self.reverseRolling = NO;
            return [self nextRollingIndexPath:animated];
        }else {
            section = [self.collectionView numberOfSections] - 1;
            *animated = NO;
        }
    }
    
    if (item >= 0 && item < self.items.count && section >= 0 && section < [self.collectionView numberOfSections]) {
        
        NSLog(@"\n after scroll item :%d \n  section :%d \n",(int)item,(int)section);
        return [NSIndexPath indexPathForItem:item inSection:section];
    }
    return nil;
}

#pragma mark - Method

- (void)registerItemViewClass:(Class)clazz
           forReuseIdentifier:(NSString *)identifier {

    NSAssert(clazz, @"itemView nib should not be nil");
    NSAssert(identifier, @"itemView nib should not be nil");
    
    [self.collectionView registerClass:clazz
            forCellWithReuseIdentifier:identifier];
}

- (void)registerItemViewNib:(UINib *)nib
         forReuseIdentifier:(NSString *)identifier {
    
    NSAssert(nib, @"itemView nib should not be nil");
    NSAssert(identifier, @"itemView nib should not be nil");
    
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (!self.items || !self.items.count) {
        return 0;
    }
    if (self.rollingMode & XMNRollingModeInfiniteLoop) {
        
        return kXMNRollingMaxSections ;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.customItemViewBlock) {
        return self.customItemViewBlock(collectionView, indexPath);
    }
    XMNRollingItemViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNRollingItemViewCell" forIndexPath:indexPath];
   
    if (indexPath.item < self.items.count) { /** 防止数组越界 */
        
        id<XMNRollingItem> item = self.items[indexPath.item];
        [itemCell configItemViewWithData:item];
        if (self.loadRemoteBlock && !itemCell.imageView.image) { /** 使用自定义方式的加载网络图片 */
            self.loadRemoteBlock(itemCell.imageView, item, self.placeholder);
        }else if (!itemCell.imageView.image) {
            /** 增加设置默认图片处理逻辑 */
            itemCell.imageView.image = self.placeholder;
        }
    }
    return itemCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.shouldShowFooter && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        if ([self.footerView respondsToSelector:@selector(setRollingDirection:)]) {
            [(XMNRollingFooterView *)self.footerView setRollingDirection:self.rollingDirection];
        }
        return self.footerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    id<XMNRollingItem> item;
    if (indexPath.item < self.items.count) { /** 防止数组越界 */
        item = self.items[indexPath.item];
    }
    self.tapBlock ? self.tapBlock(item, indexPath.item) : nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.items || !self.items.count) {
        return;
    }
    self.pageControl.currentPage = self.currentIndex;
    
    if (!self.shouldShowFooter) {
        return;
    }
    
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset;
    if (self.rollingDirection == XMNRollingDirectionVertical) {
        footerDisplayOffset = (scrollView.contentOffset.y - (self.collectionViewLayout.itemSize.height * (self.items.count - 1)));
    }else {
        footerDisplayOffset = (scrollView.contentOffset.x - (self.collectionViewLayout.itemSize.width * (self.items.count - 1)));
    }
    
    if (footerDisplayOffset > 0) {
        // 开始出现footer
        if (footerDisplayOffset >= self.footerSpace) {
            if (lastOffset > 0) return;
            [self.footerView setState:XMNRollingFooterStateTrigger];
        } else {
            if (lastOffset < 0 || footerDisplayOffset >= self.footerSpace) return;
            [self.footerView setState:XMNRollingFooterStateIdle];
        }
        lastOffset = footerDisplayOffset - self.footerSpace;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!self.shouldShowFooter) return;
    
    CGFloat footerDisplayOffset;
    if (self.rollingDirection == XMNRollingDirectionVertical) {
        footerDisplayOffset = (scrollView.contentOffset.y - (self.collectionViewLayout.itemSize.height * (self.items.count - 1)));
    }else {
        footerDisplayOffset = (scrollView.contentOffset.x - (self.collectionViewLayout.itemSize.width * (self.items.count - 1)));
    }
    // 通知footer代理
    if (footerDisplayOffset > self.footerSpace && self.footerView.state == XMNRollingFooterStateTrigger) {
        self.footerTrigerBlock ? self.footerTrigerBlock() : nil;
    }
}

#pragma mark - Setter

- (void)setPageControl:(UIView<XMNRollingPageControl> *)pageControl {
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    if (pageControl) {
        [self addSubview:_pageControl = pageControl];
        self.pageControl.numberOfPages = self.items.count;
        self.pageControl.currentPage = self.currentIndex;
        [self updatePageControlConstraint];
    }
}

- (void)setPageControlAlignment:(XMNRollingPageControlAlignment)pageControlAlignment {
    
    _pageControlAlignment = pageControlAlignment;
    [self updatePageControlConstraint];
}


- (void)setItems:(NSArray<id<XMNRollingItem>> *)items {
    
    _items = [items copy];
    [self setup];
}

- (void)setPlaceholder:(UIImage *)placeholder {
    
    _placeholder = placeholder;
    if (self.emptyView) {
        self.emptyView.image = placeholder;
    }
}

- (void)setRollingDirection:(XMNRollingDirection)rollingDirection {
    
    if (_rollingDirection == rollingDirection) {
        return;
    }
    _rollingDirection = rollingDirection;
    self.collectionViewLayout.scrollDirection = (UICollectionViewScrollDirection)rollingDirection;
    self.collectionViewLayout.footerReferenceSize = self.rollingDirection == XMNRollingDirectionVertical ? CGSizeMake(self.collectionViewLayout.itemSize.width, self.footerSpace) : CGSizeMake(self.footerSpace, self.collectionViewLayout.itemSize.height);
}

- (void)setFooterSpace:(CGFloat)footerSpace {
    
    _footerSpace = footerSpace;
    self.collectionViewLayout.footerReferenceSize = self.rollingDirection == XMNRollingDirectionVertical ? CGSizeMake(self.collectionViewLayout.itemSize.width, footerSpace) : CGSizeMake(footerSpace, self.collectionViewLayout.itemSize.height);
}

- (void)setRollingMode:(XMNRollingMode)rollingMode {
    
    if (_rollingMode == rollingMode) {
        return;
    }
    _rollingMode = rollingMode;
    [self setup];
}

- (void)setDuration:(CGFloat)duration {
    
    if (_duration == duration) {
        return;
    }
    _duration = duration;
    [self setup];
}

- (void)setFooterView:(UICollectionReusableView<XMNRollingFooterView> *)footerView {
    
    _footerView = footerView;
    self.footerSpace = self.rollingDirection == XMNRollingDirectionHorizontal ? CGRectGetWidth(footerView.bounds) : CGRectGetHeight(footerView.bounds);
}

#pragma mark - Getter

- (UICollectionViewFlowLayout *)collectionViewLayout {
    
    return (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

- (NSInteger)currentIndex {
    
    if (CGRectGetWidth(self.bounds) <= 0 || CGRectGetHeight(self.bounds) <= 0) {
        return 0;
    }
    if (self.collectionViewLayout.itemSize.width <= 0 || self.collectionViewLayout.itemSize.height <= 0) {
        return 0;
    }
    
    if (!self.items || !self.items.count) {
        return 0;
    }
    
    int index = 0;
    
    switch (self.rollingDirection) {
        case XMNRollingDirectionVertical:
            index = (self.collectionView.contentOffset.y + self.collectionViewLayout.itemSize.height * .5f) / self.collectionViewLayout.itemSize.height;
            break;
        default:
            index = (self.collectionView.contentOffset.x + self.collectionViewLayout.itemSize.width * .5f) / self.collectionViewLayout.itemSize.width;
            break;
    }
    return MAX(0, index) % self.items.count;
}

- (NSInteger)currentSection {
    
    if (CGRectGetWidth(self.bounds) <= 0 || CGRectGetHeight(self.bounds) <= 0) {
        return 0;
    }
    if (self.collectionViewLayout.itemSize.width <= 0 || self.collectionViewLayout.itemSize.height <= 0) {
        return 0;
    }
    
    if (!self.items || !self.items.count) {
        return 0;
    }
    
    int index = 0;
    switch (self.rollingDirection) {
        case XMNRollingDirectionVertical:
            index = (self.collectionView.contentOffset.y + self.collectionViewLayout.itemSize.height * .5f) / self.collectionViewLayout.itemSize.height;
            break;
        default:
            index = (self.collectionView.contentOffset.x + self.collectionViewLayout.itemSize.width * .5f) / self.collectionViewLayout.itemSize.width;
            break;
    }
    return MAX(0, index) / self.items.count;
}


- (UICollectionReusableView<XMNRollingFooterView> *)footerView {
    
    if (!_footerView) {
        _footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XMNRollingFooterView" forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [(XMNRollingFooterView *)_footerView setRollingDirection:self.rollingDirection];
        self.footerSpace = 64.f;
    }
    return _footerView;
}

- (BOOL)isReverseRolling {
    
    return _reverseRolling;
}

- (BOOL)shouldAuto {
    
    return (self.rollingMode & XMNRollingModeAuto) == XMNRollingModeAuto && self.items && self.items.count >= 2;
}

- (BOOL)shouldReverse {
    
    return ((self.rollingMode & XMNRollingModeReverse) == XMNRollingModeReverse && !self.shouldInfiniteLoop) && self.shouldAuto;
}

- (BOOL)shouldShowFooter {
    
    return ((self.rollingMode & XMNRollingModeFooter) == XMNRollingModeFooter && !self.shouldInfiniteLoop);
}

- (BOOL)shouldInfiniteLoop {
    
    return (self.rollingMode & XMNRollingModeInfiniteLoop) == XMNRollingModeInfiniteLoop && self.items && self.items.count >= 2;
}

@end
