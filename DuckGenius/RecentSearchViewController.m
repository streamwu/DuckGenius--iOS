//
//  RecentSearchViewController.m
//  DuckGenius
//
//  Created by StreamWu on 2/13/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import "RecentSearchViewController.h"

@interface RecentSearchViewController ()

@end

@implementation RecentSearchViewController

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
    
    // Load data from the NSUserDefault
    [self loadData];
    
    // Refresh Controller
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor magentaColor];
    [pullToRefresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    
    //Edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

-(void) loadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.recentSearches = [[defaults objectForKey:@"RecentSearches"] mutableCopy];
}

-(void) refreshTable {
    [self loadData];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.recentSearches count];
}

////////////////////////////////////////
// Display recent query terms in cells//
////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.recentSearches objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

////////////////////////////////////////////////
// Override to support editing the table view.//
////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.recentSearches removeObjectAtIndex:indexPath.row];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //Copy local array to user default
        [defaults setObject:self.recentSearches forKey:@"RecentSearches"];
        //Write it to disk
        [defaults synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/////////////////////////////////////////////////////
// Override to support rearranging the table view. //
/////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.recentSearches exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Copy local array to user default
    [defaults setObject:self.recentSearches forKey:@"RecentSearches"];
    //Write it to disk
    [defaults synchronize];

}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



//////////////////////////////////////
// Navigate to SearchViewController //
//////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *query = [self.recentSearches objectAtIndex:indexPath.row];
    
    UINavigationController *target_navic = [self.tabBarController.viewControllers objectAtIndex:0];
    SearchViewController *target_searchvc = [target_navic.viewControllers objectAtIndex:0];
    [target_searchvc restoreHistory:query];
    
    self.tabBarController.selectedIndex = 0;
    [self.tabBarController.viewControllers[0] popToRootViewControllerAnimated:NO];
    
}

#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    NSString *query = [self.recentSearches objectAtIndex:path.row];
//    if([segue.identifier isEqualToString:@"segueToWebViewController"]){
//        [segue.destinationViewController setInitialQuery:query];
//    }
//}



@end
