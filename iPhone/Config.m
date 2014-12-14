//
//  Config.m
//  iPhoneXMPP
//
//  Created by Marc Landolt jun. on 25.10.14.
//  Copyright (c) 2014 XMPPFramework. All rights reserved.
//

#import "Config.h"

@implementation Config
{

}

static NSString *servername=@"suizid-ap.ch";

static NSString *username=nil;
static NSString *password=nil;

static NSString *managementUser=@"management@suizid-app.ch";
static NSString *managementPassword=@"password";

static NSString *serverBotJid=@"server@suizid-app.ch";

static NSString *supporter = nil;
static NSString *helpSeeker = nil;

static bool *isSupporter=false;
static bool *isHelpSeeker=false;
static bool *hasLogin=false;


+ (NSString*)servername { return servername; }
+ (void)setServername: (NSString*)newServername { servername = newServername; }

+ (NSString*)username { return username; }
+ (void)setUsername: (NSString*)newUsername { username = newUsername; }

+ (NSString*)password { return password; }
+ (void)setPassword: (NSString*)newPassword { password = newPassword; }

+ (NSString *)managementUser { return managementUser; }
+ (void)setManagementUser: (NSString*)newManagementUser { managementUser = newManagementUser; }

+ (NSString *)managementPassword { return managementPassword; }
+ (void)setManagementPassword: (NSString*)newManagementPassword { managementPassword = newManagementPassword; }

+ (NSString *)serverBotJid { return serverBotJid; }
+ (void)setServerBotJid: (NSString*)newServerBotJid { serverBotJid = newServerBotJid; }

+ (NSString *)supporter { return supporter; }
+ (void)setSupporter: (NSString*)newSupporter { supporter = newSupporter; }

+ (NSString *)helpSeeker { return helpSeeker; }
+ (void)setHelpSeeker: (NSString*)newHelpSeeker { helpSeeker = newHelpSeeker; }

+ (BOOL *)isSupporter {return isSupporter; }
+ (void)setIsSupporter: (BOOL*)newIsSupporter { isSupporter = newIsSupporter; }

+ (BOOL *)isHelpSeeker { return isHelpSeeker; }
+ (void)setIsHelpSeeker: (BOOL*)newIsHelpSeeker { isHelpSeeker = newIsHelpSeeker; }

+ (BOOL *)hasLogin { return hasLogin; }
+ (void)setHasLogin: (BOOL*)newHasLogin { hasLogin = newHasLogin; }

@end


