//
//  Theme.h
//  ExtendedTableView
//
//  Created by iOSAppWorld on 5/8/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Theme : NSObject

+ (id)sharedManager;
-(UIImage *)startScreenBgImage;
-(UIColor *)themeColor;
-(UIColor *)gridColor;
-(UIColor *)gridLabelColor;
-(UIColor *)gridTextColor;
-(UIColor *)gridShadowColor;
-(UIColor *)btnsTintColor;
-(UIColor *)btnsTitleColor;

@end
