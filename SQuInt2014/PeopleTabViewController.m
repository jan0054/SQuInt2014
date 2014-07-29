//
//  PeopleTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PeopleTabViewController.h"

@interface PeopleTabViewController ()

@end

@implementation PeopleTabViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }
    else {
        return 5;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *mecell = [tableView dequeueReusableCellWithIdentifier:@"meinfocell"];

    UITableViewCell *peoplecell = [tableView dequeueReusableCellWithIdentifier:@"peopleinfocell"];
    
    mecell.selectionStyle = UITableViewCellSelectionStyleNone;
    peoplecell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ( indexPath.section==0 )
    {
        return mecell;
    }
    
    else
    {
        return peoplecell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"persondetailsegue" sender:self];
}



@end
