//
//  AbstractPdfViewController.h
//  SQuInt2014
//
//  Created by csjan on 9/10/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AbstractPdfViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *abstract_name_label;
@property (strong, nonatomic) IBOutlet UILabel *abstract_author_label;
@property (strong, nonatomic) IBOutlet UILabel *abstract_content_label;
@property (strong, nonatomic) IBOutlet UIWebView *abstract_pdf_webview;
@property NSString *abstract_name;
@property NSString *abstract_objid;

@end
