//
//  GameplayDelegate.h
//  project2
//
//  Created by Merrill Lutsky on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef project2_GameplayDelegate_h
#define project2_GameplayDelegate_h

@protocol GameplayDelegate <NSObject> 

@property (strong, nonatomic) NSMutableArray *guesses;
@property (readwrite, assign) int guessCount;
@property (strong, nonatomic) NSString *displayWordString;
@property (readwrite, assign) int hiddenLetterCount;
@property (strong, nonatomic) NSString *word;

- (void)startNewGame:(int)mistakeNumber :(int)wordSize :(NSMutableArray *)plistData;
- (int)updateGame:(NSString *)guess;

@end



#endif
