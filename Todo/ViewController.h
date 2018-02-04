//
//  ViewController.h
//  Todo
//
//  Created by Oliver Johansson on 2018-01-31.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbHelper.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) DbHelper *dbhelper;
@end

