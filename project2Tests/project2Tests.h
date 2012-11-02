//
//  project2Tests.h
//  project2Tests
//
//  Created by Merrill Lutsky on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "GameplayDelegate.h"
#import "GoodGameplay.h"
#import "EvilGameplay.h"
#import "UpdateGameEnums.h"

@interface project2Tests : SenTestCase {
@private
    id<GameplayDelegate> good;
    id<GameplayDelegate> evil;
    NSMutableArray *plistData;
}


@end
