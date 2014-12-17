//
//  KeyFactory.h
//  PGPAuth
//
//  Created by Moritz Grosch on 14.12.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <openssl/rsa.h>

@interface KeyFactory : NSObject

+ (NSString*) generateKey:(int)bits name:(NSString*)name email:(NSString*)email comment:(NSString*)comment;

+ (NSData*) createSecretKeyPacket:(RSA*)key;
+ (NSData*) createUserIDPacket:(NSString*)userID;
+ (NSData*) createSelfSigPacket:(RSA*)key userID:(NSString*)userID;
+ (NSString*) mergeAndImportSecretKey:(NSData*)secretKeyData userID:(NSData*)userID selfSig:(NSData*)selfSig;

+ (NSData*) createPacketWithBody:(NSData*)body packetTag:(char)tag;
+ (NSData*) createPacketWithBody:(unsigned char*)body bodyLength:(unsigned long)length packetTag:(char)tag;

+ (NSString*) makeUserIDWithName:(NSString*)name email:(NSString*)email comment:(NSString*)comment;

@end
