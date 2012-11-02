//
//  project2Tests.m
//  project2Tests
//
//  Created by Merrill Lutsky on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "project2Tests.h"

@implementation project2Tests

- (void)setUp
{
    [super setUp];
    
    good = [[GoodGameplay alloc] init];
    evil = [[EvilGameplay alloc] init];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"wordsA.plist"]; // all words starting with A
    plistData = [NSMutableArray arrayWithContentsOfFile:finalPath];
}

- (void)tearDown
{
    
    
    [super tearDown];
}

- (void)testGoodWin
{
    [good startNewGame:3 :4 :plistData];
    good.word = [plistData objectAtIndex:18];
    STAssertTrue([good.word isEqualToString:@"ABAC"], @"");
    
    int updateGameResult = [good updateGame:(@"Z")];
    STAssertTrue([good.displayWordString isEqualToString:@"----"], @"");
    STAssertTrue(updateGameResult == CONTINUE, @"");

    updateGameResult = [good updateGame:(@"B")];
    STAssertTrue(updateGameResult == CONTINUE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"-B--"], @"");
    
    updateGameResult = [good updateGame:(@"A")];
    STAssertTrue(updateGameResult == CONTINUE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"ABA-"], @"");
    
    updateGameResult = [good updateGame:(@"C")];
    STAssertTrue(updateGameResult == WIN, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"ABAC"], @"");
}

- (void)testGoodLose
{
    [good startNewGame:3 :4 :plistData];
    good.word = [plistData objectAtIndex:18];
    STAssertTrue([good.word isEqualToString:@"ABAC"], @"");
    
    int updateGameResult = [good updateGame:(@"Z")];
    STAssertTrue([good.displayWordString isEqualToString:@"----"], @"");
    STAssertTrue(updateGameResult == CONTINUE, @"");
    
    updateGameResult = [good updateGame:(@"B")];
    STAssertTrue(updateGameResult == CONTINUE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"-B--"], @"");
    
    updateGameResult = [good updateGame:(@"A")];
    STAssertTrue(updateGameResult == CONTINUE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"ABA-"], @"");
    
    updateGameResult = [good updateGame:(@"Y")];
    STAssertTrue(updateGameResult == CONTINUE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"ABA-"], @"");
    
    updateGameResult = [good updateGame:(@"Y")];
    STAssertTrue(updateGameResult == ALREADY_GUESSED, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"ABA-"], @"");
    
    updateGameResult = [good updateGame:(@"X")];
    STAssertTrue(updateGameResult == LOSE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"ABA-"], @"");
}

- (void) testGood1Guess1LetterWordWin
{
    [good startNewGame:1 :1 :plistData];
    good.word = [plistData objectAtIndex:0];
    STAssertTrue([good.word isEqualToString:@"A"], @"");
    
    int updateGameResult = [good updateGame:(@"A")];
    STAssertTrue(updateGameResult == WIN, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"A"], @"");
}

- (void) testGood1Guess1LetterWordLose
{
    [good startNewGame:1 :1 :plistData];
    good.word = [plistData objectAtIndex:0];
    STAssertTrue([good.word isEqualToString:@"A"], @"");
    
    int updateGameResult = [good updateGame:(@"B")];
    STAssertTrue(updateGameResult == LOSE, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"-"], @"");
}

- (void) testGood26Guess1LetterWordWin
{
    [good startNewGame:26 :1 :plistData];
    good.word = [plistData objectAtIndex:0];
    STAssertTrue([good.word isEqualToString:@"A"], @"");
    
    int updateGameResult;
    
    for (int i=(int)'Z'; i > 'A'; i--) {
        updateGameResult = [good updateGame:([NSString stringWithFormat:@"%c", i])];
        STAssertTrue(updateGameResult == CONTINUE, @"");
        STAssertTrue([good.displayWordString isEqualToString:@"-"], @"");
    }
    updateGameResult = [good updateGame:(@"A")];
    STAssertTrue(updateGameResult == WIN, @"");
    STAssertTrue([good.displayWordString isEqualToString:@"A"], @"");
}       

- (void)testEvilLose
{
    [evil startNewGame:3 :3 :plistData];
    
    int updateGameResult = [evil updateGame:(@"Z")];
    STAssertTrue([evil.displayWordString isEqualToString:@"---"], @"");
    STAssertTrue(updateGameResult == CONTINUE, @"");
    
    updateGameResult = [evil updateGame:(@"Y")];
    STAssertTrue(updateGameResult == CONTINUE, @"");
    STAssertTrue([evil.displayWordString isEqualToString:@"---"], @"");
    
    updateGameResult = [evil updateGame:(@"X")];
    STAssertTrue(updateGameResult == LOSE, @"");
    STAssertTrue([evil.displayWordString isEqualToString:@"---"], @"");
}

- (void) testEvil1Guess1LetterWordWin
{
    [evil startNewGame:1 :1 :plistData];
    evil.word = [plistData objectAtIndex:0];
    STAssertTrue([evil.word isEqualToString:@"A"], @"");
    
    int updateGameResult = [evil updateGame:(@"A")];
    STAssertTrue(updateGameResult == WIN, @"");
    STAssertTrue([evil.displayWordString isEqualToString:@"A"], @"");
}

- (void) testEvil1Guess1LetterWordLose
{
    [evil startNewGame:1 :1 :plistData];
    evil.word = [plistData objectAtIndex:0];
    STAssertTrue([evil.word isEqualToString:@"A"], @"");
    
    int updateGameResult = [evil updateGame:(@"B")];
    STAssertTrue(updateGameResult == LOSE, @"");
    STAssertTrue([evil.displayWordString isEqualToString:@"-"], @"");
}

- (void) testEvil26Guess1LetterWordWin
{
    [evil startNewGame:26 :1 :plistData];
    evil.word = [plistData objectAtIndex:0];
    STAssertTrue([evil.word isEqualToString:@"A"], @"");
    
    int updateGameResult;
    
    for (int i=(int)'Z'; i > 'A'; i--) {
        updateGameResult = [evil updateGame:([NSString stringWithFormat:@"%c", i])];
        STAssertTrue(updateGameResult == CONTINUE, @"");
        STAssertTrue([evil.displayWordString isEqualToString:@"-"], @"");
    }
    updateGameResult = [evil updateGame:(@"A")];
    STAssertTrue(updateGameResult == WIN, @"");
    STAssertTrue([evil.displayWordString isEqualToString:@"A"], @"");
}

@end

