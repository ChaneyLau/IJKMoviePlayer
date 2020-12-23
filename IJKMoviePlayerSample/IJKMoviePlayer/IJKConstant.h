//
//  IJKConstant.h
//  IJKMoviePlayer
//
//  Created by chaney on 2020/12/22.
//  Copyright © 2020 Chaney Lau. All rights reserved.
//

#import <Foundation/Foundation.h>

void IJK_AddObserver(id observer,SEL aSelector,NSNotificationName aName,id anObject);

void IJK_RemoveObserver(id observer,NSNotificationName aName,id anObject);


@interface IJKConstant : NSObject

@end

