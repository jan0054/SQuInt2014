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



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VenueCellTableViewCell *venuecell = [tableView dequeueReusableCellWithIdentifier:@"venuecell"];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.049030;
    zoomLocation.longitude= -87.680519;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
    
    [venuecell.venuemap setRegion:viewRegion animated:YES];

    venuecell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return venuecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
