//
//  SettingsViewController.m
//  iPhone
//
//  Created by Marc Landolt jun. on 14.11.14.
//  Copyright (c) 2014 Marc Landolt jun. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "ChatViewController.h"



@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"View Did Load"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    // Do any additional setup after loading the view.
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
- (IBAction)openChat:(id)sender {

    //[self dismissViewControllerAnimated:YES completion:^{
    //    [self presentViewController:[ChatViewController alloc] animated:YES completion:nil];
    //}];
    
    //ChatViewController *chatViewControler = [[ChatViewController alloc]init];
    
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //ChatViewController *chatViewController = appDelegate.chatViewControler;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
    
    [self.navigationController pushViewController:chatViewController animated:YES];
    //[self presentViewController:chatViewControler animated:YES completion:nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Button"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];

}

@end
