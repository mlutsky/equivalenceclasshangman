//
//  HistoryViewController.h
//  project2
//
//  Created by Merrill Lutsky on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryViewController;

@protocol HistoryViewControllerDelegate
- (void) historyViewControllerDidFinish:(HistoryViewController *)controller;
@end

@interface HistoryViewController : UIViewController {
    NSDictionary *highScores;
}

@property (weak, nonatomic) IBOutlet id <HistoryViewControllerDelegate> delegate;

// declare IBAction to hide high score list
- (IBAction)done:(id)sender;

@end
