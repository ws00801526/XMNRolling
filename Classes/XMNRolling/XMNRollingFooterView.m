//
//  XMNRollingFooterView.m
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/12/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNRollingFooterView.h"

@interface XMNRollingFooterView ()

@property (weak, nonatomic)   UIImageView *arrowImageView;
@property (weak, nonatomic)   UILabel *tipsLabel;

@end

@implementation XMNRollingFooterView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
    }
    return self;
}

#pragma mark - Override Method

- (void)updateConstraints {
    
    [super updateConstraints];
    CGFloat offset = .0f;
    if (self.rollingDirection == XMNRollingDirectionVertical) {
        
        offset = - CGRectGetWidth(self.bounds);
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:8.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:-150.f]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.arrowImageView attribute:NSLayoutAttributeBottom multiplier:1.f constant:8.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:.0f]];

    }else {
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:8.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipsLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.arrowImageView attribute:NSLayoutAttributeRight multiplier:1.f constant:8.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.f constant:14.f]];
    }
    
}

- (void)updateViewFrame {
    
    if (self.rollingDirection == XMNRollingDirectionVertical) {
        
        CGFloat width = CGRectGetWidth(self.bounds);
        self.arrowImageView.frame = CGRectMake(width/2 - 7, 8, 14, 14);
        self.tipsLabel.frame = CGRectMake(0, 25, width, 14);
    }else {
        
        CGFloat height = CGRectGetHeight(self.bounds);
        self.arrowImageView.frame = CGRectMake(8, height/2 - 7, 14, 14);
        self.tipsLabel.frame = CGRectMake(25, 0, 14, height);
    }
}

#pragma mark - Method

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle bundleWithIdentifier:@"com.XMFraker.XMNBanner"] ? : [NSBundle mainBundle] pathForResource:@"rolling_footer_view_arrow@2x" ofType:@"png"]]];
    imageView.transform = CGAffineTransformMakeRotation(0);
    [self addSubview:self.arrowImageView = imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:115/255.f green:115/255.f blue:115/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:13.f];
    label.numberOfLines = 0;
    label.text = (self.state == XMNRollingFooterStateIdle ? @"拖动查看详情" : @"松开查看详情");
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipsLabel = label];
    

    [self updateViewFrame];
}

#pragma mark - Setter

- (void)setState:(XMNRollingFooterState)state {
    
    if (_state == state) {
        return;
    }
    
    _state = state;
    self.tipsLabel.text = (state == XMNRollingFooterStateIdle ? @"拖动查看详情" : @"松开查看详情");
    switch (state) {
        case XMNRollingFooterStateTrigger:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(self.rollingDirection == XMNRollingDirectionHorizontal ? M_PI : -M_PI_2);
            }];
        }
            break;
        default:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(self.rollingDirection == XMNRollingDirectionHorizontal ? 0 : M_PI_2);
            }];
        }
            break;
    }
}

- (void)setRollingDirection:(XMNRollingDirection)rollingDirection {
    
    _rollingDirection = rollingDirection;
    self.arrowImageView.transform = CGAffineTransformMakeRotation(self.rollingDirection == XMNRollingDirectionHorizontal ? 0 : M_PI_2);
    [self updateViewFrame];

}

@end
