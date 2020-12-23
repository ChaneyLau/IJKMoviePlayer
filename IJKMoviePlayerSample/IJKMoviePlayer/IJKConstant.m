//
//  IJKConstant.m
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import "IJKConstant.h"

void IJK_AddObserver(id observer,SEL aSelector,NSNotificationName aName,id anObject)
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

void IJK_RemoveObserver(id observer,NSNotificationName aName,id anObject)
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}

@implementation IJKConstant

@end
