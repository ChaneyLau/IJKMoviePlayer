//
//  IJKMoviePlayerView.h
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKMoviePlayer.h"
#import "UIView+IJKFrame.h"

@interface IJKMoviePlayerView : UIView

@property (nonatomic, strong, readonly) IJKMoviePlayer * player;
@property (nonatomic, strong) NSURL *assetURL;

@end
