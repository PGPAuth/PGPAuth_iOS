//
//  KeyFactory.m
//  PGPAuth
//
//  Created by Moritz Grosch on 14.12.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "KeyFactory.h"
#import "KeyManager.h"

#import <ObjectivePGP/ObjectivePGP.h>
#import <ObjectivePGP/PGPMPI.h>
#import <ObjectivePGP/PGPTypes.h>
#import <ObjectivePGP/PGPPacket.h>
#import <ObjectivePGP/PGPArmor.h>

#include <openssl/rsa.h>
#include <openssl/sha.h>

@implementation KeyFactory

+ (NSString*)generateKey:(int)bits name:(NSString *)name email:(NSString *)email comment:(NSString *)comment
{
    BIGNUM* e = BN_new();
    BN_set_word(e, 65537);
    
    RSA* key = RSA_new();
    RSA_generate_key_ex(key, bits, e, NULL);
    
    NSData* secretKeyPacket = [KeyFactory createSecretKeyPacket:key];
    NSString* userID = [KeyFactory makeUserIDWithName:name email:email comment:comment];
    NSData* userIDPacket = [KeyFactory createUserIDPacket:userID];
    NSData* selfsigPacket = [KeyFactory createSelfSigPacket:key userIDPacket:userID];
    
    NSString* keyID = [KeyFactory mergeAndImportSecretKey:secretKeyPacket userID:userIDPacket selfSig:selfsigPacket];
    
    return keyID;
}

+ (NSString*) mergeAndImportSecretKey:(NSData *)secretKeyData userID:(NSData *)userID selfSig:(NSData *)selfSig
{
    unsigned long messageLength = secretKeyData.length + userID.length + selfSig.length;
   
    unsigned char* message = malloc(messageLength);
    unsigned char* messageStart = message;
    
    memcpy(message, secretKeyData.bytes, secretKeyData.length);
    message = (unsigned char*)(message + secretKeyData.length);
    
    memcpy(message, userID.bytes, userID.length);
    message = (unsigned char*)(message + userID.length);
    
    memcpy(message, selfSig.bytes, selfSig.length);
    message = (unsigned char*)(message + selfSig.length);
    
    NSData* messageData = [[NSData alloc] initWithBytes:messageStart length:messageLength];
    free(messageStart);
    
    NSData* armoredData = [PGPArmor armoredData:messageData as:PGPArmorTypeSecretKey];
    
    char* string = malloc(armoredData.length + 1);
    memset(string, 0, armoredData.length + 1);
    memcpy(string, armoredData.bytes, armoredData.length);
    
    NSString* armoredString = [NSString stringWithUTF8String:string];
    NSLog(@"%s",string);
    
    free(string);
    
    return [KeyManager importKey:armoredData];
}

+ (NSData*) createPacketWithBody:(NSData *)body packetTag:(char)tag
{
    NSData* lengthData = [PGPPacket buildNewFormatLengthDataForData:body];
    
    unsigned long headerLength = lengthData.length + 1;
    unsigned char* header = malloc(headerLength);
    header[0] = tag | PGPHeaderPacketTagAllwaysSet | PGPHeaderPacketTagNewFormat;
    memcpy((char*)(header + 1), lengthData.bytes, lengthData.length);
    
    unsigned char* packet = malloc(body.length + headerLength);
    memcpy(packet, header, headerLength);
    
    memcpy((char*)(packet + headerLength), body.bytes, body.length);
    
    NSData* packetData = [[NSData alloc] initWithBytes:packet length:body.length + headerLength];
    
    free(header);
    free(packet);
    
    return packetData;
}

+ (NSData*) createPacketWithBody:(unsigned char *)body bodyLength:(unsigned long)length packetTag:(char)tag
{
    return [KeyFactory createPacketWithBody:[[NSData alloc] initWithBytes:body length:length] packetTag:tag];
}

