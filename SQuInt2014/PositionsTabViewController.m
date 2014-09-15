//
//  PositionsTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PositionsTabViewController.h"

@interface PositionsTabViewController ()

@end

@implementation PositionsTabViewController
@synthesize career_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.career_array = [[NSMutableArray alloc] init];
    
    [self get_career_data];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.career_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CareerCellTableViewCell *careercell = [tableView dequeueReusableCellWithIdentifier:@"careercell"];
    PFObject *career = [self.career_array objectAtIndex:indexPath.row];
    NSString *position = career[@"position"];
    NSString *institution = career[@"institution"];
    careercell.career_position_label.text = position;
    careercell.career_institution_label.text = institution;
    PFObject *author = career[@"posted_by"];
    NSString *name = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
    careercell.career_author_label.text = name;
    
    return careercell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"positiontodetailsegue" sender:self];
}

- (void) get_career_data
{
    PFQuery *careerquery = [PFQuery queryWithClassName:@"career"];
    [careerquery includeKey:@"posted_by"];
    [careerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"career query success");
        for (PFObject *career_obj in objects)
        {
            [self.career_array addObject:career_obj];
        }
        [self.careertable reloadData];
    }];
}



@end
