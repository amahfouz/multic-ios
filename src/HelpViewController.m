//
//  HelpViewController.m
//  Multic
//
//  Created by Ayman Mahfouz on 6/2/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)init
{
    self = [super initWithNibName:@"HelpViewController" bundle:nil];
    [[self navigationItem] setTitle:@"Instructions"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

@end
