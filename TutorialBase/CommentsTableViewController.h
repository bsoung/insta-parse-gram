//
//  CommentsTableViewController.h
//  TutorialBase
//
//  Created by Benjamin Soung on 2/4/16.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@class WallImageView;

@interface CommentsTableViewController : UITableViewController

- (IBAction)pressedCommentsButton:(id)sender;

@property (strong, nonatomic) PFObject* imageObject;
@property (weak, nonatomic) IBOutlet UILabel *commentsTitle;



@end
