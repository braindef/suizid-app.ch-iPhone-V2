//
//  ViewController.m
//  iPhone
//
//  Created by Marc Landolt jun. on 14.11.14.
//  Copyright (c) 2014 Marc Landolt jun. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"



@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
    //                                                    message:@"View Did Load"
    //                                                   delegate:nil
    //                                     cancelButtonTitle:@"Ok"
    //                                          otherButtonTitles:nil];
    //[alertView show];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tempCall:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate tempCall];
    
}
@end
