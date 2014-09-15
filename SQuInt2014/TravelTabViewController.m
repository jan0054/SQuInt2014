//
//  TravelTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "TravelTabViewController.h"

@interface TravelTabViewController ()

@end

@implementation TravelTabViewController
@synthesize venue_array;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.venue_array = [[NSMutableArray alloc] init];
    
    [self get_venue_data];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.venue_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCellTableViewCell *venuecell = [tableView dequeueReusableCellWithIdentifier:@"venuecell"];
    
    PFObject *venue = [self.venue_array objectAtIndex:indexPath.row];
    venuecell.venue_name_label.text = venue[@"name"];
    
    PFGeoPoint *coord = venue[@"coord"];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = coord.latitude;
    zoomLocation.longitude= coord.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
    [venuecell.venuemap setRegion:viewRegion animated:NO];
    
    venuecell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return venuecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) get_venue_data
{
    PFQuery *venuequery = [PFQuery queryWithClassName:@"poi"];
    [venuequery orderByDescending:@"order"];
    [venuequery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"poi query success");
        for (PFObject *poi_obj in objects)
        {
            [self.venue_array addObject:poi_obj];
        }
        [self.venuetable reloadData];
    }];

}

@end
