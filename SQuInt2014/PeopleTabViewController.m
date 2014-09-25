//
//  PeopleTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PeopleTabViewController.h"
#import "PersonDetailViewController.h"
#import "UIColor+ProjectColors.h"
@interface PeopleTabViewController ()

@end

NSString *tapped_person_objid;

@implementation PeopleTabViewController
@synthesize person_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.person_array = [[NSMutableArray alloc] init];
    self.peopletable.backgroundColor = [UIColor reallylight_blue];
    
    [self get_person_info];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.peopletable.tableFooterView = [[UIView alloc] init];
}

- (void) viewDidLayoutSubviews
{
    if ([self.peopletable respondsToSelector:@selector(layoutMargins)]) {
        self.peopletable.layoutMargins = UIEdgeInsetsZero;
    }
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
    if ([personcell respondsToSelector:@selector(layoutMargins)]) {
        personcell.layoutMargins = UIEdgeInsetsZero;
    }
    personcell.selectionStyle = UITableViewCellSelectionStyleNone;
    personcell.person_trim_view.backgroundColor = [UIColor main_orange];
    return personcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"persondetailsegue" sender:self];
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

- (IBAction)person_detail_button_tap:(UIButton *)sender {
    PersonCellTableViewCell *cell = (PersonCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.peopletable indexPathForCell:cell];
    NSLog(@"people_detail_tap: %ld", (long)tapped_path.row);
    PFObject *tapped_person = [self.person_array objectAtIndex:tapped_path.row];
    tapped_person_objid = tapped_person.objectId;
    [self performSegueWithIdentifier:@"persondetailsegue" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PersonDetailViewController *destination = [segue destinationViewController];
    destination.person_objid = tapped_person_objid;
}



@end
