//
//  IJKMovieSliderView.h
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IJKMovieSliderButton : UIButton

@end

@protocol IJKMovieSliderViewDelegate;
@interface IJKMovieSliderView : UIView

@property (nonatomic, assign) id<IJKMovieSliderViewDelegate> delegate;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) float bufferValue;
@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, assign) BOOL isDragging;

@end

@protocol IJKMovieSliderViewDelegate <NSObject>

@optional

- (void)sliderTouchBegan:(float)value;
- (void)sliderValueChanged:(float)value;
- (void)sliderTouchEnded:(float)value;
- (void)sliderTapped:(float)value;

@end
