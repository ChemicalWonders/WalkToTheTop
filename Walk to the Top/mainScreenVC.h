//
//  ViewController.h
//  Walk to the Top
//
//  Created by Kevin Chan on 11/8/14.
//  Copyright (c) 2014 Step By Step. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface mainScreenVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nPasswordTextField;

- (IBAction)signup:(id)sender;
@end

