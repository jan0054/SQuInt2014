//
//  AbstractPdfViewController.m
//  SQuInt2014
//
//  Created by csjan on 9/10/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "AbstractPdfViewController.h"
#import "UIColor+ProjectColors.h"
#import "PeopleTabViewController.h"

@interface AbstractPdfViewController ()

@end

NSString *author_id;

@implementation AbstractPdfViewController
@synthesize abstract_name;
@synthesize from_author;
@synthesize abstract_objid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.pdf_trim_view.backgroundColor = [UIColor light_blue];
    self.abstract_trim_view.backgroundColor = [UIColor light_blue];
    self.abstract_card_view.backgroundColor = [UIColor nu_deep_blue];
    self.abstract_card_view.alpha = 0.8;
    self.abstract_author_label.textColor = [UIColor reallylight_blue];
    self.abstract_card_view.layer.cornerRadius = 5;
    [self.author_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
    [self.author_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
    
    
    [self get_abstract_data];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (self.from_author==1)
    {
        self.author_detail_button.hidden = YES;
        self.from_author=0;
    }
    else
    {
        self.author_detail_button.hidden = NO;
    }
}

- (void) get_abstract_data
{
    PFQuery *abstractquery = [PFQuery queryWithClassName:@"abstract"];
    [abstractquery includeKey:@"author"];
    [abstractquery getObjectInBackgroundWithId:self.abstract_objid block:^(PFObject *object, NSError *error) {
        NSLog(@" single abstract query success");
        self.abstract_name_label.text = object[@"name"];
        self.abstract_content_label.text = object[@"content"];
        PFObject *author = object[@"author"];
        author_id = author.objectId;
        self.abstract_author_label.text = [NSString stringWithFormat:@"%@, %@", author[@"first_name"], author[@"last_name"]];
        PFFile *abstract_pdf = object[@"pdf"];
        NSString *pdf_url_str = abstract_pdf.url;
        NSLog(@"pdf URL: %@", pdf_url_str );
        NSURL *pdf_url = [NSURL URLWithString:pdf_url_str];
        NSURLRequest *loadpdf = [NSURLRequest requestWithURL:pdf_url];
        [self.abstract_pdf_webview loadRequest:loadpdf];
    }];
}

- (IBAction)author_detail_button_tap:(UIButton *)sender {
    UINavigationController *navcon = [self.tabBarController.viewControllers objectAtIndex:1];
    [navcon popToRootViewControllerAnimated:NO];
    PeopleTabViewController *ppltabcon = (PeopleTabViewController *)[navcon topViewController];
    ppltabcon.from_event=1;
    ppltabcon.event_author_id = author_id;
    [self.tabBarController setSelectedIndex:1];
}



@end