+ (NSData*) createSecretKeyPacket:(RSA *)key
{
    unsigned char n[BN_num_bytes(key->n)];
    BN_bn2bin(key->n, n);
    NSData* nData = [NSData dataWithBytes:n length:sizeof(n)];
    PGPMPI* nMPI = [[PGPMPI alloc] initWithData:nData];
    NSData* nMPIData = [nMPI exportMPI];
    
    unsigned char e[BN_num_bytes(key->e)];
    BN_bn2bin(key->e, e);
    NSData* eData = [NSData dataWithBytes:e length:sizeof(e)];
    PGPMPI* eMPI = [[PGPMPI alloc] initWithData:eData];
    NSData* eMPIData = [eMPI exportMPI];
    
    unsigned char d[BN_num_bytes(key->d)];
    BN_bn2bin(key->d, d);
    NSData* dData = [NSData dataWithBytes:d length:sizeof(d)];
    PGPMPI* dMPI = [[PGPMPI alloc] initWithData:dData];
    NSData* dMPIData = [dMPI exportMPI];
    
    unsigned char p[BN_num_bytes(key->p)];
    BN_bn2bin(key->p, p);
    NSData* pData = [NSData dataWithBytes:p length:sizeof(p)];
    PGPMPI* pMPI = [[PGPMPI alloc] initWithData:pData];
    NSData* pMPIData = [pMPI exportMPI];
    
    unsigned char q[BN_num_bytes(key->q)];
    BN_bn2bin(key->q, q);
    NSData* qData = [NSData dataWithBytes:q length:sizeof(q)];
    PGPMPI* qMPI = [[PGPMPI alloc] initWithData:qData];
    NSData* qMPIData = [qMPI exportMPI];
    
    BN_CTX* ctx = BN_CTX_new();

    BIGNUM* bnu = BN_new();
    BN_mod_inverse(bnu, key->p, key->q, ctx);
    
    unsigned char u[BN_num_bytes(bnu)];
    BN_bn2bin(bnu, u);
    NSData* uData = [NSData dataWithBytes:u length:sizeof(u)];
    PGPMPI* uMPI = [[PGPMPI alloc] initWithData:uData];
    NSData* uMPIData = [uMPI exportMPI];
    
    BN_CTX_free(ctx);
    
    unsigned long packetDataLength = 9 + nMPIData.length + eMPIData.length + dMPIData.length + pMPIData.length + qMPIData.length + uMPIData.length;
    unsigned char* bodyData = malloc(packetDataLength);
    
    unsigned int dataPosition = 0;
    
    // public-key stuff
    
    // Packet version
    bodyData[dataPosition++] = 4;
    
    // Timestamp of key-generation
    unsigned int timestamp = (int)time(NULL);
    bodyData[dataPosition++] = (timestamp & 0xFF000000UL) >> 24;
    bodyData[dataPosition++] = (timestamp & 0x00FF0000UL) >> 16;
    bodyData[dataPosition++] = (timestamp & 0x0000FF00UL) >> 8;
    bodyData[dataPosition++] = timestamp  & 0x000000FFUL;
    
    // Key-Algorithm
    bodyData[dataPosition++] = PGPPublicKeyAlgorithmRSA;
    
    memcpy((char*)(bodyData + dataPosition), nMPIData.bytes, nMPIData.length);
    dataPosition += nMPIData.length;
    
    memcpy((char*)(bodyData + dataPosition), eMPIData.bytes, eMPIData.length);
    dataPosition += eMPIData.length;
    
    // secret-key stuff
    // Key-encryption
    bodyData[dataPosition++] = PGPS2KUsageNone;
    
    unsigned int secretKeyMPIDataStart = dataPosition;
    
    memcpy((char*)(bodyData + dataPosition), dMPIData.bytes, dMPIData.length);
    dataPosition += dMPIData.length;
    
    memcpy((char*)(bodyData + dataPosition), pMPIData.bytes, pMPIData.length);
    dataPosition += pMPIData.length;
    
    memcpy((char*)(bodyData + dataPosition), qMPIData.bytes, qMPIData.length);
    dataPosition += qMPIData.length;
    
    memcpy((char*)(bodyData + dataPosition), uMPIData.bytes, uMPIData.length);
    dataPosition += uMPIData.length;
    
    // "sum of all octets, mod 65536" ... let the overflow do the mod
    unsigned short checksum;
    for(unsigned int i = secretKeyMPIDataStart; i < dataPosition; i++)
    {
        checksum += bodyData[i];
    }
    
    bodyData[dataPosition++] = (checksum & 0xFF00) >> 8;
    bodyData[dataPosition++] = checksum & 0xFF;
    
    NSData* secretKeyPacket = [KeyFactory createPacketWithBody:bodyData bodyLength:dataPosition packetTag:PGPSecretKeyPacketTag];
    
    free(bodyData);
    
    return secretKeyPacket;
}

