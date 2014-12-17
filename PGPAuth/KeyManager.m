//
//  KeyManager.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 12.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "KeyManager.h"
#import "Key.h"
#import <ObjectivePGP/ObjectivePGP.h>
#import <ObjectivePGP/PGPArmor.h>

@implementation KeyManager

static ObjectivePGP* _pgp;

+ (void) initialize
{
    NSBundle* myBundle = [NSBundle mainBundle];
    NSString* secringPath = [myBundle pathForResource:@"secring" ofType:@"gpg"];
    
    _pgp = [[ObjectivePGP alloc] init];
    [_pgp importKeysFromFile:secringPath allowDuplicates:NO];
}

+ (void) saveKeyring
{
    NSBundle* myBundle = [NSBundle mainBundle];
    NSString* secringPath = [myBundle pathForResource:@"secring" ofType:@"gpg"];
    
    [_pgp exportKeys:_pgp.keys toFile:secringPath error:nil];
}

+ (NSString*) importKey:(NSData *)keyData
{
    NSArray* keys = [_pgp importKeysFromData:keyData allowDuplicates:false];
    PGPKey* opgpKey = [keys objectAtIndex:0];
    Key* key = [[Key alloc] initWithObjectivePGPKey:opgpKey];
    
    return key.fingerprint;
}

+ (NSArray*) getKeys
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < _pgp.keys.count; i++)
    {
        [ret addObject:[[Key alloc] initWithObjectivePGPKey:_pgp.keys[i]]];
    }
    
    return ret;
}

+ (NSInteger) getKeyCount
{
    return _pgp.keys.count;
}

+ (Key*) getKeyWithKeyID:(NSString*)keyID
{
    PGPKey* key = [_pgp getKeyForIdentifier:keyID type:PGPKeySecret];
    return [[Key alloc] initWithObjectivePGPKey:key];
}

+ (NSString*) signData:(NSString *)data withKey:(Key *)key
{
    NSData* inData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData* outData = [_pgp signData:inData usingSecretKey:key.key passphrase:@"" detached:false];
    
    NSData* armoredData = [PGPArmor armoredData:outData as:PGPArmorTypeSignature];
    
    return [NSString stringWithUTF8String:[armoredData bytes]];
}

@end
