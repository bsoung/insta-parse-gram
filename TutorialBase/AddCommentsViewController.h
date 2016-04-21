//
//  AddCommentsViewController.h
//  TutorialBase
//
//  Created by Benjamin Soung on 2/4/16.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddCommentsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *commentsTextField;
- (IBAction)enterButtonTouchUpInside:(id)sender;
@property (nonatomic, strong) PFObject *imageObject;
- (IBAction)backButtonTouchUpInside:(id)sender;


@end
