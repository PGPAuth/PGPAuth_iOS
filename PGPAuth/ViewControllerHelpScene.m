//
//  ViewController.m
//  StoryboardTests
//
//  Created by Moritz Grosch on 09.11.14.
//  Copyright (c) 2014 LittleFox. All rights reserved.
//

#import "ViewControllerHelpScene.h"

@interface ViewControllerHelpScene ()

@end

@implementation ViewControllerHelpScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView loadHTMLString:@"<style type=text/css>body { font-family: sans-serif; }</style><h1>PGPAuth</h1><p>PGPAuth is an app to send authenticated and tamper-resistant commands to a server. Currently, there are only 2 commands supported: open and close. You can use these to lock or unlock i.e. your door.</p><p>This is really useful for small organizations such as hackerspaces or fablabs.</p><p>If you have any problems, please contact me at littlefox@fsfe.org (PGP-Key 0x97FC6451) or fill a bugreport on <a href=https://github.com/LittleFox94/PGPAuth_iOS>GitHub</a>.</p><p>Thank you for using PGPAuth :)</p>" baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
