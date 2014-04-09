//
//  WebViewController.h
//  DuckGenius
//
//  Created by StreamWu on 2/14/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong,nonatomic) NSURL *siteUrl;

@end
