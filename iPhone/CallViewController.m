//
//  CallViewController.m
//  iPhoneXMPP
//
//  Created by Marc Landolt jun. on 27.10.14.
//  Copyright (c) 2014 XMPPFramework. All rights reserved.
//

#import "CallViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface CallViewController ()

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)decline:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [appDelegate sendDecline];
}

- (IBAction)accept:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [appDelegate sendAccept];
    
    
    
    //ChatViewController *cvc = [[ChatViewController alloc]init];
    ChatViewController *cvc = appDelegate.chatViewController;
    
    [[appDelegate navigationController]pushViewController:cvc animated:true ];
}
@end
