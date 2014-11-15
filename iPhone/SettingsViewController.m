//
//  SettingsViewController.m
//  iPhoneXMPP
//
//  Created by Eric Chamberlain on 3/18/11.
//  Copyright 2011 RF.com. All rights reserved.
//
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "ChatViewController.h"


NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";


@implementation SettingsViewController

@synthesize jidField;
@synthesize passwordField;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init/dealloc methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib {
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    jidField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)done:(id)sender
{
    [self setField:jidField forKey:kXMPPmyJID];
    [self setField:passwordField forKey:kXMPPmyPassword];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    
    [self.navigationController pushViewController:chatViewController animated:YES];
    //[self presentViewController:chatViewControler animated:YES completion:nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Button"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
}

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
    [self done:sender];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Getter/setter methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





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
- (IBAction)openChat:(id)sender {

    //[self dismissViewControllerAnimated:YES completion:^{
    //    [self presentViewController:[ChatViewController alloc] animated:YES completion:nil];
    //}];
    
    //ChatViewController *chatViewControler = [[ChatViewController alloc]init];
    
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //ChatViewController *chatViewController = appDelegate.chatViewControler;
    


}

@end
