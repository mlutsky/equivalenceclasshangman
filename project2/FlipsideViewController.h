//
//  FlipsideViewController.h
//  project2
//
//  Created by Merrill Lutsky on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;

// declare properties for labels, sliders, and switches
@property (weak, nonatomic) IBOutlet UILabel *wordSize;
@property (weak, nonatomic) IBOutlet UILabel *mistakeNumber;
@property (weak, nonatomic) IBOutlet UISlider *wordSlider;
@property (weak, nonatomic) IBOutlet UISlider *mistakeSlider;
@property (weak, nonatomic) IBOutlet UISwitch *modeToggle;

// declare IBActions for hiding the flipside view and detecting slider and toggle changes
- (IBAction)done:(id)sender;

- (IBAction)onChangeSlider:(id)sender;

- (IBAction)onToggleMode:(id)sender;


@end
