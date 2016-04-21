//
//  DataAccessObject.h
//  TutorialBase
//
//  Created by Benjamin Soung on 2/4/16.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DataAccessObject : NSObject
@property (nonatomic, readonly) NSArray *wallObjectsArray;


+ (instancetype)sharedInstance;

-(void)getWallImages:(void (^)(NSArray *objects, NSError *error))completion;

- (BOOL)checkIfCurrentUserLikesImage:(const PFObject*)wallObject;

@end
