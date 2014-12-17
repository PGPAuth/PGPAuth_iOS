//
//  DataManager.h
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Server.h"

@interface ServerManager : NSObject

+ (void) initialize;
+ (void) save;

+ (NSArray*) getServers;
+ (NSUInteger) getServerCount;
+ (void) newServer;

@end
