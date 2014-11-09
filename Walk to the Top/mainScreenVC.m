//
//  mainScreenVC.m
//  Walk to the Top
//
//  Created by Kevin Chan on 11/8/14.
//  Copyright (c) 2014 Step By Step. All rights reserved.
//

#import "mainScreenVC.h"



@interface mainScreenVC()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation mainScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
