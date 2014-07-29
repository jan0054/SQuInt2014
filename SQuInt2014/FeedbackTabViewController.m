//
//  FeedbackTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "FeedbackTabViewController.h"

@interface FeedbackTabViewController ()

@end

@implementation FeedbackTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.about_squint_view.layer.cornerRadius = 5;
    self.about_squint_view.layer.masksToBounds = YES;
    self.about_app_view.layer.cornerRadius = 5;
    self.about_app_view.layer.masksToBounds = YES;
}



@end
