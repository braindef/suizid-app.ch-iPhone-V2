#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

#import <AVFoundation/AVFoundation.h>

@class SettingsViewController;
@class ChatViewController;
@class CallViewController;
@class RootViewController;
@class EvaluateViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, XMPPRosterDelegate>
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
	
	UIWindow *window;
	UINavigationController *navigationController;
    SettingsViewController *loginViewController;
    ChatViewController *loginChatViewController;
    CallViewController *loginCallViewController;
    
    UIBarButtonItem *loginButton;

}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong) AVAudioPlayer *avSound;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet SettingsViewController *settingsViewController;
@property (nonatomic, strong) IBOutlet ChatViewController *chatViewController;
@property (nonatomic, strong) IBOutlet CallViewController *callViewController;
@property (nonatomic, strong) IBOutlet RootViewController *rootViewController;
@property (nonatomic, strong) IBOutlet EvaluateViewController *evaluateViewController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic, strong) NSTimer *timeout;

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

- (void)rescued;

- (void)helped;

- (void)madeworse;

- (void)endEvaluate:(NSString *)points;

- (void)needHelpChat;

- (IBAction)temp:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *temp2;

@end
