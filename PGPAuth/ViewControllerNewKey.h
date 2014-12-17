//
//  ViewControllerNewKey.h
//  PGPAuth
//
//  Created by Moritz Grosch on 14.12.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerNewKey : UIViewController

@property(strong, nonatomic) IBOutlet UITextField* textFieldName;
@property(strong, nonatomic) IBOutlet UITextField* textFieldEMail;
@property(strong, nonatomic) IBOutlet UITextField* textFieldComment;
@property(strong, nonatomic) IBOutlet UISegmentedControl* segmentedControlKeyLength;

- (IBAction)generateKey:(id)sender;

@end
