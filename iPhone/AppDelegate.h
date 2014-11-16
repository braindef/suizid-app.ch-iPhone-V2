//
//  AppDelegate.h
//  iPhone
//
//  Created by Marc Landolt jun. on 14.11.14.
//  Copyright (c) 2014 Marc Landolt jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import <AVFoundation/AVFoundation.h>

@class SettingsViewController;
@class ChatViewController;
@class CallViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    
    NSString *password;
    
    BOOL customCertEvaluation;
    
    BOOL isXmppConnected;

}

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (weak, nonatomic) IBOutlet SettingsViewController *settingsViewController;
@property (weak, nonatomic) IBOutlet ChatViewController *chatViewController;
@property (weak, nonatomic) IBOutlet CallViewController *callViewController;

@property (nonatomic, strong) AVAudioPlayer *avSound;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;



- (BOOL)connect;
- (BOOL)connect: (NSString *)username password:(NSString *) password;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

- (void)disconnect;

- (void)sendChatMessage: (NSString*) text;
- (void)sendLoginRequest;

- (void)sendDecline;
- (void)sendAccept;

- (IBAction)needHelp:(id)sender;

- (IBAction)savedmylife:(id)sender;
- (IBAction)improovedmysituation:(id)sender;
- (IBAction)madeitworse:(id)sender;
- (void) sendEvaluation:(NSString*) points;




@end

