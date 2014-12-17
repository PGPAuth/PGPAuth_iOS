//
//  ViewControllerServerList.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ViewControllerServerList.h"
#import "ViewControllerServerEditor.h"
#import "ServerManager.h"
#import "ActionButtons.h"

@implementation ViewControllerServerList

- (void) addButtonPressed:(id)sender
{
    [ServerManager newServer];
    [(UITableView*)self.view reloadData];
    [(UITableView*)self.view selectRowAtIndexPath:[NSIndexPath indexPathForItem:[ServerManager getServerCount]-1 inSection:0] animated:true scrollPosition:UITableViewScrollPositionMiddle];
    
    [self performSegueWithIdentifier:@"editServer" sender:self];
}

- (void) removeButtonPressed:(id)sender
{
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [(UITableView*)self.view reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ServerManager getServerCount];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0)
        return nil;
    
    NSArray* servers = [ServerManager getServers];
    
    if(indexPath.row >= servers.count)
        return nil;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ServerPrototypeCell"];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:100];
    [nameLabel setText:[servers[indexPath.row] name]];
    
    UILabel* urlLabel = (UILabel*)[cell viewWithTag:101];
    [urlLabel setText:[[servers[indexPath.row] url] absoluteString]];
    
    ActionButtons* actionButtons = (ActionButtons*)[cell viewWithTag:102];
    [actionButtons setServer:servers[indexPath.row]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"editServer"])
    {
        ViewControllerServerEditor* vcEditor = segue.destinationViewController;
        vcEditor.server = [ServerManager getServers][[(UITableView*)self.view indexPathForSelectedRow].row];
    }
}

@end
