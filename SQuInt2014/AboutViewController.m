//
//  AboutViewController.m
//  SQuInt2014
//
//  Created by csjan on 9/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+ProjectColors.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor reallylight_blue];
    self.email_us_button.titleLabel.textColor = [UIColor bright_orange];
    self.company_background_view.backgroundColor = [UIColor main_blue];
    self.company_description_label.text = @"We are a team of seasoned developers based in Taipei, Taiwan. We specialize in customized mobile solutions for our clients from all over the world, across a variety of industries.";
    self.company_description_two_label.text = @"If you host an academic conference or workshop and think this app is useful, contact us below to see how we can help you roll out your own solution.";
}


- (IBAction)email_us_tap:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://jan0054@gmail.com"]];
}

@end
