//
//  CommentsTableViewController.m
//  TutorialBase
//
//  Created by Benjamin Soung on 2/4/16.
//
//

#import "CommentsTableViewController.h"
#import "AddCommentsViewController.h"

@class WallImageView;
@interface CommentsTableViewController ()


@property (strong, nonatomic) NSArray* commentsArray;

@end

@implementation CommentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSAssert(self.imageObject, @"%@ %@ - Must pass wall image", [self class], NSStringFromSelector(_cmd));
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.commentsArray = self.imageObject[@"comments"];
    
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.commentsArray) {
        return self.commentsArray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"commentsCell"];
        
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        [self.view bringSubviewToFront:self.commentsTitle];
    }
    
    PFObject* commentObject = [self.commentsArray objectAtIndex:indexPath.row];
    
    // if([commentObject createdAt]) is a workaround to check whether the object
    // has already been fetched from Parse
    // If so, update the cell
    // If not, fetch the contents of the object from Parse then update the cell
    if([commentObject createdAt]) {
        NSString* comment = commentObject[@"comment"];
        NSString* user = commentObject[@"user"];
        
        cell.textLabel.text = comment;
        cell.detailTextLabel.text = user;
    } else {
        [commentObject fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            NSString* comment = commentObject[@"comment"];
            NSString* user = commentObject[@"user"];
            
            cell.textLabel.text = comment;
            cell.detailTextLabel.text = user;
        }];
        
    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressedCommentsButton:(id)sender {
    
    AddCommentsViewController *commentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCommentsViewController"];
    commentsViewController.imageObject = self.imageObject;
    [self presentViewController:commentsViewController animated:YES completion:nil];
}
@end
