//
//  IJKMovieSliderView.m
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import "IJKMovieSliderView.h"
#import "UIView+IJKFrame.h"

/// 滑块的大小
static const CGFloat kSliderBtnWH = 10.0;
/// 进度的高度
static const CGFloat kProgressH = 4.0;

@implementation IJKMovieSliderButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -20, -20);  // 扩大点击区域
    return CGRectContainsPoint(bounds, point);
}

@end

@interface IJKMovieSliderView ()

@property (nonatomic, strong) UIView *bgProgressView; // 进度背景
@property (nonatomic, strong) UIView *bufferProgressView; // 缓存进度
@property (nonatomic, strong) UIView *sliderProgressView; // 滑动进度
@property (nonatomic, strong) IJKMovieSliderButton *sliderBtn; // 滑块

@end

@implementation IJKMovieSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (isnan(self.value) || isnan(self.bufferValue)) return;

    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_w = min_view_w;
    min_y = 0;
    min_h = kProgressH;
    self.bgProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = kSliderBtnWH;
    min_h = kSliderBtnWH;
    self.sliderBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.sliderBtn.centerX = self.bgProgressView.width * self.value;
    
    min_x = 0;
    min_y = 0;
    if (self.sliderBtn.hidden) {
        min_w = self.bgProgressView.width * self.value;
    } else {
        min_w = self.sliderBtn.centerX;
    }
    min_h = kProgressH;
    self.sliderProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.bgProgressView.width * self.bufferValue;
    min_h = kProgressH;
    self.bufferProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgProgressView.centerY     = min_view_h * 0.5;
    self.bufferProgressView.centerY = min_view_h * 0.5;
    self.sliderProgressView.centerY = min_view_h * 0.5;
    self.sliderBtn.centerY          = min_view_h * 0.5;
    
    self.bgProgressView.layer.cornerRadius      = 2.0;
    self.bufferProgressView.layer.cornerRadius  = 2.0;
    self.sliderProgressView.layer.cornerRadius  = 2.0;
    self.bgProgressView.layer.masksToBounds     = YES;
    self.bufferProgressView.layer.masksToBounds = YES;
    self.sliderProgressView.layer.masksToBounds = YES;
}

- (void)addSubViews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    /// 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
    /// 添加滑动手势
    UIPanGestureRecognizer *sliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:sliderGesture];
}

- (void)setValue:(float)value
{
    if (isnan(value)) return;
    value = MIN(1.0, value);
    _value = value;
    if (self.sliderBtn.hidden) {
        self.sliderProgressView.width = self.bgProgressView.width * value;
    } else {
        self.sliderBtn.centerX = self.bgProgressView.width * value;
        self.sliderProgressView.width = self.sliderBtn.centerX;
    }
}

- (void)setBufferValue:(float)bufferValue
{
    if (isnan(bufferValue)) return;
    bufferValue = MIN(1.0, bufferValue);
    _bufferValue = bufferValue;
    self.bufferProgressView.width = self.bgProgressView.width * bufferValue;
}

#pragma mark - User Action
- (void)onTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.bgProgressView];
    CGFloat value = (point.x - self.sliderBtn.width * 0.5) * 1.0 / self.bgProgressView.width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}

- (void)onPan:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan: {
            [self sliderTouchBegin:self.sliderBtn];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self sliderDragMoving:self.sliderBtn point:[gesture locationInView:self.bgProgressView]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self sliderTouchEnd:self.sliderBtn];
            break;
        }
        default:
            break;
    }
}

- (void)sliderTouchBegin:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self.value];
    }
}

- (void)sliderTouchEnd:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self.value];
    }
}

- (void)sliderDragMoving:(UIButton *)sender point:(CGPoint)touchPoint
{
    // 点击的位置
    CGPoint point = touchPoint;
    // 获取进度值 由于btn是从 0-(self.width - btn.width)
    CGFloat value = (point.x - sender.width * 0.5) / self.bgProgressView.width;
    // value的值需在0-1之间
    value = value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
    if (self.value == value) return;
    self.isForward = self.value < value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
}

#pragma mark - lazyload
- (UIView *)bgProgressView
{
    if (!_bgProgressView) {
        _bgProgressView = [UIView new];
        _bgProgressView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}

- (UIView *)bufferProgressView
{
    if (!_bufferProgressView) {
        _bufferProgressView = [UIView new];
        _bufferProgressView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _bufferProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bufferProgressView.clipsToBounds = YES;
    }
    return _bufferProgressView;
}

- (UIView *)sliderProgressView
{
    if (!_sliderProgressView) {
        _sliderProgressView = [UIView new];
        _sliderProgressView.backgroundColor = [UIColor whiteColor];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}

- (IJKMovieSliderButton *)sliderBtn
{
    if (!_sliderBtn) {
        _sliderBtn = [IJKMovieSliderButton buttonWithType:UIButtonTypeCustom];
        [_sliderBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _sliderBtn;
}

@end
