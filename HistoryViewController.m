//
//  HistoryViewController.m
//  project2
//
//  Created by Merrill Lutsky on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (nonatomic, retain) NSDictionary *highScores;
@end

@implementation HistoryViewController
@synthesize delegate = _delegate;
@synthesize highScores;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.highScores = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scores" ofType:@"plist"]];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender
{
    [self.delegate historyViewControllerDidFinish:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.highScores count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.highScores allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *letterNumber = [self tableView:tableView titleForHeaderInSection:section];
    return [[self.highScores valueForKey:letterNumber] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // configure the cells with labels for the word and the mistakes made
    NSString *letterNumber = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    
    NSString *word = [[[self.highScores valueForKey:letterNumber] objectAtIndex:indexPath.row] valueForKey:@"word"];
    NSString *mistakes = [[[self.highScores valueForKey:letterNumber] objectAtIndex:indexPath.row] valueForKey:@"mistakes"];
    NSString *score = [NSString stringWithFormat:@"%@ points", [[[self.highScores valueForKey:letterNumber] objectAtIndex:indexPath.row] valueForKey:@"score"]];
    cell.textLabel.text = word;	
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", mistakes, score];
    
    // create the cell
    return cell;
    
}



@end