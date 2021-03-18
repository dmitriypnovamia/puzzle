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

@import GoogleMobileAds;

@interface BaseViewController ()
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:[AdmobIds admonUnitId]];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"2a6596450dcc644bcdd4bc27558b06b8" ];
    [self.interstitial loadRequest:request];
    
    self.scoreView.borderColor = [UIColor groupTableViewBackgroundColor];
    self.scoreView.borderWidth = 3;
    self.scoreView.cornerRadius = 5;
    self.scoreView.maskToBounds = true;
    
    int adFreq = [[NSUserDefaults standardUserDefaults] integerForKey:@"adFreq"];
    
    if (adFreq % 2 == 0){
  
        // Delay execution of my block for 10 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showVideoAds];
        });
        
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:adFreq + 1 forKey:@"adFreq"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Do any additional setup after loading the view.
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    if ([ad isReady] == true){
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"%@",error);
}

- (void)viewWillAppear:(BOOL)animated{
    int pendingCoins  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
    self.pointslable.text = [NSString stringWithFormat:@"%d", pendingCoins];
}

-(IBAction)buyPoints:(id)sender{
    BOOL isProversion   =   [[NSUserDefaults standardUserDefaults ] boolForKey:[InAppIds proVersionId]];
    if(isProversion == false){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoGame" bundle:nil];
        BuyCoinsViewController *purchaseVC = [storyboard instantiateViewControllerWithIdentifier:@"BuyCoinsViewController"];
        [self.navigationController pushFadeViewController:purchaseVC];
    }
}

-(void)showVideoAds{
    BOOL isProversion   =   [[NSUserDefaults standardUserDefaults ] boolForKey:[InAppIds proVersionId]];
    if(isProversion == false){
        
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (self.interstitial.isReady) {
                    [self.interstitial presentFromRootViewController:self];
                } else {
                    NSLog(@"Ad wasn't ready");
                }
            }];
        } else {
            if (self.interstitial.isReady) {
                [self.interstitial presentFromRootViewController:self];
            } else {
                NSLog(@"Ad wasn't ready");
            }
            // Fallback on earlier versions
        }
    }
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

-(void)openCoinsWheel{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoGame" bundle:nil];
    CoinsViewController *coinView = [storyboard instantiateViewControllerWithIdentifier:@"CoinsViewController"];
    [self.navigationController pushFadeViewController:coinView];
}

@end
