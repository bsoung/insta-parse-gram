//
//  TPUploadImageViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 7/4/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "UploadImageViewController.h"
#import <Parse/Parse.h>

@interface UploadImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) IBOutlet UIImageView *imgToUpload;
@property (nonatomic, strong) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, retain) PFFile *image;
@property (nonatomic, retain) NSData *pictureData;
@end

@implementation UploadImageViewController

#pragma mark - Private methods for picture uploading

-(IBAction)selectPicturePressed:(id)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //[self.navigationController presentModalViewController:imgPicker animated:YES];
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

-(IBAction)sendPressed:(id)sender
{
    [self.commentTextField resignFirstResponder];
    
    // Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;

    self.pictureData = UIImageJPEGRepresentation(self.imgToUpload.image, 0.9f);
    
    if (!self.pictureData) {
        NSLog(@"error");
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        // Display the loading spinner
        UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
        [loadingSpinner startAnimating];
        [self.view addSubview:loadingSpinner];

        self.image = [PFFile fileWithName:@"img" data:self.pictureData];
        
        [self.image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // 2
                PFObject *wallImageObject = [PFObject objectWithClassName:@"WallImageObject"];
                wallImageObject[@"image"] = self.image;
                wallImageObject[@"user"] = [PFUser currentUser].username;
                wallImageObject[@"comment"] = self.commentTextField.text;
                wallImageObject[@"comments"] =  @[];
                
                // 3
                [wallImageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    // 4
                    if (succeeded) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        NSLog(@"error");
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error userInfo][@"error"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        
                        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [alert addAction:okButton];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            } else {
                // 5
                NSLog(@"error");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error userInfo][@"error"] preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } progressBlock:^(int percentDone) {
            NSLog(@"Uploaded: %d%%", percentDone);
        }];
    }

}

-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertController *errorAlertView = [UIAlertController alertControllerWithTitle:@"Error" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [errorAlertView dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [errorAlertView addAction:okButton];
    [self presentViewController:errorAlertView animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //deprecated
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imgToUpload.image = info[UIImagePickerControllerOriginalImage];
}

@end
