//
//  IJKPlayer.h
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "IJKConstant.h"

@protocol IJKPlayerProtocol;
@interface IJKMoviePlayer : NSObject

@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, assign, readonly) BOOL isPreparedToPlay;
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, assign, readonly) NSTimeInterval bufferTime;
@property (nonatomic, assign, readonly) IJKMPMoviePlaybackState playState;
@property (nonatomic, assign, readonly) IJKMPMovieLoadState loadState;

@property (nonatomic, assign) id<IJKPlayerProtocol> protocol;
@property (nonatomic, strong) NSURL *assetURL;
@property (nonatomic, assign) float rate;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) BOOL shouldAutoPlay;
@property (nonatomic, assign) IJKMPMovieScalingMode scalingMode;

- (void)prepareToPlay;
- (void)play;
- (void)replay;
- (void)pause;
- (void)stop;
- (void)setPauseInBackground:(BOOL)pause;
- (void)seekToTime:(NSTimeInterval)seekTime;

@end
 

@protocol IJKPlayerProtocol <NSObject>

@optional
- (void)IJKPlayerPlayTimeChanged:(IJKMoviePlayer *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
- (void)IJKPlayerBufferTimeChanged:(IJKMoviePlayer *)player bufferTime:(NSTimeInterval)bufferTime;
- (void)IJKPlayerPlayStateChanged:(IJKMoviePlayer *)player playState:(IJKMPMoviePlaybackState)playbackState;
- (void)IJKPlayerLoadStateChanged:(IJKMoviePlayer *)player loadState:(IJKMPMovieLoadState)loadState;
- (void)IJKPlayerPresentationSizeChanged:(IJKMoviePlayer *)player presentationSize:(CGSize)size;

- (void)IJKPlayerPrepareToPlay:(IJKMoviePlayer *)player;
- (void)IJKPlayerReadyToPlay:(IJKMoviePlayer *)player;
- (void)IJKPlayerDidEnd:(IJKMoviePlayer *)player;
- (void)IJKPlayerPlayFailed:(id)error;

@end
