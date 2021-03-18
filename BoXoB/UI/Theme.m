//
//  Theme.m
//  ExtendedTableView
//
//  Created by iOSAppWorld on 5/8/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (id)sharedManager {
    static Theme *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(NSString *)themeName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"themeEnabled"];
}

//-(UIImage *)startScreenBgImage{
//    if ([[self themeName] isEqualToString:@"light"]){
//
//    }
//    else if  ([[self themeName] isEqualToString:@"dark"]){
//
//    }
//    else if  ([[self themeName] isEqualToString:@"gold"]){
//
//    }
//}

-(UIColor *)themeColor{
    if ([[self themeName] isEqualToString:@"light"]){
        return [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    }
    else if  ([[self themeName] isEqualToString:@"dark"]){
        return [UIColor colorWithRed:50.0/255.0 green:53.0/255.0 blue:63.0/255.0 alpha:1.0];
    }
    else if  ([[self themeName] isEqualToString:@"gold"]){
        return [UIColor colorWithRed:223/255.0 green:249/255.0 blue:251/255.0 alpha:1.0];
    }
    return [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
}

-(UIColor *)gridColor{
    if ([[self themeName] isEqualToString:@"light"]){
        return [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    }
    else if  ([[self themeName] isEqualToString:@"dark"]){
        return [UIColor colorWithRed:50.0/255.0 green:53.0/255.0 blue:63.0/255.0 alpha:1.0];
    }
    else if  ([[self themeName] isEqualToString:@"gold"]){
        return [UIColor colorWithRed:223/255.0 green:249/255.0 blue:251/255.0 alpha:1.0];
    }
    return [UIColor whiteColor];
}

-(UIColor *)gridLabelColor{
    if ([[self themeName] isEqualToString:@"light"]){
        return [UIColor colorWithRed:61.0/255.0 green:58.0/255.0 blue:102.0/255.0 alpha:1];
    }
    else if  ([[self themeName] isEqualToString:@"dark"]){
        return [UIColor colorWithRed:61.0/255.0 green:62.0/255.0 blue:91.0/255.0 alpha:0.8];
    }
    else if  ([[self themeName] isEqualToString:@"gold"]){
        return [UIColor colorWithRed:50.0/255.0 green:53.0/255.0 blue:63.0/255.0 alpha:1.0];

    }
    return [UIColor whiteColor];

}

-(UIColor *)gridShadowColor{
    if ([[self themeName] isEqualToString:@"light"]){
        return [UIColor blackColor];
    }
    else if  ([[self themeName] isEqualToString:@"dark"]){
        return [UIColor blackColor];
    }
    else if  ([[self themeName] isEqualToString:@"gold"]){
        return [UIColor blackColor];
    }
    return [UIColor blackColor];

}

-(UIColor *)btnsTitleColor{
    //if ([[self themeName] isEqualToString:@"light"]){
    return [UIColor colorWithRed:85.0/255.0 green:54.0/255.0 blue:150.0/255.0 alpha:1];
}

-(UIColor *)btnsTintColor{
    
    //if ([[self themeName] isEqualToString:@"light"]){
        return [UIColor groupTableViewBackgroundColor];
//    }
//    else if  ([[self themeName] isEqualToString:@"dark"]){
//        return [UIColor whiteColor];
//    }
//    else if  ([[self themeName] isEqualToString:@"gold"]){
//        return [self gridLabelColor];
//    }
    return [UIColor darkGrayColor];
    
//    if ([[self themeName] isEqualToString:@"light"]){
//        return [UIColor colorWithRed:105.0/255.0 green:70.0/255.0  blue:179.0/255.0  alpha:1.0];
//    }
//    else if  ([[self themeName] isEqualToString:@"dark"]){
//        return [UIColor colorWithRed:92.0/255.0 green:248.0/255.0  blue:212.0/255.0  alpha:1.0];
//    }
//    else if  ([[self themeName] isEqualToString:@"gold"]){
//        return [UIColor colorWithRed:50.0/255.0 green:53.0/255.0 blue:63.0/255.0 alpha:1.0];
//    }
//    return [UIColor blackColor];
    
}

-(UIColor *)gridTextColor{
    if ([[self themeName] isEqualToString:@"light"]){
        return [UIColor colorWithRed:61.0/255.0 green:58.0/255.0 blue:102.0/255.0 alpha:1];
    }
    else if  ([[self themeName] isEqualToString:@"dark"]){
        return [UIColor whiteColor];
    }
    else if  ([[self themeName] isEqualToString:@"gold"]){
        return [UIColor whiteColor];
    }
    return [UIColor darkGrayColor];

}

//-(UIColor *)btnsTintColor{
//    if ([[self themeName] isEqualToString:@"light"]){
//
//    }
//    else if  ([[self themeName] isEqualToString:@"dark"]){
//
//    }
//    else if  ([[self themeName] isEqualToString:@"gold"]){
//
//    }
//}

@end
