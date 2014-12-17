//
//  Server.h
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject

+ (Server*) init:(NSString*)name url:(NSString*)url fingerprint:(NSString*)keyFP;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* url;
@property (strong, nonatomic) NSString* keyFingerprint;

- (void) encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)decoder;

@end
