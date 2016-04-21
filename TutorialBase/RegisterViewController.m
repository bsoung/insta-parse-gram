//
//  RegisterViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/27/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()
@property (nonatomic, strong) IBOutlet UITextField *userRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterTextField;
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    
    return self;
}

#pragma mark - Signing up for a new account methods

-(IBAction)signUpUserPressed:(id)sender
{
    PFUser *user = [PFUser user];
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error userInfo][@"error"] preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

@end
