//
//  ViewControllerNewKey.m
//  PGPAuth
//
//  Created by Moritz Grosch on 14.12.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ViewControllerNewKey.h"
#import "KeyFactory.h"

@implementation ViewControllerNewKey

- (void) generateKey:(id)sender
{
    int bits = 0;
    
    switch(_segmentedControlKeyLength.selectedSegmentIndex)
    {
        case 0:
            bits = 2048;
            break;
        case 1:
            bits = 3179;
            break;
        case 2:
            bits = 4096;
            break;
        case 3:
            bits = 8192;
            break;
        default:
            bits = 4096; // Todo: handle this better ...
            break;
    }
    
    [KeyFactory generateKey:bits name:_textFieldName.text email:_textFieldEMail.text comment:_textFieldComment.text];
}

@end
