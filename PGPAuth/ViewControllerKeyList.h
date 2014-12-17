//
//  ViewControllerKeyList.h
//  PGPAuth
//
//  Created by Moritz Grosch on 12.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerKeyList : UITableViewController

+ (NSString*) getLastSelectedKeyID;

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
