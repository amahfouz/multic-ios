//
//  OptionsViewController.m
//  Multic
//
//  Created by Ayman Mahfouz on 6/3/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import "OptionsViewController.h"

#import "MulticPrefs.h"

@interface OptionsViewController () {
   __weak IBOutlet  UISegmentedControl *levelControl;
   __weak IBOutlet UISegmentedControl *isRandomFirstPosControl;
    IBOutlet UIView *view;
}
@end

@implementation OptionsViewController

- (id)init
{
    self = [super initWithNibName:@"OptionsViewController" bundle:nil];
    if (self) {
        [[self navigationItem] setTitle:@"Options"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSInteger level = [MulticPrefs getDifficultyAsInt];
    
    [levelControl setSelectedSegmentIndex:level];
    
    [levelControl addTarget:self
                      action:@selector(levelControlChanged:)
            forControlEvents:UIControlEventValueChanged];
    
    BOOL isRandomFirstPos = [MulticPrefs getIsRandomFirstPos];
    
    [isRandomFirstPosControl setSelectedSegmentIndex:(isRandomFirstPos ? 1 : 0)];
    
    [isRandomFirstPosControl addTarget:self
                     action:@selector(levelControlChanged:)
           forControlEvents:UIControlEventValueChanged];
    
}

- (void)levelControlChanged:(id)sender
{
    if (sender == levelControl)
        [MulticPrefs setDifficulty:[sender selectedSegmentIndex]];
    else if (sender == isRandomFirstPosControl)
        [MulticPrefs setIsRandomFirstPos:([sender selectedSegmentIndex] == 1)];
}


@end
