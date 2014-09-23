//
//  PositionsTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PositionsTabViewController.h"
#import "PositionDetailViewController.h"

@interface PositionsTabViewController ()

@end

NSString *tapped_objid;

@implementation PositionsTabViewController
@synthesize career_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.career_array = [[NSMutableArray alloc] init];
    
    [self get_career_data];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.careertable.tableFooterView = [[UIView alloc] init];
}

- (void) viewDidLayoutSubviews
{
    if ([self.careertable respondsToSelector:@selector(layoutMargins)]) {
        self.careertable.layoutMargins = UIEdgeInsetsZero;
    }
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
    careercell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([careercell respondsToSelector:@selector(layoutMargins)]) {
        careercell.layoutMargins = UIEdgeInsetsZero;
    }
    return careercell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"positiontodetailsegue" sender:self];
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

- (IBAction)career_detail_tap:(UIButton *)sender {
    CareerCellTableViewCell *cell = (CareerCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.careertable indexPathForCell:cell];
    NSLog(@"career_detail_tap: %ld", (long)tapped_path.row);
    PFObject *tapped_career = [self.career_array objectAtIndex:tapped_path.row];
    tapped_objid = tapped_career.objectId;
    [self performSegueWithIdentifier:@"positiontodetailsegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PositionDetailViewController *destination = [segue destinationViewController];
    destination.career_objid = tapped_objid;
}

@end
