//
//  dbhandler.m
//  Todo
//
//  Created by Oliver Johansson on 2018-02-04.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

#import "DbHelper.h"

@implementation DbHelper

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.normalItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"normalItems"] mutableCopy];
        self.priorityItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"priorityItems"] mutableCopy];
        self.completedItems = [[[NSUserDefaults standardUserDefaults] objectForKey:@"completedItems"] mutableCopy];
        
        if (self.normalItems == nil) {
            self.normalItems = [[NSMutableArray alloc] init];
            self.normalItems = @[].mutableCopy;
        }
        
        if (self.priorityItems == nil) {
            self.priorityItems = [[NSMutableArray alloc] init];
            self.priorityItems = @[].mutableCopy;
        }
        
        if (self.completedItems == nil) {
            self.completedItems = [[NSMutableArray alloc] init];
            self.completedItems = @[].mutableCopy;
        }
    }
    return self;
}

- (void)addItem:(NSString*)text {
    NSLog(@"%@", self.normalItems);
    [self.normalItems addObject:@{@"text": text}];
    [self saveDb];
}

- (void)prioritize:(NSInteger)index {
    [self.priorityItems addObject:[self.normalItems objectAtIndex:index]];
    [self.normalItems removeObjectAtIndex:index];
    [self saveDb];
}

- (void)delete:(NSInteger)index {
    [self.completedItems removeObjectAtIndex:index];
    [self saveDb];
}

- (void)complete:(NSInteger)section row:(NSInteger)row {
    if (section == 0) {
        [self.completedItems addObject:[self.priorityItems objectAtIndex:row]];
        [self.priorityItems removeObjectAtIndex:row];
    } else if (section == 1) {
        [self.completedItems addObject:[self.normalItems objectAtIndex:row]];
        [self.normalItems removeObjectAtIndex:row];
    }
    [self saveDb];
}

- (void)undo:(NSInteger)section row:(NSInteger)row {
    if (section == 0) {
        [self.normalItems addObject:[self.priorityItems objectAtIndex:row]];
        [self.priorityItems removeObjectAtIndex:row];
    } else {
        [self.normalItems addObject:[self.completedItems objectAtIndex:row]];
        [self.completedItems removeObjectAtIndex:row];
    }
    [self saveDb];
}

- (void)saveDb {
    [[NSUserDefaults standardUserDefaults] setObject:self.priorityItems forKey:@"priorityItems"];
    [[NSUserDefaults standardUserDefaults] setObject:self.normalItems forKey:@"normalItems"];
    [[NSUserDefaults standardUserDefaults] setObject:self.completedItems forKey:@"completedItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSInteger)getCount:(NSInteger)db {
    if (db == 0) {
        return [self.priorityItems count];
    } else if (db == 1) {
        return [self.normalItems count];
    } else {
        return [self.completedItems count];
    }
}
@end
