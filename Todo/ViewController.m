//
//  ViewController.m
//  Todo
//
//  Created by Oliver Johansson on 2018-01-31.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

#import "ViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "DbHelper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *todoInput;
@property (weak, nonatomic) IBOutlet UITableView *todosTable;
@property (nonatomic) NSMutableArray *normalItems;
@property (nonatomic) NSMutableArray *priorityItems;
@property (nonatomic) NSMutableArray *completedItems;
@property (weak, nonatomic) IBOutlet UIView *inputBox;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbhelper = [[DbHelper alloc] init];
    
    self.normalItems = [self.dbhelper normalItems];
    self.priorityItems = [self.dbhelper priorityItems];
    self.completedItems = [self.dbhelper completedItems];

    [self style];
    [self reload];
}

- (void)style {
    self.todosTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.todosTable.backgroundColor = [UIColor whiteColor];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.inputBox.frame.size.height, self.inputBox.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f].CGColor;
    
    [self.inputBox.layer addSublayer:bottomBorder];
}

- (void)reload {
    self.normalItems = [self.dbhelper normalItems];
    self.priorityItems = [self.dbhelper priorityItems];
    self.completedItems = [self.dbhelper completedItems];
    [self.todosTable reloadData];
}

- (IBAction)todoAdd:(id)sender {
    NSString *text = [NSString stringWithFormat:@"%@", self.todoInput.text];
    
    [self.dbhelper addItem:text];
    
    self.todoInput.text = @"";
    
    [self reload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dbhelper getCount:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = NSLocalizedString(@"Priority", @"Priority");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Tasks", @"Tasks");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Completed", @"Completed");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.todosTable reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * reuseIdentifier = @"todo";
    
    MGSwipeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.priorityItems objectAtIndex:indexPath.row][@"text"];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.normalItems objectAtIndex:indexPath.row][@"text"];
    } else {
        cell.textLabel.text = [self.completedItems objectAtIndex:indexPath.row][@"text"];
    }
    
    
    
    if (indexPath.section == 0) {
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Undo" backgroundColor:[UIColor colorWithRed:119.0/255.0f green:181.0/255.0f blue:239.0/255.0f alpha:1.0] padding:30 callback:^BOOL(MGSwipeTableCell *sender) {
            [self.dbhelper undo:indexPath.section row:indexPath.row];
            [self reload];
            return YES;
        }]];
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Complete" backgroundColor:[UIColor colorWithRed:85.0f/255.0f green:206.0f/255.0f blue:156.0/255.0f alpha:1.0] padding:30 callback:^BOOL(MGSwipeTableCell *sender) {
            [self.dbhelper complete:indexPath.section row:indexPath.row];
            [self reload];
            return YES;
        }]];
    }
    
    if (indexPath.section == 1) {
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Priority" backgroundColor:[UIColor colorWithRed:119.0/255.0f green:181.0/255.0f blue:239.0/255.0f alpha:1.0] padding:30 callback:^BOOL(MGSwipeTableCell *sender) {
            [self.dbhelper prioritize:indexPath.row];
            [self reload];
            return YES;
        }]];
        
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Complete" backgroundColor:[UIColor colorWithRed:85.0f/255.0f green:206.0f/255.0f blue:156.0/255.0f alpha:1.0] padding:30 callback:^BOOL(MGSwipeTableCell *sender) {
            [self.dbhelper complete:indexPath.section row:indexPath.row];
            [self reload];
            return YES;
        }]];
    }
    
    if (indexPath.section == 2) {
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Undo" backgroundColor:[UIColor colorWithRed:119.0/255.0f green:181.0/255.0f blue:239.0/255.0f alpha:1.0] padding:30 callback:^BOOL(MGSwipeTableCell *sender) {
            [self.dbhelper undo:indexPath.section row:indexPath.row];
            [self reload];
            return YES;
        }]];
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Remove" backgroundColor:[UIColor colorWithRed:231.0f/255.0f green:107.0f/255.0f blue:107.0/255.0f alpha:1.0] padding:30 callback:^BOOL(MGSwipeTableCell *sender) {
            [self.dbhelper delete:indexPath.row];
            [self reload];
            return YES;
        }]];
    }
     
    return cell;
}

- (void)makePriority:(NSInteger)index {
    [self.priorityItems addObject:[self.normalItems objectAtIndex:index]];
    [self.normalItems removeObjectAtIndex:index];
    [self saveDb];
    [self reload];
}

- (void)saveDb {
    [[NSUserDefaults standardUserDefaults] setObject:self.priorityItems forKey:@"priorityItems"];
    [[NSUserDefaults standardUserDefaults] setObject:self.normalItems forKey:@"normalItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
