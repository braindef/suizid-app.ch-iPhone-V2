//
//  AppDelegate.m
//  iPhone
//
//  Created by Marc Landolt jun. on 14.11.14.
//  Copyright (c) 2014 Marc Landolt jun. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import "ChatViewController.h"
#import "SettingsViewController.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "DDLog.h"
#import "DDTTYLogger.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navigationController;
@synthesize settingsViewController;
@synthesize chatViewController;
@synthesize callViewController;

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure logging framework
    
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    // Setup the XMPP stream
    
    [self setupStream];
    
    // Setup the view controllers
    
    //[window setRootViewController:navigationController];
    //[window makeKeyAndVisible];
    
    if (![self connect])
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //[navigationController presentViewController:settingsViewController animated:YES completion:NULL];
        });
    }
    
    return YES;
}

- (void)dealloc
{
    [self teardownStream];
}

- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Activate xmpp modules
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    //	[xmppStream setHostName:@"talk.google.com"];
    //	[xmppStream setHostPort:5222];
    
    
    // You may need to alter these settings depending on the server you're connecting to
    customCertEvaluation = YES;
}

- (void)teardownStream
{
    
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    [[self xmppStream] sendElement:presence];
    
    
    if ([Config isHelpSeeker]&&![Config hasLogin]) [self sendLoginRequest];
    if ([Config hasLogin]) [self sendSupporterRequest];
    
    if ([Config isSupporter]) [self supporterLogin];
    
}

- (void)goOffline
{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

- (BOOL)connect
{
    
    return [self connect:nil password:nil];
}

- (BOOL)connect: (NSString *)loginname password:(NSString *)loginpass
{
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
    //
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    //
    // myJID = @"user@gmail.com/xmppframework";
    // myPassword = @"";
    
    if (myJID == nil || myPassword == nil || [myJID isEqualToString:@""] ) {
        myJID=[Config managementUser];
        myPassword=[Config managementPassword];
        
    }
    else
    {
        [Config setIsSupporter:true];
    }
    
    if(!([Config isHelpSeeker]||[Config isSupporter])) return false;
    
    if(loginname != nil)
    {
        [xmppStream setMyJID:[XMPPJID jidWithString:loginname]];
        password = loginpass;
        
    }
    else
    {
        [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
        password = myPassword;
    }
    
    
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        //DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    
    
    
    return YES;
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    //
    // If your application supports background execution,
    // called instead of applicationWillTerminate: when the user quits.
    
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
    //DDLogError(@"The iPhone simulator does not process background network traffic. "
     //          @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
    {
        [application setKeepAliveTimeout:600 handler:^{
            
            //DDLogVerbose(@"KeepAliveHandler");
            
            // Do other keep alive stuff here.
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self teardownStream];
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
    }
    
    if (customCertEvaluation)
    {
        [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // A simple example of inbound message handling.
    
    if ([message isChatMessageWithBody])
    {
        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                 xmppStream:xmppStream
                                                       managedObjectContext:[self managedObjectContext_roster]];
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [user displayName];
        
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            
        }
        else
        {
            // We are not active, so use a local notification instead
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            
            
            
        }
        
        if([body hasPrefix:@"SuicidePreventionAppServerLoginRequestAnswer"])
        {
            NSArray *logindata = [body componentsSeparatedByString:@";"];
            NSString *loginuser = [logindata objectAtIndex:1];
            NSString *loginPassword = [logindata objectAtIndex:2];
            
            [self disconnect];
            
            [Config setHasLogin:true];
            
            NSString *fullloginname = [NSString stringWithFormat:@"%@@%@", loginuser, [Config servername]];
            
            //Reconnect with anonymous logindata
            [self connect:fullloginname password:loginPassword];
            
            return;
            
        }
        
        if([body hasPrefix:@"SuicidePreventionAppServerSupporterRequestCallingAccept;"])
        {
            NSArray *mesg = [body componentsSeparatedByString:@";"];
            NSString *supporterString = [mesg objectAtIndex:1];
            
            NSArray *supporterArray = [supporterString componentsSeparatedByString:@"/"];
            NSString *supporter = [supporterArray objectAtIndex:0];
            
            [Config setSupporter:supporter];
            
            [navigationController presentViewController:chatViewController animated:YES completion:NULL];
            
            return;
            
        }
        
        if([body hasPrefix:@"SuicidePreventionAppServerSupporterLoggedInAck"])
        {
            
            [[UIApplication sharedApplication] performSelector:@selector(suspend)];
            
            return;
            
        }
        
        
        if([body hasPrefix:@"SuicidePreventionAppServerSupporterRequestCalling;"])
        {
            
            NSArray *mesg = [body componentsSeparatedByString:@";"];
            NSString *helpSeekerString = [mesg objectAtIndex:1];
            
            NSArray *helpSeekerArray = [helpSeekerString componentsSeparatedByString:@"/"];
            NSString *helpSeeker = [helpSeekerArray objectAtIndex:0];
            
            [Config setHelpSeeker:helpSeeker];
            
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"ino3" ofType:@"wav"]];
            SystemSoundID mRing;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mRing);
            AudioServicesPlaySystemSound(mRing);
            
            //self.avSound =  [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            //[[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
            //[[AVAudioSession sharedInstance]setActive:YES error:nil];
            //[[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
            
            [self.avSound play];
            
            [self.navigationController presentViewController:self.callViewController animated:YES completion:NULL];
            
            
            return;
            
        }
        
        
        NSString *partner = [message fromStr];
        NSArray *jidComponents = [partner componentsSeparatedByString:@"@"];
        NSString *partnerShort = [jidComponents objectAtIndex:0];
        
        [chatViewController appendToTextView:body sender:partnerShort];
        
        
    }
}

- (void)sendChatMessage:(NSString*) text
{
    NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
    [body setStringValue:text];
    
    NSString* chatPartner=nil;
    
    if([Config isHelpSeeker]) chatPartner = [Config supporter];
    else chatPartner = [Config helpSeeker];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:chatPartner];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
}

- (void)sendLoginRequest
{
    NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"SuicidePreventionAppServerLoginRequest"];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[Config serverBotJid]];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
}

- (void)sendSupporterRequest
{
    NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"SuicidePreventionAppServerSupporterRequest"];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[Config serverBotJid]];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
}

- (void)supporterLogin
{
    NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"SuicidePreventionAppServerSupporterLoggedIn"];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[Config serverBotJid]];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
}

- (void)sendDecline
{
    NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
    
    NSString *declineMessage = [NSString stringWithFormat:@"SuicidePreventionAppServerSupporterRequestCallingDecline;%@", [Config helpSeeker]];
    
    [body setStringValue:declineMessage];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[Config serverBotJid]];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
}

- (void)sendAccept
{
    NSXMLElement *body =[NSXMLElement elementWithName:@"body"];
    
    NSString *acceptMessage = [NSString stringWithFormat:@"SuicidePreventionAppServerSupporterRequestCallingAccept;%@", [Config helpSeeker]];
    
    [body setStringValue:acceptMessage];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[Config serverBotJid]];
    [message addChild:body];
    
    [[self xmppStream] sendElement:message];
    
    [navigationController presentViewController:chatViewController animated:YES completion:NULL];
}


- (IBAction)needHelpChat:(id)sender {
    [Config setIsHelpSeeker:true];
    [self connect];
    [self sendLoginRequest];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
