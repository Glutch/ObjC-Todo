//
//  TodosViewController.m
//  Todo
//
//  Created by Oliver Johansson on 2018-01-31.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

#import "TodosViewController.h"

@interface TodosViewController ()
@property (nonatomic) NSMutableArray *db;
@end

@implementation TodosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [[NSMutableArray alloc] init];
    
    //Add object to database
    [self.db addObject:@{@"text": @"hello", @"completed": @0, @"priority": @0, @"timestamp": [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]}];
    
    //Save current database to NSUSerDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.db forKey:@"db"];
    
    //Fetch database from NSUserDefaults
    NSMutableArray *dbdata = [[[NSUserDefaults standardUserDefaults] objectForKey:@"db"] mutableCopy];
    
    NSLog(@"db:\n%@", dbdata);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.db count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todo" forIndexPath:indexPath];
    
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
