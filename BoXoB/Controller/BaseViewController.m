//
//  BaseViewController.m
//  PicCross
//
//  Created by apple on 12/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

#import "BaseViewController.h"
#import "BoXoB-Swift.h"
#import "UINavigationController+Fade.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.scoreView.borderColor = [UIColor groupTableViewBackgroundColor];
    self.scoreView.borderWidth = 3;
    self.scoreView.cornerRadius = 5;
    self.scoreView.maskToBounds = true;
    
    int adFreq = [[NSUserDefaults standardUserDefaults] integerForKey:@"adFreq"];
    
    if (adFreq % 2 == 0){
  
        // Delay execution of my block for 10 seconds.
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [self showVideoAds];
//        });
        
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:adFreq + 1 forKey:@"adFreq"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    int pendingCoins  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
    self.pointslable.text = [NSString stringWithFormat:@"%d", pendingCoins];
}

-(void)addHints:(int)hints{
    BOOL isProversion   =   [[NSUserDefaults standardUserDefaults ] boolForKey:[InAppIds proVersionId]];
    int pendingCoins  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];

    if(isProversion == false && pendingCoins + hints > 0){
        [[NSUserDefaults standardUserDefaults] setInteger:pendingCoins + hints forKey:@"coins"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.pointslable.text = [NSString stringWithFormat:@"%d", pendingCoins + hints];
    }
}

@end
