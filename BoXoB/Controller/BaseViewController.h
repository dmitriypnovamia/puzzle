//
//  BaseViewController.h
//  PicCross
//
//  Created by apple on 12/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property(nonatomic,strong) IBOutlet UILabel *pointslable;
@property (weak, nonatomic) IBOutlet UIView *scoreView;

//-(void)showVideoAds;
-(void)addHints:(int)hints;
-(void)openCoinsWheel;

@end

NS_ASSUME_NONNULL_END
