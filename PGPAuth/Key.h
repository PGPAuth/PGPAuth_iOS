//
//  Key.h
//  StoryboardTests
//
//  Created by Moritz Grosch on 12.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectivePGP/ObjectivePGP.h>

@interface Key : NSObject

@property (strong, nonatomic, readonly) NSString* fingerprint;
@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) NSString* email;
@property (strong, nonatomic, readonly) NSString* type;
@property (strong, nonatomic, readonly) NSString* comment;
@property (strong, nonatomic, readonly) PGPKey* key;

- (Key*) initWithObjectivePGPKey:(PGPKey*)key;

@end
