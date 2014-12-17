//
//  ViewControllerServerList.h
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerServerList : UITableViewController

- (IBAction) addButtonPressed:(id)sender;
- (IBAction) removeButtonPressed:(id)sender;
- (void) viewWillAppear:(BOOL)animated;

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
