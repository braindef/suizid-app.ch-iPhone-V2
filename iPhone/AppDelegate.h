//
//  AppDelegate.h
//  iPhone
//
//  Created by Marc Landolt jun. on 14.11.14.
//  Copyright (c) 2014 Marc Landolt jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;
@class ChatViewController;
@class CallViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (weak, nonatomic) IBOutlet SettingsViewController *settingsViewControler;
@property (weak, nonatomic) IBOutlet ChatViewController *chatViewControler;
@property (weak, nonatomic) IBOutlet CallViewController *callViewControler;


@end

