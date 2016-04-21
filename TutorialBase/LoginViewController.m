//
//  LoginViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <Parse/Parse.h>


@interface LoginViewController ()
@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark - Private methods

-(IBAction)logInPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
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

- (IBAction)FacebookButtonTouchUpInside:(id)sender {
    
    NSArray *permissions = @[@"email"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
            
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
            
            NSLog(@"User logged in through Facebook!");
        }
    }];
   

}
@end
