//
//  UIView+IJKFrame.h
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IJKFrame)

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;


@end
