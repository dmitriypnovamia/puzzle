//
//  Level.h
//  SpriteKitTest
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

//static const NSInteger NumColumns = 9;
//static const NSInteger NumRows = 9;

@interface Level : NSObject
@property (nonatomic,strong) UIImage * puzzleImage;
@property (nonatomic,strong) NSString * puzzleText;

@property(nonatomic,assign) NSInteger NumColumns;
@property(nonatomic,assign) NSInteger NumRows;
@property(nonatomic,retain) NSMutableArray *emptyTiles;
@property(nonatomic,retain) NSArray *levelArr;

@property(nonatomic,retain) NSMutableArray *undoArr;
@property(nonatomic,retain) NSMutableArray *redoArr;

- (Cell *)cellAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)swapCells:(Cell *)firstCell secondCell:(Cell *)secondCell;
-(NSMutableArray *)shuffle:(NSInteger)column row:(NSInteger)row ;
- (instancetype)initWithPuzzle:(UIImage *)puzzleImage text:(NSString *)puzzleText;
- (Cell *)createCellAtColumn:(NSInteger)column row:(NSInteger)row withImg:(UIImage*)img ;
- (Cell *)createUpdatedCellAtColumn:(NSInteger)column row:(NSInteger)row withImg:(UIImage*)img;
- (NSMutableArray *)createInitialCells:(NSInteger)column row:(NSInteger)row;
@end
