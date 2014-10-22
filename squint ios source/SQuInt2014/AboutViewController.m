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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //self.email_us_button.titleLabel.textColor = [UIColor nu_bright_orange];
    [self.email_us_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
    [self.email_us_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
    self.company_background_view.backgroundColor = [UIColor nu_deep_blue];
    self.company_background_view.alpha = 0.8;
    self.company_description_label.text = @"We are a team of seasoned developers based in Taipei, Taiwan. We specialize in customized mobile solutions for our clients from all over the world, across a variety of industries.";
    self.company_description_two_label.text = @"If you host an academic conference or workshop and think this app is useful, contact us below to see how we can help you roll out your own solution.";
    self.company_trim_view.backgroundColor = [UIColor light_blue];
    self.company_background_view.layer.cornerRadius = 5;
    
}


- (IBAction)email_us_tap:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://jan0054@gmail.com"]];
}

@end
