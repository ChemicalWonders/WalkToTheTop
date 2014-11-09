//
//  mainViewController.m
//  Walk to the Top
//
//  Created by Kevin Chan on 11/8/14.
//  Copyright (c) 2014 Step By Step. All rights reserved.
//

#import "mainViewController.h"
#import "LogInControllerViewController.h"

@implementation mainViewController

- (IBAction)Next {
    LogInControllerViewController *second = [[LogInControllerViewController alloc] intWithNibName:nil bundle:nil];
    [self presentViewController:second animated: YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sleep(1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
