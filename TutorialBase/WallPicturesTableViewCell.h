//
//  WallPicturesTableViewCell.h
//  TutorialBase
//
//  Created by Benjamin Soung on 2/10/16.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class WallPicturesTableViewCell;

@protocol WallPicturesTableViewCellDelegate <NSObject>

@required
- (void)wallPicturesTableViewCell:(WallPicturesTableViewCell*)cell likeButtonPressed:(UIButton*)button;

@end

@interface WallPicturesTableViewCell : UITableViewCell

@property (weak, nonatomic) id<WallPicturesTableViewCellDelegate>delegate;

@property (strong, nonatomic) const PFObject *wallObject;

@property (weak, nonatomic) IBOutlet UIImageView *wallImagePicture;

@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UIButton *LikeButton;

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;


- (IBAction)likeButtonTouchUpInside:(id)sender;

@end
