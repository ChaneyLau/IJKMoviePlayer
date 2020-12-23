//
//  UIView+IJKFrame.m
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import "UIView+IJKFrame.h"

@implementation UIView (IJKFrame)

- (CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width
{
    CGRect newFrame     = self.frame;
    newFrame.size.width = width;
    self.frame          = newFrame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height
{
    CGRect newFrame      = self.frame;
    newFrame.size.height = height;
    self.frame           = newFrame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect newFrame   = self.frame;
    newFrame.origin.y = top;
    self.frame        = newFrame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect newFrame   = self.frame;
    newFrame.origin.y = bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect newFrame   = self.frame;
    newFrame.origin.x = left;
    self.frame        = newFrame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect newFrame   = self.frame;
    newFrame.origin.x = right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint newCenter = self.center;
    newCenter.x       = centerX;
    self.center       = newCenter;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint newCenter = self.center;
    newCenter.y       = centerY;
    self.center       = newCenter;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame      = newFrame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect newFrame = self.frame;
    newFrame.size   = size;
    self.frame      = newFrame;
}


@end
