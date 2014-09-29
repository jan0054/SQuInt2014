//
//  TravelTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "TravelTabViewController.h"
#import "UIColor+ProjectColors.h"

@interface TravelTabViewController ()

@end

@implementation TravelTabViewController
@synthesize venue_array;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.venue_array = [[NSMutableArray alloc] init];
    
    self.venuetable.backgroundColor = [UIColor reallylight_blue];
    
    [self get_venue_data];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.venuetable.tableFooterView = [[UIView alloc] init];
}

- (void) viewDidLayoutSubviews
{
    if ([self.venuetable respondsToSelector:@selector(layoutMargins)]) {
        self.venuetable.layoutMargins = UIEdgeInsetsZero;
    }
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
    venuecell.venue_address_label.text = venue[@"address"];
    venuecell.venue_description_label.text = venue[@"description"];
    
    PFGeoPoint *coord = venue[@"coord"];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = coord.latitude;
    zoomLocation.longitude= coord.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
    [venuecell.venuemap setRegion:viewRegion animated:NO];
    
    venuecell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([venuecell respondsToSelector:@selector(layoutMargins)]) {
        venuecell.layoutMargins = UIEdgeInsetsZero;
    }
    
    venuecell.card_view.backgroundColor = [UIColor main_blue];
    venuecell.venue_address_label.textColor = [UIColor light_blue];
    venuecell.venue_trim_view.backgroundColor = [UIColor main_orange];
    venuecell.card_view.layer.cornerRadius = 5;
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

- (IBAction)venue_call_tap:(UIButton *)sender {
    VenueCellTableViewCell *cell = (VenueCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.venuetable indexPathForCell:cell];
    NSLog(@"venue_call_tap: %ld", (long)tapped_path.row);
    PFObject *venue = [self.venue_array objectAtIndex:tapped_path.row];
    NSString *rawphone = venue[@"phone"];
    NSString *phonenumber = [@"tel:" stringByAppendingString:rawphone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonenumber]];
}

- (IBAction)venue_navigate_tap:(UIButton *)sender {
    VenueCellTableViewCell *cell = (VenueCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.venuetable indexPathForCell:cell];
    NSLog(@"venue_navigate_tap: %ld", (long)tapped_path.row);
    PFObject *venue = [self.venue_array objectAtIndex:tapped_path.row];
    PFGeoPoint *location = venue[@"coord"];
    double lat = location.latitude;
    double lon = location.longitude;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:venue[@"name"]];
    [self displayRegionCenteredOnMapItem:mapItem];
}

- (IBAction)venue_website_tap:(UIButton *)sender {
    VenueCellTableViewCell *cell = (VenueCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.venuetable indexPathForCell:cell];
    NSLog(@"venue_website_tap: %ld", (long)tapped_path.row);
    PFObject *venue = [self.venue_array objectAtIndex:tapped_path.row];
    NSString *urlstr = venue[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];

}

- (void)displayRegionCenteredOnMapItem:(MKMapItem*)from {
    CLLocation* fromLocation = from.placemark.location;
    
    // Create a region centered on the starting point with a 2km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 2000, 2000);
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObject:from]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
}


@end
