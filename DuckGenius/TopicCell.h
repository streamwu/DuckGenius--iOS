//
//  Cell.h
//  DuckGenius
//
//  Created by StreamWu on 2/13/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *topicText;
@property (weak, nonatomic) IBOutlet UILabel *firstUrl;

@end
