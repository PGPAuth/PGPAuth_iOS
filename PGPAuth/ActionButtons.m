//
//  ActionButtons.m
//  PGPAuth
//
//  Created by Moritz Grosch on 15.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ActionButtons.h"
#import "Logic.h"

@implementation ActionButtons

- (void) setServer:(Server *)server
{
    _server = server;
    
    [self addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void) valueChanged
{
    switch([self selectedSegmentIndex])
    {
        case 0:
            [Logic doAction:@"close" onServer:_server withKeyID:_server.keyFingerprint];
            break;
        case 1:
            [Logic doAction:@"open" onServer:_server withKeyID:_server.keyFingerprint];
            break;
    }
}

@end
