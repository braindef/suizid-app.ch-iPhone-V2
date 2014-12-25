//
//  ChatViewController.m
//  iPhoneXMPP
//
//  Created by Marc Landolt jun. on 24.10.14.
//  Copyright (c) 2014 XMPPFramework. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "Config.h"

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [message becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    
    CGFloat height = keyboardFrame.size.height;
    
    if(!isPortrait)
    {
        height = keyboardFrame.size.width;
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
        //                                                    message:@"not portrait"
        //                                                   delegate:nil
        //                                          cancelButtonTitle:@"Ok"
        //                                          otherButtonTitles:nil];
        //[alertView show];
    }
    self.keyboardHight.constant = height;
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHight.constant = 0;
}

- (void)orientationChanged:(NSNotification *)notification{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self.view endEditing:YES];
}



- (IBAction)endChat:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self.view endEditing:YES];

    
    //send message to the xmpp service
    if ([Config isSupporter]&&![Config helpSeeker]) {
        [appDelegate sendChatMessage:@"Disconnected, if you feel bad contact us again"];
        appDelegate.window.rootViewController = appDelegate.rootViewController;
        
    }
    else
    {
    [appDelegate sendChatMessage:@"Disconnected, bye"];
    appDelegate.window.rootViewController = appDelegate.evaluateViewController;
    }
        [Config setInSession:false];
}


- (IBAction)sendMessage:(id)sender {
    
    NSString* input = message.text;
    [self appendToTextView:input sender:@"me"];
    
    [message setText:@""];
    
    //send message to the xmpp service
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate sendChatMessage:input];
}


- (void) appendToTextView:(NSString*)text sender:(NSString*)sender
{
    //append
    self.chatTextView.text=[NSString stringWithFormat:@"%@\n%@: %@", self.chatTextView.text, sender, text];
    
    //scroll
    NSRange range = NSMakeRange(self.chatTextView.text.length -1, 1);
    [self.chatTextView scrollRangeToVisible:range];
}


@synthesize message;

@end
