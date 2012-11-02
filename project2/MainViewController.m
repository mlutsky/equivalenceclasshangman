//
//  MainViewController.m
//  project2
//
//  Created by Merrill Lutsky on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "GoodGameplay.h"
#include <ctype.h>

@implementation MainViewController

@synthesize displayWord = _displayWord;
@synthesize guessesRemaining = _guessesRemaining;
@synthesize lettersUsed = _lettersUsed;
@synthesize guessInput = _guessInput;
@synthesize game = _game;
@synthesize originalGuesses = _originalGuesses;




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"evil" forKey:@"mode"];
    [userDefaults setValue:@"4" forKey:@"wordLength"];
    [userDefaults setValue:@"4" forKey:@"guesses"];
    [userDefaults synchronize];
    
    [self.guessInput setReturnKeyType:UIReturnKeyGo];
    self.guessInput.autocorrectionType = UITextAutocorrectionTypeNo;
    
    NSLog(@"userDefaults wordLength: %d", [[userDefaults valueForKey:@"wordLength"] intValue]);
    [self newGame:(id)nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

// functions to dismiss the two modal controllers
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)historyViewControllerDidFinish:(HistoryViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

// show the FlipsideViewController
- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

// show high scores when scores button is pressed
- (IBAction)showScores:(id)sender
{    
    HistoryViewController *controller = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:controller animated:YES];
}

// take in guesses and update the game accordingly
- (IBAction)inputGuess:(id)sender
{
    // hide the keyboard and record the guess
    [sender resignFirstResponder];
    NSString *guess = [self.guessInput.text uppercaseString];
    NSLog(@"guess: %@", guess);
    if (self.game.guessCount == 0 || self.game.hiddenLetterCount <= 0) {
        // display error message if the game is over
        [self errorWithMessage:@"This game is over, please start a new game."];
    } else if (guess.length != 1 || !isalpha([guess characterAtIndex:0])) {
        // catch input that isn't a single valid character
        [self errorWithMessage:@"Please enter exactly one valid alphabetical character as your guess."];
        
    } else {
        // update the game
        int updateGameResult = [self.game updateGame:(guess)];
        if (updateGameResult == ALREADY_GUESSED) {
            // catch letters already guessed and inform the user
            NSLog(@"Already guessed that letter");
            [self errorWithMessage:@"You already guessed that letter."];
        } else {
            // update the labels on the screen
            self.guessesRemaining.text = [NSString stringWithFormat:@"%d", [self.game guessCount]];
            self.lettersUsed.text = [NSString stringWithFormat:@"%@ %@", self.lettersUsed.text, guess];
            self.displayWord.text = self.game.displayWordString;
            
            // continue gameplay according to the result
            switch (updateGameResult) {
                case CONTINUE:
                    NSLog(@"Continue");
                    NSLog(@"successful update");
                    break;
                case LOSE:
                    NSLog(@"Losing.");
                    // alert user that the game was won and then show scores
                    [self alertWithTitle:@"Lose..." message:@"You lost THE GAME! :O" delegate:self];
                    break;
                case WIN:
                    NSLog(@"Winning!");
                    // alert user that the game was won and then show scores
                    [self alertWithTitle:@"WINNING!" message:@"You won! Congratulations." delegate:self];
                    
                    // calculate score and mistake number
                    int mistakes = self.originalGuesses - [self.game guessCount];
                    int score = 600 + ((100 * (self.game.word.length)) - (10 * (mistakes)));
                    
                    // create mutable dictionary to insert into high scores
                    NSMutableDictionary *scoreDict = [[NSMutableDictionary alloc] init];
                    [scoreDict setObject:self.game.word forKey:@"word"];
                    // pluralize "error" when necessary
                    if (mistakes == 1) {
                        [scoreDict setObject:[NSString stringWithFormat:@"%d error", mistakes] forKey:@"mistakes"];
                    } else {
                        [scoreDict setObject:[NSString stringWithFormat:@"%d errors", mistakes] forKey:@"mistakes"];
                    }
                    [scoreDict setObject:[NSNumber numberWithInt: score] forKey:@"score"];
                    
                    // instantiate path to scores.plist and load array of high scores dictionaries
                    NSString *path = [[NSBundle mainBundle] bundlePath];
                    NSString *finalPath = [path stringByAppendingPathComponent:@"scores.plist"];
                    NSMutableDictionary *plistData = [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
                                        
                    // iterate through plist data dictionaries and check if score is higher than any that are currently there, and add it to the list if so, removing the last object if the array size is greater 10
                    int count = [[plistData valueForKey:@"High Scores"] count];
                    // check first if there are no high scores yet, and add the score if this is the case
                    if (count == 0) {
                        [[plistData valueForKey:@"High Scores"] insertObject:scoreDict atIndex:0];
                    } else {
                        for (int i = 0; i < count; i++) {
                            // check if score exceeds the score currently at index i, and if so insert it there
                            if (score > [[[[plistData  valueForKey:@"High Scores"] objectAtIndex:i] valueForKey:@"score"] intValue]) {
                                [[plistData valueForKey:@"High Scores"] insertObject:scoreDict atIndex:i];
                                break;
                            } else if (score <= [[[[plistData  valueForKey:@"High Scores"] objectAtIndex:i] valueForKey:@"score"] intValue] && i == count - 1) {
                                // check if at the end of the list, and insert there if not greater than others (to populate the list up to 10)
                                [[plistData valueForKey:@"High Scores"] insertObject:scoreDict atIndex:i + 1];
                                break;
                            }
                        }
                    }
                    
                    // remove last score if the list exceeds 10 elements
                    if ([[plistData valueForKey:@"High Scores"] count] > 10) {
                        [[plistData valueForKey:@"High Scores"] removeLastObject];
                    }
                    [plistData writeToFile:finalPath atomically: NO];
                    break;
            }
        }
    }
    self.guessInput.text = @"";
}

// function to start new game
- (IBAction)newGame:(id)sender
{
    // load NSUserDefaults for wordLength and guesses
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int wordLength = [[userDefaults valueForKey:@"wordLength"] intValue];
    int guesses = [[userDefaults valueForKey:@"guesses"] intValue];
    
    self.originalGuesses = guesses;
    
    // set text on screen to empty
    self.guessInput.text = @"";
    self.lettersUsed.text = @"";
    self.guessesRemaining.text = [NSString stringWithFormat: @"%d", guesses];
    
    // define path to words.plist
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"words.plist"];
    
    // load plist to NSMutableArray
    NSMutableArray *plistData = [NSMutableArray arrayWithContentsOfFile:finalPath];

    // check gameplay mode
    if ([[userDefaults valueForKey:@"mode"] isEqualToString:@"good"]) {
        self.game = [[GoodGameplay alloc] init];
    } else {
        self.game = [[EvilGameplay alloc] init];        
    }
    
    // start the game
    [self.game startNewGame:(guesses) :(wordLength) :(plistData)];  
    
    // show the initial hyphens
    self.displayWord.text = self.game.displayWordString;
}

// define function to refactor alertviews
- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    // show alert view
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil]; // needs to be declared in this scope and cannot be in switch, for some reason
    [alert show];
}

// simpler version of alertWithTitle for errors
- (void)errorWithMessage:(NSString *)message
{
    [self alertWithTitle:@"Error" message:message delegate:nil];
}

// switch to high scores once view is dismissed
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    HistoryViewController *controller = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:controller animated:YES];

}

@end