+ (NSData*) createUserIDPacket:(NSString *)userID
{
    NSData* userIDData = [userID dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* userIDPacket = [KeyFactory createPacketWithBody:userIDData packetTag:PGPUserIDPacketTag];
    
    return userIDPacket;
}

+ (NSString*) makeUserIDWithName:(NSString *)name email:(NSString *)email comment:(NSString *)comment
{
    NSString* userID;
    
    if(comment.length > 0)
        userID = [NSString stringWithFormat:@"%@ (%@) <%@>",name,comment,email];
    else
        userID = [NSString stringWithFormat:@"%@ <%@>",name,email];
    
    return userID;
}

+ (NSData*) createSelfSigPacket:(RSA *)key userIDPacket:(NSString *)userID
{
    unsigned char* body = malloc(22);
    unsigned int position = 0;
    
    body[position++] = 0x04; // Version
    body[position++] = 0x13; // Positive UserID certification
    body[position++] = PGPPublicKeyAlgorithmRSA;
    body[position++] = PGPHashSHA512;
    
    // number of bytes used for hashed sub-packages
    body[position++] = 0;
    body[position++] = 12;
    
    // subpackage: signature creation time
    // length
    body[position++] = 5;
    // subpackage type
    body[position++] = 2;
    // timestamp
    unsigned long timestamp = time(NULL);
    body[position++] = (timestamp & 0xFF000000UL) >> 24;
    body[position++] = (timestamp & 0x00FF0000UL) >> 16;
    body[position++] = (timestamp & 0x0000FF00UL) >> 8;
    body[position++] = timestamp  & 0x000000FFUL;
    
    // subpackage: primary userID
    // length
    body[position++] = 2;
    // subpackage type
    body[position++] = 25;
    // boolean value
    body[position++] = true;
    
    // subpackage: key-flags
    // length
    body[position++] = 2;
    // subpackage type
    body[position++] = 27;
    // flags
    body[position++] = PGPSignatureFlagAllowSignData | PGPSignatureFlagAllowAuthentication;
    
    NSData* userIDData = [userID dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData* userIDHashData = [[NSMutableData alloc] init];
    [userIDHashData appendData:userIDData];
    [userIDHashData appendBytes:body length:position];
    [userIDHashData appendBytes:(char[]){0x04, 0xFF} length:2];
    [userIDHashData appendBytes:(char[]){(position >> 24) & 0xFF, (position >> 16) & 0xFF, (position >> 8) & 0xFF, position & 0xFF} length:4];
    
    unsigned char sha512[SHA512_DIGEST_LENGTH];
    SHA512(userIDHashData.bytes, userIDHashData.length, sha512);
    
    static const unsigned char sha512prefix[] = { 0x30, 0x51, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03, 0x05, 0x00, 0x04, 0x40 };
    
    unsigned char* dataToSign = malloc(sizeof(sha512prefix) + SHA512_DIGEST_LENGTH);
    memcpy(dataToSign, sha512prefix, sizeof(sha512prefix));
    memcpy((char*)(dataToSign + sizeof(sha512prefix)), sha512, SHA512_DIGEST_LENGTH);
    
    unsigned char* signature = malloc(key->d->dmax);
    int signatureSize = RSA_private_encrypt(sizeof(sha512prefix) + SHA512_DIGEST_LENGTH, dataToSign, signature, key, RSA_PKCS1_PADDING);
    
    NSData* signatureData = [[NSData alloc] initWithBytes:signature length:signatureSize];
    PGPMPI* signatureMPI = [[PGPMPI alloc] initWithData:signatureData];
    NSData* signatureMPIData = [signatureMPI exportMPI];
    
    // no unhashed sub-packages
    body[position++] = 0;
    body[position++] = 0;

    // left 16-bits of the signed hash value
    body[position++] = sha512[63];
    body[position++] = sha512[62];
    
    unsigned long fullPacketLength = position + signatureMPIData.length;
    unsigned char* fullPacket = malloc(fullPacketLength);
    memcpy(fullPacket, body, position);
    memcpy((char*)(fullPacket + position), signatureMPIData.bytes, signatureMPIData.length);
    
    NSData* fullPacketData = [[NSData alloc] initWithBytes:fullPacket length:fullPacketLength];
    NSData* packetData = [KeyFactory createPacketWithBody:fullPacketData packetTag:0x02];
    
    free(body);
    free(dataToSign);
    free(signature);
    free(fullPacket);
    
    return packetData;
}

@end
