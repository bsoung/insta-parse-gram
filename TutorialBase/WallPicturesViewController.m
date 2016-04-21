//
//  WallPicturesViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "WallPicturesViewController.h"
#import "UploadImageViewController.h"
#import <Parse/Parse.h>
#import "DataAccessObject.h"
#import "CommentsTableViewController.h"
#import "WallPicturesTableViewCell.h"

#pragma mark - Creating a UITableView clone programmatically for practice:

#pragma mark - Creating subclass of UIView


@interface WallPicturesViewController () <WallPicturesTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *wallScroll;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSArray<WallImageView*> *wallImageViews;

@end

@implementation WallPicturesViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.TableView setFrame:self.view.frame];
    [self.TableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self.TableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self getWallImages];
}

#pragma mark - Private methods:

#pragma mark - Loading information for the wall
-(void)getWallImages
{
    [[DataAccessObject sharedInstance] getWallImages:^(NSArray *objects, NSError *error) {
        // 3
        if (!error) {
            [self.TableView reloadData];

            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error userInfo][@"error"] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


#pragma mark - Setting up TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [[[DataAccessObject sharedInstance] wallObjectsArray] count];
    return count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WallPicturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WallImageCell" forIndexPath:indexPath];
    
    const PFObject *wallImage = (const PFObject *)[[[DataAccessObject sharedInstance] wallObjectsArray] objectAtIndex:indexPath.row];
    
    [cell setDelegate:self];
    [cell setWallObject:wallImage];
    
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WallPicturesTableViewCell* cell = (WallPicturesTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"pushToComments" sender:cell.wallObject];
}

#pragma mark - WallPicturesTableViewCellDelegate

- (void)wallPicturesTableViewCell:(WallPicturesTableViewCell *)cell
                likeButtonPressed:(UIButton *)button
{
    NSLog(@"Button press");
    const PFObject* currentWallObject = cell.wallObject;
    
    //create an array for the users who like the image, and initialize empty array if nil
    NSArray *usersWhoLikeImage = currentWallObject[@"usersWhoLikeImage"];
    if (!usersWhoLikeImage) {
        usersWhoLikeImage = @[];
    }
    
    // create string to store the current user's object id

    
    // If liking
    if([cell.LikeButton.titleLabel.text isEqualToString:@"Like"]) {
        
        [cell.LikeButton setTitle:@"Unlike" forState:UIControlStateNormal];
        [cell.LikeButton sizeToFit];
        
        if(![[DataAccessObject sharedInstance] checkIfCurrentUserLikesImage:cell.wallObject]) {
            [currentWallObject addObject:[PFUser currentUser] forKey:@"usersWhoLikeImage"];
            usersWhoLikeImage = currentWallObject[@"usersWhoLikeImage"];
            
            [currentWallObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                cell.numberOfLikes.text = [NSString stringWithFormat:@"%lu Likes", (unsigned long)usersWhoLikeImage.count];
            }];
        }
    } else {
        [cell.LikeButton setTitle:@"Like" forState:UIControlStateNormal];
        [cell.LikeButton sizeToFit];
        
        if([[DataAccessObject sharedInstance] checkIfCurrentUserLikesImage:cell.wallObject]) {
            [currentWallObject removeObject:[PFUser currentUser] forKey:@"usersWhoLikeImage"];
            usersWhoLikeImage = currentWallObject[@"usersWhoLikeImage"];
            
            [currentWallObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                cell.numberOfLikes.text = [NSString stringWithFormat:@"%lu Likes", (unsigned long)usersWhoLikeImage.count];
            }];
        }
    }
}

#pragma mark - Changing to the comments table view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[CommentsTableViewController class]]) {
        CommentsTableViewController *commentsTable = segue.destinationViewController;
        
        commentsTable.imageObject = (PFObject*)sender;
    }
}


#pragma  mark - Logout navigation controller
-(IBAction)logoutPressed:(id)sender
{
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
