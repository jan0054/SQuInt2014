//
//  VenueCellTableViewCell.h
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VenueCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet MKMapView *venuemap;
@property (strong, nonatomic) IBOutlet UILabel *venue_name_label;
@property (strong, nonatomic) IBOutlet UILabel *venue_address_label;
@property (strong, nonatomic) IBOutlet UIButton *venue_call_button;
@property (strong, nonatomic) IBOutlet UIButton *venue_navigate_button;
@property (strong, nonatomic) IBOutlet UIButton *venue_website_button;
@property (strong, nonatomic) IBOutlet UILabel *venue_description_label;
- (IBAction)venue_call_action:(UIButton *)sender;
- (IBAction)venue_navigate_action:(UIButton *)sender;
- (IBAction)venue_website_action:(UIButton *)sender;




@end
