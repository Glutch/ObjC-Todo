//
//  dbhandler.h
//  Todo
//
//  Created by Oliver Johansson on 2018-02-04.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbHelper : NSObject
@property (nonatomic) NSMutableArray *normalItems;
@property (nonatomic) NSMutableArray *priorityItems;
@property (nonatomic) NSMutableArray *completedItems;
- (NSInteger)getCount:(NSInteger)index;
- (void)addItem:(NSString*)text;
- (void)prioritize:(NSInteger)index;
- (void)complete:(NSInteger)section row:(NSInteger)row;
- (void)delete:(NSInteger)index;
- (void)undo:(NSInteger)section row:(NSInteger)row;
@end
