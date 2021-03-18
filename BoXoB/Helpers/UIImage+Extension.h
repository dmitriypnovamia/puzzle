//
//  UIImage+Extension.h
//  PicCross
//
//  Created by iOSAppWorld on 10/24/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees ;
- (UIImage*)horizontalFlip;
- (UIImage*)verticalFlip;
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end
