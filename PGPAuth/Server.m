//
//  Server.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "Server.h"

@implementation Server

+ (Server*)init:(NSString *)name url:(NSString *)url fingerprint:(NSString *)keyFP
{
    Server* server = [Server alloc];
    [server setName:name];
    [server setUrl:[NSURL URLWithString:url]];
    [server setKeyFingerprint:keyFP];
    return server;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.keyFingerprint forKey:@"fingerprint"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self != nil)
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.keyFingerprint = [decoder decodeObjectForKey:@"fingerprint"];
    }
    
    return self;
}

@end
