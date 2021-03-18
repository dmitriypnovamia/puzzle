//
//  UIImage+Extension.m
//  PicCross
//
//  Created by iOSAppWorld on 10/24/18.
//  Copyright © 2018 iOSAppWorld. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+(UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat radian = degrees * (M_PI/ 180);
    CGRect contextRect = CGRectMake(0, 0, self.size.width, self.size.height);
    float newSide = MAX([self size].width, [self size].height);
    CGSize newSize =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(newSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint contextCenter = CGPointMake(CGRectGetMidX(contextRect), CGRectGetMidY(contextRect));
    CGContextTranslateCTM(ctx, contextCenter.x, contextCenter.y);
    CGContextRotateCTM(ctx, radian);
    CGContextTranslateCTM(ctx, -contextCenter.x, -contextCenter.y);
    [self drawInRect:contextRect];
    UIImage* rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
    
}

- (UIImage*)horizontalFlip {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef current_context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(current_context, self.size.width, 0);
    CGContextScaleCTM(current_context, -1.0, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *flipped_img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return flipped_img;
}

- (UIImage*)verticalFlip {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef current_context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(current_context, 0, self.size.height);
    CGContextScaleCTM(current_context, 1.0, -1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *flipped_img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return flipped_img;
}

@end
