//
//  EvilGameplay.m
//  project2
//
//  Created by Merrill Lutsky on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateGameEnums.h"
#import "EvilGameplay.h"

@implementation EvilGameplay
@synthesize guesses = _guesses;
@synthesize guessCount = _guessCount;
@synthesize possibleWords = _possibleWords;
@synthesize displayWordString = _displayWordString;
@synthesize hiddenLetterCount = _hiddenLetterCount;
@synthesize word = _word;

- (int)updateGame:(NSString *)guess;
{
    NSLog(@"updateGame in EvilGameplay!");
    
    // check if letter has been guessed already
    if ([self.guesses containsObject:(guess)]) {
        NSLog(@"already guessed %@", guess);
        return ALREADY_GUESSED;
    // else add letter to guess history
    } else {
        [self.guesses addObject:guess];
        NSMutableDictionary *equivClasses = [[NSMutableDictionary alloc] init];      
        
        // sort remaining possible words into equivalence classes
        for (NSString *possibleWord in self.possibleWords) {
            NSString *key = @"";
            
            // iterate through each character of the word and construct a key based on which indices contain the letter, e.g. searching DEER for E would yield a key @"_1_2"
            for (int i = 0; i < possibleWord.length; i++) {
                if ([[possibleWord substringWithRange:(NSMakeRange(i, 1))] caseInsensitiveCompare:guess] == NSOrderedSame) {
                    key = [NSString stringWithFormat:@"%@_%d", key, i];
                }
            }
            
            // push word into equivalence class corresponding with constructed key if there was one already; create and then push if there wasn't
            if([equivClasses objectForKey:key]) {
                NSLog(@"exists");
            } else { 
                NSLog(@"doesn't exist yet");
                [equivClasses setValue:[[NSMutableArray alloc] init] forKey:key];
            }
            [[equivClasses objectForKey:(key)] addObject:possibleWord];
        }
        
        // update new remaining possible words to become the largest equivalence class
        int largestClassCount = 0;
        for (NSString *key in equivClasses) {
            int count = [[equivClasses objectForKey:key] count];
            if (count > largestClassCount) {
                largestClassCount = count;
                NSLog(@"new! largest class count is now: %d", count);
            }
        }
        
        // get the equivalence classes each of whose size is the largest size
        NSMutableArray *largestClassKeys = [[NSMutableArray alloc] init];
        for (NSString *key in equivClasses) {
            int count = [[equivClasses objectForKey:key] count];
            if (count == largestClassCount) {
                [largestClassKeys addObject:key];             
            }
        }
        NSLog(@"largestClassKeys: %@", largestClassKeys);
        
        // "randomly" select a equivalence class from those whose size are all the largest size. If we can avoid revealing characters, do so!
        NSString *chosenKey;

        if ([largestClassKeys containsObject:@""]) {
            chosenKey = @"";
        } else {
            int randomKey = arc4random_uniform([largestClassKeys count]);   
            chosenKey = [largestClassKeys objectAtIndex:(randomKey)];
        }
        NSLog(@"picked key: %@", chosenKey);

        
        // update possibleWords to be the chosen equivalence class
        self.possibleWords = [equivClasses objectForKey:chosenKey];
        NSLog(@"possible words now: %@", self.possibleWords);
        
        // set letters to reveal
        NSArray *revealTheseIndices = [chosenKey componentsSeparatedByString: @"_"];
        NSLog(@"revealTheseIndices: %@", revealTheseIndices);

        // if "" is the only index to reveal, we know nothing is to be revealed + the user loses a guess
        if ([revealTheseIndices count] == 1) {
            self.guessCount--;
            if (self.guessCount <= 0) {
                return LOSE;
            }
        // set the letter(s) to be revealed
        } else {
            for (NSString *index in revealTheseIndices) {
                if (![index isEqualToString:@""]) {
                    NSLog(@"index: %@", index);
                    self.displayWordString = [self.displayWordString stringByReplacingCharactersInRange:(NSMakeRange([index intValue], 1)) withString:guess];
                    self.hiddenLetterCount--;
                    if (self.hiddenLetterCount <= 0) {
                        self.word = self.displayWordString;
                        return WIN;
                    }
                }
            }
        }
        
        NSLog(@"guesses left: %d", self.guessCount);
        NSLog(@"possible words left: %@", self.possibleWords);
        return CONTINUE;
    }
}

- (void)startNewGame:(int)mistakeNumber :(int)wordSize :(NSMutableArray *)plistData;
{
    // declare variables for maximum and minimum values of slider
    int max = 0;
    int min = wordSize;
    
    // initialize variables for guesses, guessCount, word string to display, and count of hidden letters
    self.guesses = [[NSMutableArray alloc] init];
    self.guessCount = mistakeNumber;
    self.displayWordString = [@"" stringByPaddingToLength:(wordSize) withString:@"-" startingAtIndex:0];
    self.hiddenLetterCount = wordSize;
    self.possibleWords = [[NSMutableArray alloc] initWithObjects:nil];
    
    // iterate through plist and load words, as well as noting max and min lengths to define the word length slider parameters
    for (NSString *object in plistData) {
        if (object.length == wordSize) {
            [self.possibleWords addObject:object];
        }
        if (object.length > max) {
            max = object.length;
        }
        if (object.length < min) {
            min = object.length;
        }
        
    }
    NSLog(@"count: %d", [self.possibleWords count]);

    
    // update NSUserDefaults to contain the max and min values
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%d", max] forKey:@"sliderMax"];
    [userDefaults setValue:[NSString stringWithFormat:@"%d", min] forKey:@"sliderMin"];
    [userDefaults synchronize];
    
}

@end

