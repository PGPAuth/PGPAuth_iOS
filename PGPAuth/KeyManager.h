//
//  KeyManager.h
//  StoryboardTests
//
//  Created by Moritz Grosch on 12.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Key.h"

@interface KeyManager : NSObject

+ (void) initialize;
+ (void) saveKeyring;
+ (NSString*) importKey:(NSData*)keyData;

+ (NSArray*) getKeys;
+ (NSInteger) getKeyCount;

+ (Key*) getKeyWithKeyID:(NSString*)keyID;

+ (NSString*) signData:(NSString*)data withKey:(Key*)key;

@end
