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

- (IBAction)signup:(id)sender {
    NSString *username = [self.nUsernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.nPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneNumber = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0 || [name length] == 0 || [phoneNumber length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You have to enter a name, phone number, username, password, and email"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
       // newUser.name = name;
       // newUser.phoneNumber = phoneNumber;
      
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Registration success!");
                
                [self dismissViewControllerAnimated:true completion:nil];
                
                [self performSegueWithIdentifier:@"vcpush" sender:sender];
                
                _nameTextField.text = nil;
                _phoneNumberTextField.text = nil;
                _emailTextField.text = nil;
                _nUsernameTextField.text = nil;
                _nPasswordTextField.text = nil;
                
                
                //[self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            

        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
