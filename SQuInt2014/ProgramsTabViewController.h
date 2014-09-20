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
@property (strong, nonatomic) IBOutlet UIView *abstractview;
@property (strong, nonatomic) IBOutlet UITableView *abstracttable;
@property NSMutableArray *session_array;
@property NSMutableDictionary *session_and_talk;
@property NSMutableArray *poster_array;
- (IBAction)poster_detail_tap:(UIButton *)sender;
@property NSMutableArray *abstract_array;
- (IBAction)abstract_detail_tap:(UIButton *)sender;
- (IBAction)talk_detail_tap:(UIButton *)sender;

@end
