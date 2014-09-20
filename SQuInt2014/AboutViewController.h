//
//  AboutViewController.h
//  SQuInt2014
//
//  Created by csjan on 9/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *email_us_button;
- (IBAction)email_us_tap:(UIButton *)sender;

@end
