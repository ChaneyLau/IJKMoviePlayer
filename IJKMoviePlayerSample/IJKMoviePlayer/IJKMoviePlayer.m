//
//  IJKMoviePlayer.m
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import "IJKMoviePlayer.h"

@interface IJKMoviePlayer ()

@property (nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer;
@property (nonatomic, strong) UIView *view;

@property (nonatomic, assign) BOOL isPreparedToPlay;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, assign) NSTimeInterval bufferTime;
@property (nonatomic, assign) IJKMPMoviePlaybackState playState;
@property (nonatomic, assign) IJKMPMovieLoadState loadState;
@property (nonatomic, assign) NSTimeInterval seekTime;

@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, assign) CGFloat lastVolume;
@property (nonatomic, assign) BOOL isReadyToPlay;

@end

@implementation IJKMoviePlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scalingMode = IJKMPMovieScalingModeAspectFit;
        _shouldAutoPlay = YES;
        _rate = 1.0;
        
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_VERBOSE];
        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:NO];
    }
    return self;
}

#pragma mark - init
- (void)initPlayer
{
    IJKFFOptions * options = [IJKFFOptions optionsByDefault];
    [options setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
    [options setOptionIntValue:1 forKey:@"dns_cache_clear" ofCategory:kIJKFFOptionCategoryFormat];
    
    self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.assetURL withOptions:options];
    self.ijkPlayer.shouldAutoplay = self.shouldAutoPlay;
    self.ijkPlayer.scalingMode = self.scalingMode;
    self.ijkPlayer.playbackRate = self.rate;
    [self.ijkPlayer prepareToPlay];
    self.view = self.ijkPlayer.view;
    // KVC
    [self addObserver];
}

- (void)addObserver
{
    IJK_AddObserver(self, @selector(loadStateDidChange:), IJKMPMoviePlayerLoadStateDidChangeNotification, self.ijkPlayer);
    IJK_AddObserver(self, @selector(preparedToPlayDidChange:), IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification, self.ijkPlayer);
    IJK_AddObserver(self, @selector(playBackStateDidChange:), IJKMPMoviePlayerPlaybackStateDidChangeNotification, self.ijkPlayer);
    IJK_AddObserver(self, @selector(playBackDidFinish:), IJKMPMoviePlayerPlaybackDidFinishNotification, self.ijkPlayer);
    IJK_AddObserver(self, @selector(sizeAvailableChange:), IJKMPMovieNaturalSizeAvailableNotification, self.ijkPlayer);
}

- (void)removeObserver
{
    IJK_RemoveObserver(self, IJKMPMoviePlayerLoadStateDidChangeNotification, self.ijkPlayer);
    IJK_RemoveObserver(self, IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification, self.ijkPlayer);
    IJK_RemoveObserver(self, IJKMPMoviePlayerPlaybackStateDidChangeNotification, self.ijkPlayer);
    IJK_RemoveObserver(self, IJKMPMoviePlayerPlaybackDidFinishNotification, self.ijkPlayer);
    IJK_RemoveObserver(self, IJKMPMovieNaturalSizeAvailableNotification, self.ijkPlayer);
}

#pragma mark - Public
- (void)prepareToPlay
{
    if (!_assetURL) {
        return;
    }
    _isPreparedToPlay = YES;
    [self initPlayer];
    if (self.shouldAutoPlay) {
        [self play];
    }
    self.loadState = IJKMPMovieLoadStateUnknown;
    if ([self.protocol respondsToSelector:@selector(IJKPlayerPrepareToPlay:)]) {
        [self.protocol IJKPlayerPrepareToPlay:self];
    }
}

- (void)play
{
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.ijkPlayer play];
        self.isPlaying = YES;
        self.playState = IJKMPMoviePlaybackStatePlaying;
    }
}

- (void)replay
{
    [self seekToTime:0];
    if (self.shouldAutoPlay) {
        [self.ijkPlayer play];
    }
}

- (void)pause
{
    [self.ijkPlayer pause];
    self.isPlaying = NO;
    self.playState = IJKMPMoviePlaybackStatePaused;
}

- (void)stop
{
    [self removeObserver];
    [self.ijkPlayer shutdown];
    self.ijkPlayer = nil;
    [self.playTimer invalidate];
    self.playTimer = nil;
    self.isPreparedToPlay = NO;
    self.isReadyToPlay = NO;
    self.isPlaying = NO;
    self.currentTime = 0;
    self.totalTime = 0;
    self.bufferTime = 0;
    self.playState = IJKMPMoviePlaybackStateStopped;
    self.assetURL = nil;
}

- (void)setPauseInBackground:(BOOL)pause
{
    [self.ijkPlayer setPauseInBackground:pause];
}

