//
//  mainViewController.m
//  Walk to the Top
//
//  Created by Kevin Chan on 11/8/14.
//  Copyright (c) 2014 Step By Step. All rights reserved.
//

#import "mainViewController.h"
#import "LogInControllerViewController.h"
#import "mainScreenVC.h"
#import <FacebookSDK/FacebookSDK.h>

BOOL loginOK = NO; // you determine this

@interface mainViewController ()

@end

@implementation mainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL segueShouldOccur = NO; // you determine this
    
    if ([identifier isEqualToString:@"toMainPage"]) {
        // perform your computation to determine whether segue should occur
        
        if ( loginOK == true){
            segueShouldOccur = true;
        }
        else{
            segueShouldOccur = false;
        }
        
        
        if (!segueShouldOccur) {
            
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}

- (IBAction)checkLogin:(id)sender {
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        
        loginOK = false;
        
    }
    
    else {
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                message:[error.userInfo objectForKey:@"error"]
                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alertView show];
                loginOK = false;
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                NSLog(@"(Button was pressed");
                loginOK = true;
            }
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
