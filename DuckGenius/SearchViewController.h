//
//  SearchViewController.h
//  DuckGenius
//
//  Created by StreamWu on 2/13/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "TopicCell.h"

@interface SearchViewController : UITableViewController <UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableDictionary *searchResults;
@property (strong,nonatomic) NSMutableArray *relatedTopics;

-(void) restoreHistory:(NSString *)history;

@end
