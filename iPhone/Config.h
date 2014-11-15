//
//  Config.h
//  iPhoneXMPP
//
//  Created by Marc Landolt jun. on 25.10.14.
//  Copyright (c) 2014 XMPPFramework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
{
    
}

+ (NSString*)servername;
+ (void)setServername: (NSString*)newServername;

+ (NSString*)username;
+ (void)setUsername: (NSString*)newUsername;

+ (NSString *)password;
+ (void)setPassword: (NSString*)newPassword;

+ (NSString *)managementUser;
+ (void)setManagementUser: (NSString*)newManagementUser;

+ (NSString *)managementPassword;
+ (void)setManagementPassword: (NSString*)newManagementPassword;

+ (NSString *)serverBotJid;
+ (void)setServerBotJid: (NSString*)newServerBotJid;

+ (NSString *)supporter;
+ (void)setSupporter: (NSString*)newSupporter;

+ (NSString *)helpSeeker;
+ (void)setHelpSeeker: (NSString*)newHelpSeeker;

+ (BOOL *)isSupporter;
+ (void)setIsSupporter: (BOOL*)newIsSupporter;

+ (BOOL *)isHelpSeeker;
+ (void)setIsHelpSeeker: (BOOL*)newIsHelpSeeker;

+ (BOOL *)hasLogin;
+ (void)setHasLogin: (BOOL*)newHasLogin;


@end
