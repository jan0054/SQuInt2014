//
//  PositionDetailViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PositionDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *career_position_label;
@property (strong, nonatomic) IBOutlet UILabel *career_institution_label;
@property (strong, nonatomic) IBOutlet UILabel *career_posted_by;
@property (strong, nonatomic) IBOutlet UILabel *career_notes;
@property NSString *career_objid;


@end
