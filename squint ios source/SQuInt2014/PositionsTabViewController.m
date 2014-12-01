//
//  PositionsTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PositionsTabViewController.h"
#import "PositionDetailViewController.h"
#import "UIColor+ProjectColors.h"

@interface PositionsTabViewController ()

@end

NSString *tapped_objid;
int unread_total;

@implementation PositionsTabViewController
@synthesize career_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.career_array = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.careertable.backgroundColor = [UIColor clearColor];
    
    [self get_career_data];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.careertable.tableFooterView = [[UIView alloc] init];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self check_unread_count];
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
    careercell.career_author_label.text = [NSString stringWithFormat:@"Posted by: %@", name];
    careercell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([careercell respondsToSelector:@selector(layoutMargins)]) {
        careercell.layoutMargins = UIEdgeInsetsZero;
    }
    careercell.career_card_view.backgroundColor = [UIColor nu_deep_blue];
    careercell.career_card_view.alpha = 0.8;
    careercell.career_trim_view.backgroundColor = [UIColor light_blue];
    careercell.career_card_view.layer.cornerRadius = 5;
    [careercell.career_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
    [careercell.career_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
    
    //add shadow to views
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:careercell.career_card_view.bounds];
    careercell.career_card_view.layer.masksToBounds = NO;
    careercell.career_card_view.layer.shadowColor = [UIColor blackColor].CGColor;
    careercell.career_card_view.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    careercell.career_card_view.layer.shadowOpacity = 0.3f;
    careercell.career_card_view.layer.shadowPath = shadowPath.CGPath;
    
    
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Career" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backButton setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0] , NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = backButton;
    
}

- (void) check_unread_count
{
    unread_total = 0;
    if ([PFUser currentUser])
    {
        PFUser *currentuser = [PFUser currentUser];
        
        PFQuery *query = [PFQuery queryWithClassName:@"conversation"];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"user_a"];
        [query includeKey:@"user_b"];
        [query includeKey:@"user_a_unread"];
        [query includeKey:@"user_b_unread"];
        [query whereKey:@"user_a" equalTo:currentuser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"conversation query one success with count: %lu", (unsigned long)[objects count]);
            for (PFObject *object in objects)
            {
                NSNumber *unreadanum = object[@"user_a_unread"];
                unread_total += [unreadanum intValue];
                UITabBarItem *tbItem = (UITabBarItem *)[[self tabBarController].tabBar.items objectAtIndex:1];
                if (unread_total>0) {
                    tbItem.badgeValue = [NSString stringWithFormat:@"%i", unread_total];
                }
                else
                {
                    tbItem.badgeValue = nil;
                }
                
            }
        }];
        
        PFQuery *query_two = [PFQuery queryWithClassName:@"conversation"];
        [query_two orderByDescending:@"createdAt"];
        [query_two includeKey:@"user_a"];
        [query_two includeKey:@"user_b"];
        [query_two whereKey:@"user_b" equalTo:currentuser];
        [query_two findObjectsInBackgroundWithBlock:^(NSArray *objectss, NSError *error) {
            NSLog(@"conversation query two success with count: %lu", (unsigned long)[objectss count]);
            for (PFObject *object in objectss)
            {
                NSNumber *unreadanum = object[@"user_b_unread"];
                unread_total += [unreadanum intValue];
                UITabBarItem *tbItem = (UITabBarItem *)[[self tabBarController].tabBar.items objectAtIndex:1];
                if (unread_total>0) {
                    tbItem.badgeValue = [NSString stringWithFormat:@"%i", unread_total];
                }
                else
                {
                    tbItem.badgeValue = nil;
                }
            }
        }];
        
        
    }
    
}


@end
