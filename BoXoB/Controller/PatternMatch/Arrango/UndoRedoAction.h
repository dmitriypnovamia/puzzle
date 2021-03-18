//
//  UndoRedoAction.h
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 07/07/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatternMatchCell.h"
@interface UndoRedoAction : NSObject

@property(nonatomic,retain) PatternMatchCell *cell;
@property(nonatomic) int direction;

@end
