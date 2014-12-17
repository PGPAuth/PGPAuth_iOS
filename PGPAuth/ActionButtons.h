//
//  ActionButtons.h
//  PGPAuth
//
//  Created by Moritz Grosch on 15.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface ActionButtons : UISegmentedControl
{
    Server* _server;
}

- (void) setServer:(Server*)server;
- (void) valueChanged;

@end
