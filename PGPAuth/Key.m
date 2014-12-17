//
//  Key.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 12.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "Key.h"
#import <ObjectivePGP/PGPUserIDPacket.h>
#import <ObjectivePGP/PGPPublicKeyPacket.h>

@implementation Key

- (Key*) initWithObjectivePGPKey:(PGPKey *)key
{
    PGPUser* user = key.users[0];
    NSString* userID = user.userIDPacket.userID;
    
    NSMutableString* name = [[NSMutableString alloc] init];
    NSMutableString* comment = [[NSMutableString alloc] init];
    NSMutableString* email = [[NSMutableString alloc] init];
    
    int i;
    for(i = 0; i < userID.length; i++)
    {
        char c = [userID characterAtIndex:i];
        
        if(c == '(' || c == '<')
            break;
        
        [name appendFormat:@"%c",c];
    }
    
    if([userID characterAtIndex:i] == '(')
    {
        i++; // skipping the (
        
        for(;i < userID.length; i++)
        {
            char c = [userID characterAtIndex:i];
            
            if(c == ')')
                break;
            
            [comment appendFormat:@"%c",c];
        }
        
        i++;
    }
    
    for(;i < userID.length; i++)
    {
        if([userID characterAtIndex:i] == '<')
            break;
    }
    
    if([userID characterAtIndex:i] == '<')
    {
        i++; // skipping the <
        
        for(;i < userID.length; i++)
        {
            char c = [userID characterAtIndex:i];
            
            if(c == '>')
                break;
            
            [email appendFormat:@"%c",c];
        }
        
        i++;
    }
    
    _name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _comment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableString* type = [[NSMutableString alloc] init];
    
    PGPPublicKeyPacket* pubKey = (PGPPublicKeyPacket*)key.primaryKeyPacket;
    
    NSString* algorithm;
    
    switch(pubKey.publicKeyAlgorithm)
    {
        case PGPPublicKeyAlgorithmRSA:
            algorithm = @"RSA";
            break;
        
        default:
            algorithm = @"unknown";
            break;
    }
    
    [type appendFormat:@"%u %@", pubKey.keySize * 8, algorithm];
    
    _type = type;
    
    PGPKeyID* keyID = key.keyID;
    
    _fingerprint = keyID.longKeyString;
    
    _key = key;
    
    return self;
}

@end
