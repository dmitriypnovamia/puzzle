//
//  Cells.h
//  SpriteKitTest
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

@import SpriteKit;

@interface Cell : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;

@property (assign, nonatomic) NSInteger origionalRowIndex;
@property (assign, nonatomic) NSInteger origionalColumnIndex;

@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) UILabel   *sprite;

@property(nonatomic) int currentAngle;
@property(nonatomic) CGAffineTransform currentTransform;

@property(nonatomic) int d;
@property(nonatomic) int a;

@end
