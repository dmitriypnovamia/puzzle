//
//  Cells.h
//  SpriteKitTest
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "PatternMatchTile.h"
#import <UIKit/UIKit.h>
@interface PatternMatchCell : NSObject

@property (assign, nonatomic) PatternMatchTile      *tile;
@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;

@property (assign, nonatomic) NSInteger origionalRowIndex;
@property (assign, nonatomic) NSInteger origionalColumnIndex;

@property (assign, nonatomic) NSUInteger type;
@property (strong, nonatomic) UILabel   *sprite;

@end
