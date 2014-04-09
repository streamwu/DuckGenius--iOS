//
//  RecentSearchViewController.h
//  DuckGenius
//
//  Created by StreamWu on 2/13/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface RecentSearchViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *recentSearches;
@end
