//
//  ProgramsTabViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ProgramsTabViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *talkview;
@property (strong, nonatomic) IBOutlet UIView *posterview;
@property (strong, nonatomic) IBOutlet UITableView *postertable;
@property (strong, nonatomic) IBOutlet UITableView *talktable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *programseg;
- (IBAction)segaction:(UISegmentedControl *)sender;

@end
