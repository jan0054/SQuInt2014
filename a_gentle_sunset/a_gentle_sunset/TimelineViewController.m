//
//  TimelineViewController.m
//  a_gentle_sunset
//
//  Created by csjan on 3/26/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import "TimelineViewController.h"
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"post";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"content";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:@"post"];
 
 // If Pull To Refresh is enabled, query against the network by default.
 //if (self.pullToRefreshEnabled) {
 //query.cachePolicy = kPFCachePolicyNetworkOnly;
 //}
 
 //csj: this crashes with local datastore enabled: seems to be a parse bug
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 //if (self.objects.count == 0) {
 //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 //}
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }


/*
 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"Cell";
 
 PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 // Configure the cell
 cell.textLabel.text = [object objectForKey:self.textKey];
 cell.imageView.file = [object objectForKey:self.imageKey];
 
 return cell;
 }
 */

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
