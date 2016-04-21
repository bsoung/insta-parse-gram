//
//  WallPicturesTableViewCell.m
//  TutorialBase
//
//  Created by Benjamin Soung on 2/10/16.
//
//

#import "WallPicturesTableViewCell.h"
#import "DataAccessObject.h"

@implementation WallPicturesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configuring each of the table view cells

-(void)setWallObject:(PFObject *)wallObject
{
    _wallObject = wallObject;
    
    PFFile *image = (PFFile *)self.wallObject[@"image"];
 
    [image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.wallImagePicture.image = [UIImage imageWithData:data];
        
    }];
    
    NSDate *creationDate = self.wallObject.createdAt;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timeStamp.text = [NSString stringWithFormat:@"Uploaded by: %@, %@", self.wallObject[@"user"], [formatter stringFromDate:creationDate]];
    
    NSArray *usersWhoLikeImage = self.wallObject[@"usersWhoLikeImage"];
    self.numberOfLikes.text = [NSString stringWithFormat:@"%lu Likes", (unsigned long)usersWhoLikeImage.count];
    
    self.commentsLabel.text = self.wallObject[@"comment"];
    
    
    if([[DataAccessObject sharedInstance] checkIfCurrentUserLikesImage:self.wallObject] && [self.wallObject[@"usersWhoLikeImage"] count]) {
        [self.LikeButton setTitle:@"Unlike" forState:UIControlStateNormal];
        [self.LikeButton sizeToFit];
        
    } else if (![self.wallObject[@"usersWhoLikeImage"] count]) {
        [self.LikeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self.LikeButton sizeToFit];
    }
}

- (IBAction)likeButtonTouchUpInside:(UIButton*)sender {
    [self.delegate wallPicturesTableViewCell:self likeButtonPressed:sender];
}
@end
