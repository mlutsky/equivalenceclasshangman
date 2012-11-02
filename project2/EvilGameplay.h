//
//  EvilGameplay.h
//  project2
//
//  Created by Merrill Lutsky on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameplayDelegate.h"

@interface EvilGameplay : NSObject <GameplayDelegate>

@property (strong, nonatomic, readwrite) NSMutableArray *possibleWords;


@end
