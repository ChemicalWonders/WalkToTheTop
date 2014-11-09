//
//  mainViewController.m
//  Walk to the Top
//
//  Created by Kevin Chan on 11/8/14.
//  Copyright (c) 2014 Step By Step. All rights reserved.
//

#import "mainViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface mainViewController ()

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
