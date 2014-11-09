//
//  WebController.m
//  Walk to the Top
//
//  Created by Kevin Chan on 11/9/14.
//  Copyright (c) 2014 Step By Step. All rights reserved.
//

#import "WebController.h"

@interface WebController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation WebController

- (void)viewWillAppear:(BOOL)animated {
    _fullURL = @"https://github.com/ChemicalWonders/WalkToTheTop";
    NSURL *url = [NSURL URLWithString: self.fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:requestObj];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
