//
//  FlipsideViewController.m
//  project2
//
//  Created by Merrill Lutsky on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize wordSize = _wordSize;
@synthesize mistakeNumber = _mistakeNumber;
@synthesize wordSlider = _wordSlider;
@synthesize mistakeSlider = _mistakeSlider;
@synthesize modeToggle = _modeToggle;

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
    
    // load NSUserDefaults and configure sliders and labels accordingly
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.wordSlider.maximumValue = [[userDefaults valueForKey:@"sliderMax"] intValue];
    self.wordSlider.minimumValue = [[userDefaults valueForKey:@"sliderMin"] intValue];
    self.wordSlider.value = [[userDefaults valueForKey:@"wordLength"] intValue];
    self.wordSize.text = [userDefaults valueForKey:@"wordLength"];
    self.mistakeSlider.value = [[userDefaults valueForKey:@"guesses"] intValue];
    self.mistakeNumber.text = [userDefaults valueForKey:@"guesses"];
    self.modeToggle.on = [[userDefaults valueForKey:@"mode"] isEqualToString:@"evil"];
        
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

#pragma mark - Actions

// return to the main view
- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

// detect slider changes
- (IBAction)onChangeSlider:(UISlider *)sender
{
    NSLog(@"%d", [sender tag]);
    NSLog(@"%f", [sender value]);
    
    // load user defaults and record changes, converting to strings in order to store as an object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch([sender tag]) {
        case 0:
            self.wordSize.text = [NSString stringWithFormat:@"%.0f", [sender value]];
            [userDefaults setValue:[NSString stringWithFormat:@"%.0f", [sender value]] forKey:@"wordLength"];
            break;
        case 1:
            self.mistakeNumber.text = [NSString stringWithFormat:@"%.0f", [sender value]];
            [userDefaults setValue:[NSString stringWithFormat:@"%.0f", [sender value]] forKey:@"guesses"];
            break;
        
    }
    [userDefaults synchronize];
}

- (IBAction)onToggleMode:(id)sender;
{
    // load user defaults and record changes, converting to strings in order to store as an object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.modeToggle.on) {
        [userDefaults setValue:[NSString stringWithFormat:@"evil"] forKey:@"mode"];
    } else {
        [userDefaults setValue:[NSString stringWithFormat:@"good"] forKey:@"mode"];
    }
    [userDefaults synchronize];        
}

@end
