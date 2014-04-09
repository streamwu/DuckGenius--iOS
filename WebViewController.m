//
//  WebViewController.m
//  DuckGenius
//
//  Created by StreamWu on 2/14/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
	//display the site
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.siteUrl];
    [self.webView loadRequest:requestObj];
    self.webView.scalesPageToFit = true;
    
}

- (IBAction)refreshTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}


- (IBAction)rewindTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}


- (IBAction)forwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
