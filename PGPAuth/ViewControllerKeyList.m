//
//  ViewControllerKeyList.m
//  PGPAuth
//
//  Created by Moritz Grosch on 12.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ViewControllerKeyList.h"
#import "KeyManager.h"
#import "Key.h"

@implementation ViewControllerKeyList

static NSString* _lastSelectedKeyID;

+ (NSString*) getLastSelectedKeyID
{
    return _lastSelectedKeyID;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section != 0)
        return 0;
    
    else
        return [KeyManager getKeyCount];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0)
        return nil;
    
    NSArray* keys = [KeyManager getKeys];
    
    if(indexPath.row >= keys.count)
        return nil;
    
    Key* key = keys[indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"KeyPrototypeCell"];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:100];
    [nameLabel setText:[keys[indexPath.row] name]];
    
    NSString* emailAndComment;
    
    if(![key.comment isEqual:@""])
        emailAndComment = [NSString stringWithFormat:@"%@ (%@)", key.email, key.comment];
    else
        emailAndComment = key.email;
    
    UILabel* emailAndCommentLabel = (UILabel*)[cell viewWithTag:101];
    [emailAndCommentLabel setText:emailAndComment];
    
    UILabel* typeLabel = (UILabel*)[cell viewWithTag:102];
    [typeLabel setText:key.type];
    
    UILabel* fingerprintLabel = (UILabel*)[cell viewWithTag:103];
    
    NSMutableString* fingerprint = [[NSMutableString alloc] init];
    
    for(int i = 0; i < key.fingerprint.length; i+=4)
    {
        [fingerprint appendString:[key.fingerprint substringWithRange:NSMakeRange(i, 4)]];
        [fingerprint appendString:@" "];
    }
    
    [fingerprintLabel setText:fingerprint];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* keys = [KeyManager getKeys];
    
    if(indexPath.section == 0 && indexPath.row < keys.count)
    {
        Key* key = keys[indexPath.row];
        _lastSelectedKeyID = key.fingerprint;
    }
    
    [self.parentViewController.navigationController popViewControllerAnimated:true];
}

@end