- (void)seekToTime:(NSTimeInterval)seekTime
{
    self.seekTime = seekTime;
    if (self.ijkPlayer.duration > 0) {
        self.ijkPlayer.currentPlaybackTime = seekTime;
    }
}

#pragma mark - Timer
- (void)playTimeUpdate
{
    if (self.ijkPlayer.currentPlaybackTime > 0 && !self.isReadyToPlay) {
        self.isReadyToPlay = YES;
        self.loadState = IJKMPMovieLoadStatePlaythroughOK;
    }
    // 缓存进度
    self.bufferTime = self.ijkPlayer.playableDuration;
    if ([self.protocol respondsToSelector:@selector(IJKPlayerBufferTimeChanged:bufferTime:)]) {
        [self.protocol IJKPlayerBufferTimeChanged:self bufferTime:self.bufferTime];
    }
    // 播放进度
    self.currentTime = self.ijkPlayer.currentPlaybackTime > 0 ? self.ijkPlayer.currentPlaybackTime : 0;
    self.totalTime = self.ijkPlayer.duration;
    if ([self.protocol respondsToSelector:@selector(IJKPlayerPlayTimeChanged:currentTime:totalTime:)]) {
        [self.protocol IJKPlayerPlayTimeChanged:self currentTime:self.currentTime totalTime:self.totalTime];
    }
}

#pragma mark - Setter
- (void)setAssetURL:(NSURL *)assetURL
{
    if (self.ijkPlayer) {
        [self stop];
    }
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate
{
    _rate = rate;
    self.ijkPlayer.playbackRate = rate;
}

- (void)setMuted:(BOOL)muted
{
    _muted = muted;
    if (muted) {
        self.lastVolume = self.ijkPlayer.playbackVolume;
        self.ijkPlayer.playbackVolume = 0;
    } else {
        if (self.lastVolume == 0) {
            self.lastVolume = self.ijkPlayer.playbackVolume;
        }
        self.ijkPlayer.playbackVolume = self.lastVolume;
    }
}

- (void)setVolume:(float)volume
{
    _volume = MIN(MAX(0, volume), 1);
    self.ijkPlayer.playbackVolume = volume;
}

- (void)setScalingMode:(IJKMPMovieScalingMode)scalingMode
{
    _scalingMode = scalingMode;
    self.ijkPlayer.scalingMode = scalingMode;
}

- (void)setPlayState:(IJKMPMoviePlaybackState)playState
{
    _playState = playState;
    if ([self.protocol respondsToSelector:@selector(IJKPlayerPlayStateChanged:playState:)]) {
        [self.protocol IJKPlayerPlayStateChanged:self playState:self.playState];
    }
}

- (void)setLoadState:(IJKMPMovieLoadState)loadState
{
    _loadState = loadState;
    if ([self.protocol respondsToSelector:@selector(IJKPlayerLoadStateChanged:loadState:)]) {
        [self.protocol IJKPlayerLoadStateChanged:self loadState:self.loadState];
    }
}

#pragma mark - KVC
- (void)loadStateDidChange:(NSNotification*)notification
{
    self.loadState = self.ijkPlayer.loadState;
}

- (void)preparedToPlayDidChange:(NSNotification *)notification
{
    if (!self.playTimer) {
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
    }
    if (self.shouldAutoPlay) {
        [self play];
    }
    if ([self.protocol respondsToSelector:@selector(IJKPlayerReadyToPlay:)]) {
        [self.protocol IJKPlayerReadyToPlay:self];
    }
}

- (void)playBackStateDidChange:(NSNotification *)notification
{
    self.playState = (IJKMPMoviePlaybackState)self.ijkPlayer.playbackState;
}

- (void)playBackDidFinish:(NSNotification *)notification
{
    NSInteger reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (reason == IJKMPMovieFinishReasonPlaybackEnded) {
        self.playState = IJKMPMoviePlaybackStateStopped;
        if ([self.protocol respondsToSelector:@selector(IJKPlayerDidEnd:)]) {
            [self.protocol IJKPlayerDidEnd:self];
        }
    } else if (reason == IJKMPMovieFinishReasonPlaybackError) {
        self.playState = IJKMPMoviePlaybackStateInterrupted;
        if ([self.protocol respondsToSelector:@selector(IJKPlayerPlayFailed:)]) {
            [self.protocol IJKPlayerPlayFailed:self];
        }
    } else { }
}

- (void)sizeAvailableChange:(NSNotification *)notification
{
    if ([self.protocol respondsToSelector:@selector(IJKPlayerPresentationSizeChanged:presentationSize:)]) {
        [self.protocol IJKPlayerPresentationSizeChanged:self presentationSize:self.ijkPlayer.naturalSize];
    }
}

@end
