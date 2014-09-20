//
//  AbstractPdfViewController.m
//  SQuInt2014
//
//  Created by csjan on 9/10/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "AbstractPdfViewController.h"

@interface AbstractPdfViewController ()

@end

@implementation AbstractPdfViewController
@synthesize abstract_name;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.abstract_name_label.text = self.abstract_name;
    [self get_abstract_data];
}

- (void) get_abstract_data
{
    PFQuery *abstractquery = [PFQuery queryWithClassName:@"abstract"];
    [abstractquery includeKey:@"author"];
    [abstractquery getObjectInBackgroundWithId:self.abstract_objid block:^(PFObject *object, NSError *error) {
        NSLog(@" single abstract query success");
        self.abstract_content_label.text = object[@"content"];
        PFObject *author = object[@"author"];
        self.abstract_author_label.text = [NSString stringWithFormat:@"Author: %@, %@", author[@"last_name"], author[@"first_name"]];
        PFFile *abstract_pdf = object[@"pdf"];
        NSString *pdf_url_str = abstract_pdf.url;
        NSURL *pdf_url = [NSURL URLWithString:pdf_url_str];
        NSURLRequest *loadpdf = [NSURLRequest requestWithURL:pdf_url];
        [self.abstract_pdf_webview loadRequest:loadpdf];
        /*
        [abstract_pdf getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            NSLog(@"pdf file fetch success");
            
        }];
        */
    }];
}

@end
