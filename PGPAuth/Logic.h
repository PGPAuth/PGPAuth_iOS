//
//  Logic.h
//  PGPAuth
//
//  Created by Moritz Grosch on 15.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@interface Logic : NSObject

+ (bool) doAction:(NSString*)action onServer:(Server*)server withKeyID:(NSString*)keyID;

@end
