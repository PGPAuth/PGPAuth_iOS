//
//  DataManager.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager

static NSMutableArray* _servers;

+ (void) initialize
{
    NSURL* documentPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* filePath = [NSString stringWithFormat:@"%@/Servers",[documentPath path]];

    
    _servers = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if(_servers == nil)
    {
        _servers = [[NSMutableArray alloc] init];
    }
    
    //_servers = [[NSMutableArray alloc] init];
    //[_servers addObject:[Server init:@"ChaosChemnitz" url:@"http://door.chch.lan.ffc/cgi-bin/pgpauth_cgi" fingerprint:@"0x97FC6451"]];
    //[_servers addObject:[Server init:@"PGPAuth Testinstance" url:@"https://lf-net.org/cgi-bin/pgpauth_cgi" fingerprint:@"0xED079731"]];
}

+ (void) save
{
    NSURL* documentPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* filePath = [NSString stringWithFormat:@"%@/Servers",[documentPath path]];
    
    [NSKeyedArchiver archiveRootObject:_servers toFile:filePath];
}

+ (NSArray*) getServers
{
    return _servers;
}

+ (NSUInteger) getServerCount
{
    return _servers.count;
}

+ (void) newServer
{
    [_servers addObject:[Server alloc]];
}

@end
