//
//  ViewController.m
//  IJKMoviePlayerSample
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import "ViewController.h"
#import "IJKMoviePlayerView.h"

@interface ViewController ()

@property (nonatomic, strong) IJKMoviePlayerView * moviePlayerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"IJKPlayer";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
//    NSURL *assetURL = [NSURL URLWithString:@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"];
    
    NSURL *assetURL =  [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8"];

    
    CGFloat width = self.view.bounds.size.width;
    if (width > self.view.bounds.size.height) {
        width = self.view.bounds.size.height;
    }
    CGFloat height = width*2.0/3.0;

    self.moviePlayerView = [[IJKMoviePlayerView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.moviePlayerView.center = self.view.center;
    self.moviePlayerView.player.shouldAutoPlay = YES;
    self.moviePlayerView.assetURL = assetURL;
    [self.view addSubview:self.moviePlayerView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.bounds.size.width;
    if (width > self.view.bounds.size.height) {
        width = self.view.bounds.size.height;
    }
    CGFloat height = width*2.0/3.0;

    self.moviePlayerView.frame = CGRectMake(0, 0, width, height);
    self.moviePlayerView.center = self.view.center;
}

@end
