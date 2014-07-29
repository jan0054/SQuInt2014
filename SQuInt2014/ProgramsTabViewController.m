//
//  ProgramsTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "ProgramsTabViewController.h"

@interface ProgramsTabViewController ()

@end

@implementation ProgramsTabViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.posterview.hidden=YES;
    self.posterview.userInteractionEnabled=NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *talkcell = [tableView dequeueReusableCellWithIdentifier:@"talkcell"];
    
    UITableViewCell *postercell = [tableView dequeueReusableCellWithIdentifier:@"postercell"];
    
    talkcell.selectionStyle = UITableViewCellSelectionStyleNone;
    postercell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.tag==1)
    {
        return talkcell;
    }
    else
    {
        return postercell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)segaction:(UISegmentedControl *)sender {
    if (self.programseg.selectedSegmentIndex==0)
    {
        self.talkview.hidden=NO;
        self.posterview.hidden=YES;
        self.talkview.userInteractionEnabled=YES;
        self.posterview.userInteractionEnabled=NO;
    }
    else if (self.programseg.selectedSegmentIndex==1)
    {
        self.talkview.hidden=YES;
        self.posterview.hidden=NO;
        self.talkview.userInteractionEnabled=NO;
        self.posterview.userInteractionEnabled=YES;
    }
}
@end
