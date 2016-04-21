//
//  AddCommentsViewController.m
//  TutorialBase
//
//  Created by Benjamin Soung on 2/4/16.
//
//

#import "AddCommentsViewController.h"

@class WallImageView;
@interface AddCommentsViewController ()

@end

@implementation AddCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)enterButtonTouchUpInside:(id)sender {
    NSString *comment = self.commentsTextField.text;
    NSString *user = [[PFUser currentUser] username];
    
    NSArray *comments = self.imageObject[@"comments"];
    
    PFObject* commentObject = [PFObject objectWithClassName:@"CommentObject"];
    commentObject[@"comment"] = comment;
    commentObject[@"user"] = user;
    
    self.imageObject[@"comments"] = [comments arrayByAddingObject:commentObject];
    
    [self.imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)backButtonTouchUpInside:(id)sender {
    NSLog(@"Touched");
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
