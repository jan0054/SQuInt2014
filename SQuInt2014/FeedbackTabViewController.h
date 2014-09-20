//
//  FeedbackTabViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "SettingLoginCellTableViewCell.h"
#import "SettingPushCellTableViewCell.h"
#import "GeneralSettingCellTableViewCell.h"
#import "CustomLogInViewController.h"
#import "CustomSignUpViewController.h"

@interface FeedbackTabViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *settingstable;



@end
