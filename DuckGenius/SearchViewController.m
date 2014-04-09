//
//  SearchViewController.m
//  DuckGenius
//
//  Created by StreamWu on 2/13/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // A default search of Chicago 
    [self downloadData:@"Chicago"];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
}

//////////////////////////////////////////////////////
// Restore history navigated form recent searches  ///
//////////////////////////////////////////////////////

-(void) restoreHistory:(NSString *)history{
    [self downloadData: history];
}


///////////////////////////////////////////////////////////////////////////////
//Add new search through alertview dialogue                                 ///
//Save queryTerm into UserDefault                                           ///
//And download search results(relatedTopics and firstUrl) into searchResults///
///////////////////////////////////////////////////////////////////////////////

- (IBAction)addButtonTapped:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Query" message:@"Enter search term"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    NSLog(@"alerttextfiled - %@",alertTextField.text);
    
    // Store alertTextField(queryTerm) into RecentSearches array stored in NSUserDefaults
    [self saveNSUserDefaults:alertTextField.text];
    
    // Pass this text to our download method
    [self downloadData:alertTextField.text];
        
}

- (void)saveNSUserDefaults:(NSString*)queryTerm{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentSearches;
    
    if (![defaults objectForKey:@"RecentSearches"]) {
        recentSearches = [[NSMutableArray alloc] init];
    }
    else{
        recentSearches = [[defaults objectForKey:@"RecentSearches"] mutableCopy];
    }
    
    //Add the term to local array
    [recentSearches addObject:queryTerm];
    //Copy local array to user default
    [defaults setObject:recentSearches forKey:@"RecentSearches"];
    //Write it to disk
    [defaults synchronize];
    
}


- (void)downloadData:(NSString*)queryTerm{
    queryTerm = [queryTerm stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *query = [NSString stringWithFormat:@"http://api.duckduckgo.com/?q=%@&format=json&pretty=1",queryTerm];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session
      dataTaskWithURL:[NSURL URLWithString:query]
      completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        NSError *errorJson = nil;
        // Convert JSON to NSDictionary
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        // Update the searchResults property
        self.searchResults = [results mutableCopy];
        self.relatedTopics = [NSMutableArray arrayWithArray:[self.searchResults objectForKey:@"RelatedTopics"]];
        // Refresh the table on main thread
        dispatch_async(dispatch_get_main_queue(), ^{ [self.tableView reloadData];});
      }] resume];
}

////////////////////////////////////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.relatedTopics count];
    
}

////////////////////////////////////
// Display search results in cells//
////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopicCell";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                 forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *topic = [self.relatedTopics objectAtIndex:indexPath.row];

    cell.topicText.text = [topic objectForKey:@"Text"];
    cell.firstUrl.text = [topic objectForKey:@"FirstURL"];
    
    
    return cell;
}


#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Navigation
//////////////////////////////////
// navigate to WebViewController//
//////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    NSDictionary *topic = [self.relatedTopics objectAtIndex:path.row];
    NSString *urlString = [topic objectForKey:@"FirstURL"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if([segue.identifier isEqualToString:@"segueToWebViewController"]){
        WebViewController *wvc = (WebViewController *)segue.destinationViewController;
        wvc.siteUrl = url;
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
