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
@synthesize person_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.person_array = [[NSMutableArray alloc] init];
    
    [self get_person_info];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.person_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCellTableViewCell *personcell = [tableView dequeueReusableCellWithIdentifier:@"personcell"];
    PFObject *person = [self.person_array objectAtIndex:indexPath.row];
    NSString *lastname = person[@"last_name"];
    NSString *firstname = person[@"first_name"];
    NSString *institution = person[@"institution"];
    personcell.name_label.text = [NSString stringWithFormat:@"%@, %@",lastname, firstname];
    personcell.institution_label.text = institution;
    
    return personcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"persondetailsegue" sender:self];
}

- (void) get_person_info
{
    PFQuery *personquery = [PFQuery queryWithClassName:@"person"];
    [personquery orderByDescending:@"institution"];
    [personquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"person query success");
        for (PFObject *person_obj in objects)
        {
            [self.person_array addObject:person_obj];
        }
        [self.peopletable reloadData];
    }];

}

@end
