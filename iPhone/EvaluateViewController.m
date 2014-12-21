//
//  EvaluateViewController.m
//  iPhone
//
//  Created by Marc Landolt jun. on 22.11.14.
//  Copyright (c) 2014 Marc Landolt jun. All rights reserved.
//

#import "EvaluateViewController.h"
#import "AppDelegate.h"


@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)savedmylife:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate rescued];
}

- (IBAction)improovedSituation:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate helped];

}

- (IBAction)madeItWorse:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate madeworse];
}
@end
