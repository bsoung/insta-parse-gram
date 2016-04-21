//
//  DataAccessObject.m
//  TutorialBase
//
//  Created by Benjamin Soung on 2/4/16.
//
//

#import "DataAccessObject.h"

@interface DataAccessObject ()
@property (nonatomic, readwrite) NSArray *wallObjectsArray;

@end

@implementation DataAccessObject




+ (instancetype)sharedInstance
{
    static DataAccessObject *instance;
    
    //# of times, only once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      instance = [[DataAccessObject alloc] init];
                      
                  });
    
    return instance;
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"self!");
    }
    
    //types of things to be stored in DAO
    
    return self;

}

-(void)getWallImages:(void (^)(NSArray *objects, NSError *error))completion
{
    // 1
    PFQuery *query = [PFQuery queryWithClassName:@"WallImageObject"];
    
    // 2
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.wallObjectsArray = objects;
        completion(objects, error);
      
    }];
}

- (BOOL)checkIfCurrentUserLikesImage:(const PFObject*)wallObject
{
    NSArray* usersWhoLikeImage = wallObject[@"usersWhoLikeImage"];
    BOOL likeFound = NO;
    NSString* currentUserID = [PFUser currentUser].objectId;
    
    // loop through Like array, create string to store the current user object id
    for (PFUser *theUser in usersWhoLikeImage) {
        NSString* theUserID = theUser.objectId;
        
        //if the current user object id matches the same id found in the array, we have found the liker
        if ([theUserID isEqualToString:currentUserID]) {
            likeFound = YES;
            break;
        }
    }

    return likeFound;
}





@end
