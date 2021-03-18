//
//  Level.h
//  SpriteKitTest
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatternMatchCell.h"
#import "PatternMatchTile.h"

//static const NSInteger NumColumns = 9;
//static const NSInteger NumRows = 9;

@interface PatternMatchLevel : NSObject

@property(nonatomic,assign) NSUInteger NumColumns;
@property(nonatomic,assign) NSUInteger NumRows;
@property(nonatomic,retain) NSMutableArray *emptyTiles;
@property(nonatomic,retain) NSString *levelFile;
@property(nonatomic,retain) NSArray *levelArr;
@property(nonatomic,retain) NSArray *levelOrigionalArr;

@property(nonatomic,retain) NSMutableArray *undoArr;
@property(nonatomic,retain) NSMutableArray *redoArr;

- (PatternMatchCell *)cellAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)swapCells:(PatternMatchCell *)firstCell secondCell:(PatternMatchCell *)secondCell;

-(NSSet *)shuffle:(NSUInteger)at ;
- (void)loadTiles;
- (instancetype)initWithFile:(NSString *)filename;
- (PatternMatchCell *)createCellAtColumn:(NSInteger)column row:(NSInteger)row withText:(NSUInteger)text ;
- (PatternMatchCell *)createUpdatedCellAtColumn:(NSInteger)column row:(NSInteger)row withText:(NSUInteger)text;
- (NSSet *)createInitialCells:(NSUInteger)at;
@end
