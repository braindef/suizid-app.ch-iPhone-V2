//
//  ChatViewController.h
//  iPhoneXMPP
//
//  Created by Marc Landolt jun. on 24.10.14.
//  Copyright (c) 2014 XMPPFramework. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHight;



- (IBAction)endChat:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (void) appendToTextView:(NSString*)text sender:(NSString*)sender;

@end
