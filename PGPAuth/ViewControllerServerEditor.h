//
//  ViewControllerServerEditor.h
//  StoryboardTests
//
//  Created by Moritz Grosch on 10.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface ViewControllerServerEditor : UIViewController
{
    NSString* _oldName;
    NSString* _oldURL;
    NSString* _oldKeyID;
    bool _selectingKey;
}

@property(strong, nonatomic) IBOutlet UITextField* textFieldName;
@property(strong, nonatomic) IBOutlet UITextField* textFieldURL;
@property(strong, nonatomic) IBOutlet UITextField* textFieldKeyID;

@property(setter=setServer:, strong, nonatomic) Server* server;

- (void) viewDidLoad;
- (void) viewDidAppear:(BOOL)animated;
- (void) viewWillDisappear:(BOOL)animated;
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void) setServer:(Server *)server;

- (IBAction) revertName:(id)sender;
- (IBAction) revertURL:(id)sender;
- (IBAction) revertKeyID:(id)sender;

@end
