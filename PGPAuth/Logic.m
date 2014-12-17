//
//  Logic.m
//  PGPAuth
//
//  Created by Moritz Grosch on 15.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "Logic.h"
#import "KeyManager.h"
#import "NSString_URLEncode.h"

@implementation Logic

+ (bool) doAction:(NSString *)action onServer:(Server *)server withKeyID:(NSString *)keyID
{
    unsigned long long timestamp = (time_t)[[NSDate date] timeIntervalSince1970];
    NSString* fullCommandString = [NSString stringWithFormat:@"%@:%llu",action,timestamp];
    
    Key* key = [KeyManager getKeyWithKeyID:keyID];
    NSString* signedData = [KeyManager signData:fullCommandString withKey:key];
    
    NSString* post = [NSString stringWithFormat:@"data=%@", [signedData urlencode]];
    NSData* postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:true];
    NSString* postLength = [NSString stringWithFormat:@"%lu", (unsigned long)postData.length];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:server.url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    [connection start];
    
    return false;
}

@end
