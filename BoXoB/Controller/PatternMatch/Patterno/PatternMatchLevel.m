//
//  Level.m
//  SpriteKitTest
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "PatternMatchLevel.h"
#import "PatternMatchTile.h"
#import "NSArray+transpose.h"

@implementation PatternMatchLevel {
    NSMutableArray *cellsArr;
    //    Cells *_cells[NumColumns][NumRows];
    //    Tile *_tiles[NumColumns][NumRows];
}

- (instancetype)initWithFile:(NSString *)filename{
    self = [super init];
    
    if (self != nil) {
        self.undoArr = [NSMutableArray new];
        self.redoArr = [NSMutableArray new];
    }
    
    self.levelFile = filename;
    return self;
}

- (NSArray *)loadJSON:(NSString *)filename {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path == nil) {
        NSLog(@"Could not find level file: %@", filename);
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", filename, error);
        return nil;
    }
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (array == nil || ![array isKindOfClass:[NSArray class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
        return nil;
    }
    
    return array;
}

- (NSSet *)shuffle:(NSUInteger)at {
    NSSet *set;
    set = [self createInitialCells:at];
    return set;
}

-(void)loadTiles{
    
    for (NSInteger row = 0; row < self.NumRows; row++) {
        for (NSInteger column = 0; column < self.NumRows; column++) {
            //[_emptyTiles addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:column],[NSNumber numberWithInteger:row], nil]];
        }
    }
}

- (PatternMatchCell *)cellAtColumn:(NSInteger)column row:(NSInteger)row {
    // NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    // NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return [[cellsArr objectAtIndex:row] objectAtIndex:column];
    //return _cells[column][row];
}

- (void)swapCells:(PatternMatchCell *)firstCell secondCell:(PatternMatchCell *)secondCell {
    NSInteger firstCellRow = firstCell.row;
    NSInteger firstCellColumn = firstCell.column;
    
    NSInteger secondCellColumn = secondCell.column;
    NSInteger secondCellRow = secondCell.row;
    
    secondCell.column = firstCellColumn;
    secondCell.row = firstCellRow;
    
    firstCell.column = secondCellColumn;
    firstCell.row = secondCellRow;
    

    PatternMatchCell *tempCell = firstCell;
    
    NSMutableArray *innerCellsArr = [cellsArr objectAtIndex:firstCellRow];
    [innerCellsArr replaceObjectAtIndex:firstCellColumn withObject:secondCell];
    [cellsArr replaceObjectAtIndex:firstCellRow withObject:innerCellsArr];
    
    NSMutableArray *innerCellsArr1 = [cellsArr objectAtIndex:secondCellRow];
    [innerCellsArr1 replaceObjectAtIndex:secondCellColumn withObject:tempCell];
    [cellsArr replaceObjectAtIndex:secondCellRow withObject:innerCellsArr1];
    
}

-(NSArray*)shiftForward :(NSArray *)data withbits:(int)bit
{
    NSInteger length = [data count];
    NSArray *right;
    NSArray *left;
    
    right = [data subarrayWithRange:(NSRange){ .location = length - bit, .length = bit }];
    left = [data subarrayWithRange:(NSRange){ .location = 0, .length = length - bit}];
    return [right arrayByAddingObjectsFromArray:left];
}

-(NSArray *)createActualData:(NSArray *)arr{
    NSMutableArray *transposeArr = [NSMutableArray new];
    
    arr = [[arr transpose] mutableCopy];
    for(NSArray *arr1 in arr){
        NSMutableArray *tempArr     =   [[NSMutableArray alloc]initWithArray:arr1];
        
        int rndValue                =   arc4random() % ([tempArr count]);
        NSArray *reorderedObject    =   [self shiftForward:tempArr withbits:rndValue];
        [transposeArr addObject:reorderedObject];
    }
    
    transposeArr = [[transposeArr transpose] mutableCopy];
    
    NSMutableArray *transposeArr1   =   [NSMutableArray new];
    
    for(NSArray *arr1 in transposeArr){
        NSMutableArray *tempArr     =   [[NSMutableArray alloc] initWithArray:arr1];
        
        int rndValue                =   arc4random() % ([tempArr count]);
        NSArray *reorderedObject    =   [self shiftForward:tempArr withbits:rndValue];
        [transposeArr1 addObject:reorderedObject];
    }
    
    if ([arr isEqualToArray:transposeArr1]){
        transposeArr1   =   [[self createActualData:arr] mutableCopy];
    }

    return transposeArr1;
}

- (NSSet *)createInitialCells:(NSUInteger)at {
    NSMutableSet *set       =   [NSMutableSet set];
    //NSArray *object     =   _emptyTiles.count == 0 ? nil : _emptyTiles[arc4random() % (_emptyTiles.count)];
    
    NSArray *tempArray1     =   [self loadJSON:self.levelFile];
    NSArray *levelArr       =   [tempArray1 objectAtIndex: at];
    self.levelArr           =   levelArr;
    
    NSMutableArray *arryWithIndexes =   [NSMutableArray new];
    
    [levelArr enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
        NSMutableArray *outerArr = [NSMutableArray new];
        // Loop through the columns in the current row...
        [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
            //NSString *string    =   [self randomStringWithLength];
            
            PatternMatchCell *cell                  =   [self createCellAtColumn:column row:row withText:[value integerValue]];
            cell.origionalRowIndex      =   row;
            cell.origionalColumnIndex   =   column;
            
            NSLog(@"cell text == %ld cell row == %ld cell columc == %ld", cell.type,cell.origionalRowIndex,cell.origionalColumnIndex);
            
            //[set addObject:cell];
            [outerArr addObject:cell];
        }];
        [arryWithIndexes addObject:outerArr];
    }];
    
    NSArray *arryWithIndexesWithShuffle =  [self createActualData:arryWithIndexes];
    //    NSArray *array          =   levelArr;
    
    self.NumColumns         =   [[arryWithIndexesWithShuffle firstObject] count];
    self.NumRows            =   [arryWithIndexesWithShuffle count];
    
    // self.levelArr = array;
    // Loop through the rows...
    cellsArr                =   [NSMutableArray new];
    
    [arryWithIndexesWithShuffle enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
        NSMutableArray *outerArr = [NSMutableArray new];
        // Loop through the columns in the current row...
        [array enumerateObjectsUsingBlock:^(PatternMatchCell *cell, NSUInteger column, BOOL *stop) {
            //NSString *string    =   [self randomStringWithLength];
            
            NSLog(@"cell text == %ld cell row == %ld cell columc == %ld", cell.type,cell.origionalRowIndex,cell.origionalColumnIndex);
            
            PatternMatchCell *updatedCell                   =   [self createCellAtColumn:column row:row withText:cell.type];
            updatedCell.origionalColumnIndex    =   cell.origionalColumnIndex;
            updatedCell.origionalRowIndex       =   cell.origionalRowIndex;
            
            [set addObject:updatedCell];
            [outerArr addObject:updatedCell];
        }];
        [cellsArr addObject:outerArr];
    }];
    
    return set;
}

-(NSString *)randomStringWithLength {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 1];
    for (int i=0; i<1; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (PatternMatchCell *)createUpdatedCellAtColumn:(NSInteger)column row:(NSInteger)row withText:(NSUInteger)text {
    PatternMatchCell *cell  =   [[PatternMatchCell alloc] init];
    cell.type           =   text;
    cell.column         =   column;
    cell.row            =   row;
    // _cells[column][row] =   cell;
    
    NSMutableArray *outerArr = [cellsArr  objectAtIndex:row];
    [outerArr replaceObjectAtIndex:column withObject:cell];
    [cellsArr replaceObjectAtIndex:row withObject:outerArr];
    
    return cell;
}

- (PatternMatchCell *)createCellAtColumn:(NSInteger)column row:(NSInteger)row withText:(NSUInteger)text {
    PatternMatchCell *cell         =   [[PatternMatchCell alloc] init];
    cell.type           =   text;
    cell.column         =   column;
    cell.row            =   row;
    // _cells[column][row] =   cell;
    return cell;
}

@end
