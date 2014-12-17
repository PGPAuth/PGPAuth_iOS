//
//  ViewControllerServerEditor.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ViewControllerServerEditor.h"
#import "ViewControllerKeyList.h"

@implementation ViewControllerServerEditor

- (void) setServer:(Server *)server
{
    _server = server;
    _oldName = _server.name;
    _oldURL = [_server.url absoluteString];
    _oldKeyID = _server.keyFingerprint;
}

- (void) viewDidLoad
{
    [_textFieldName setText:_oldName];
    [_textFieldURL setText:_oldURL];
    [_textFieldKeyID setText:_oldKeyID];
}

- (void) viewDidAppear:(BOOL)animated
{
    if(_selectingKey)
    {
        [_textFieldKeyID setText:[ViewControllerKeyList getLastSelectedKeyID]];
        _selectingKey = false;
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    _server.name = _textFieldName.text;
    _server.url = [NSURL URLWithString:_textFieldURL.text];
    _server.keyFingerprint = _textFieldKeyID.text;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectKeySegue"])
    {
        _selectingKey = true;
    }
}

- (void) revertName:(id)sender
{
    [_textFieldName setText:_oldName];
}

- (void) revertURL:(id)sender
{
    [_textFieldURL setText:_oldURL];
}

- (void) revertKeyID:(id)sender
{
    [_textFieldKeyID setText:_oldKeyID];
}

@end
