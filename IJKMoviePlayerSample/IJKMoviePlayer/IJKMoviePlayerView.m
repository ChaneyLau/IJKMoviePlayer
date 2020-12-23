//
//  IJKMoviePlayerView.m
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "IJKMoviePlayerView.h"
#import "IJKMovieSliderView.h"

@interface IJKMoviePlayerView () <IJKPlayerProtocol,IJKMovieSliderViewDelegate>

@property (nonatomic, strong) IJKMoviePlayer * player;

@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) IJKMovieSliderView *slider;
@property (nonatomic, strong) UILabel *totalTimeLabel;

@end

@implementation IJKMoviePlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat bottom_h = 36;
    CGFloat bottom_w = self.bounds.size.width - 20;
    CGFloat bottom_x = (self.bounds.size.width - bottom_w)/2.0;
    CGFloat bottom_y = self.bounds.size.height - bottom_h - 10;
    CGFloat margin = 5;
    CGFloat lab_w = 60;
    self.bottomToolView.frame = CGRectMake(bottom_x, bottom_y, bottom_w, bottom_h);
    self.playBtn.frame = CGRectMake(5, 0, bottom_h, bottom_h);
    self.currentTimeLabel.frame = CGRectMake(self.playBtn.right-5, 0, lab_w, bottom_h);
    self.totalTimeLabel.frame = CGRectMake(bottom_w - lab_w, 0, lab_w, bottom_h);
    
    CGFloat slider_x = self.currentTimeLabel.right + margin;
    CGFloat slider_w = self.totalTimeLabel.left - slider_x - margin;
    CGFloat slider_h = 30;

    self.slider.frame = CGRectMake(slider_x, 0, slider_w, slider_h);
    self.slider.centerY = self.currentTimeLabel.centerY;
}

- (void)setAssetURL:(NSURL *)assetURL
{
    _assetURL = assetURL;
    if (self.player.view) {
        [self.player.view removeFromSuperview];
    }
    self.player.assetURL = assetURL;
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.view.backgroundColor = [UIColor blackColor];
    [self addSubview:self.player.view];
    [self sendSubviewToBack:self.player.view];
}

#pragma mark - IJKPlayerProtocol
- (void)IJKPlayerPlayTimeChanged:(IJKMoviePlayer *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    if (!self.slider.isDragging) {
        self.currentTimeLabel.text = [self convertTimeSecond:currentTime];
        self.totalTimeLabel.text = [self convertTimeSecond:totalTime];
        if (self.player.totalTime > 0) {
            self.slider.value = self.player.currentTime/self.player.totalTime;
        } else {
            self.slider.value = 0;
        }
    }
}

- (void)IJKPlayerBufferTimeChanged:(IJKMoviePlayer *)player bufferTime:(NSTimeInterval)bufferTime
{
    if (self.player.totalTime > 0) {
        self.slider.bufferValue = bufferTime/self.player.totalTime;
    } else {
        self.slider.bufferValue = 0;
    }
}

- (void)IJKPlayerPlayStateChanged:(IJKMoviePlayer *)player playState:(IJKMPMoviePlaybackState)playbackState
{
    if (playbackState == IJKMPMoviePlaybackStatePlaying) {
        self.playBtn.selected = YES;
    } else if (playbackState == IJKMPMoviePlaybackStatePaused || playbackState == IJKMPMoviePlaybackStateStopped)  {
        self.playBtn.selected = NO;
    }
}

- (void)IJKPlayerDidEnd:(IJKMoviePlayer *)player
{
    self.slider.value = 0;
    self.slider.bufferValue = 0;
    self.currentTimeLabel.text = @"0:00:00";
    [self.player replay];
    [self.player pause];
}

#pragma mark - ZFSliderViewDelegate
- (void)sliderTouchBegan:(float)value
{
    self.slider.isDragging = YES;
}

- (void)sliderTouchEnded:(float)value
{
    self.slider.isDragging = NO;
    if (self.player.totalTime > 0) {
        [self.player seekToTime:self.player.totalTime * value]; 
    } else {
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value
{
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isDragging = YES;
    self.currentTimeLabel.text = [self convertTimeSecond:self.player.totalTime*value];
}

- (void)sliderTapped:(float)value
{
    [self sliderTouchEnded:value];
    self.currentTimeLabel.text = [self convertTimeSecond:self.player.totalTime*value];
}

- (NSString *)convertTimeSecond:(NSInteger)timeSecond
{
    NSString *theLastTime = nil;
    long second = timeSecond;
    if (timeSecond < 60) {
        theLastTime = [NSString stringWithFormat:@"0:00:%02zd", second];
    } else if(timeSecond >= 60 && timeSecond < 3600){
        theLastTime = [NSString stringWithFormat:@"0:%02zd:%02zd", second/60, second%60];
    } else if(timeSecond >= 3600){
        theLastTime = [NSString stringWithFormat:@"%zd:%02zd:%02zd", second/3600, second%3600/60, second%60];
    }
    return theLastTime;
}

#pragma mark - Play | Pause
- (void)onPlayOrPause:(UIButton *)sender
{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

#pragma mark - lazyload
- (IJKMoviePlayer *)player
{
    if (!_player) {
        _player = [[IJKMoviePlayer alloc] init];
        _player.protocol = self;
        _player.shouldAutoPlay = NO;
    }
    return _player;
}

- (UIView *)bottomToolView
{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        _bottomToolView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _bottomToolView.layer.cornerRadius = 6.0;
        _bottomToolView.layer.masksToBounds = YES;
    }
    return _bottomToolView;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
        [_playBtn setImage:[UIImage imageNamed:@"ijk_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"ijk_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(onPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"0:00:00";
    }
    return _currentTimeLabel;
}

- (IJKMovieSliderView *)slider
{
    if (!_slider) {
        _slider = [[IJKMovieSliderView alloc] init];
        _slider.delegate = self;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"0:00:00";
    }
    return _totalTimeLabel;
}

@end
