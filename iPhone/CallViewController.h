//
//  CallViewController.h
//  iPhoneXMPP
//
//  Created by Marc Landolt jun. on 27.10.14.
//  Copyright (c) 2014 XMPPFramework. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CallViewController : UIViewController

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (IBAction)decline:(id)sender;
- (IBAction)accept:(id)sender;
@end
