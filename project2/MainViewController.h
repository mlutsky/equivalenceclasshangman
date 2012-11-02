//
//  MainViewController.h
//  project2
//
//  Created by Merrill Lutsky on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateGameEnums.h"
#import "FlipsideViewController.h"
#import "HistoryViewController.h"
#import "GameplayDelegate.h"
#import "GoodGameplay.h"
#import "EvilGameplay.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, HistoryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *displayWord;
@property (weak, nonatomic) IBOutlet UILabel *guessesRemaining;
@property (weak, nonatomic) IBOutlet UILabel *lettersUsed;
@property (weak, nonatomic) IBOutlet UITextField *guessInput;
@property (readwrite, assign) int originalGuesses;
@property (strong, nonatomic) id<GameplayDelegate> game;


- (IBAction)showInfo:(id)sender;

- (IBAction)showScores:(id)sender;

- (IBAction)inputGuess:(id)sender;

- (IBAction)newGame:(id)sender;

- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

- (void)errorWithMessage:(NSString *)message;

@end
