//
//  Level.m
//  SpriteKitTest
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "Level.h"
#import "NSArray+transpose.h"

@implementation Level {
    NSMutableArray *cellsArr;
}

- (instancetype)initWithPuzzle:(UIImage *)puzzleImage text:(NSString *)puzzleText{
    self = [super init];
    
    if (self != nil) {
        self.puzzleImage = puzzleImage;
        self.puzzleText = puzzleText;
        self.undoArr = [NSMutableArray new];
        self.redoArr = [NSMutableArray new];
    }
    
    return self;
}

-(NSMutableArray *)getSplitImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns
{
    NSMutableArray *aMutArrImages = [NSMutableArray array];
    CGSize imageSize = image.size;
    CGFloat xPos = 0.0, yPos = 0.0;
    CGFloat width = imageSize.width/rows;
    CGFloat height = imageSize.height/columns;
    for (int aIntY = 0; aIntY < columns; aIntY++)
    {
        NSMutableArray *rowsImagesArr = [NSMutableArray array];

        xPos = 0.0;
        for (int aIntX = 0; aIntX < rows; aIntX++)
        {
            CGRect rect = CGRectMake(xPos, yPos, width, height);
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect);
            
            UIImage *aImgRef = [[UIImage alloc] initWithCGImage:cImage];
   
            [rowsImagesArr addObject:aImgRef];
            xPos += width;
        }
        yPos += height;
        [aMutArrImages addObject:rowsImagesArr];
    }
    return aMutArrImages;
}

- (NSMutableArray *)shuffle:(NSInteger)column row:(NSInteger)row {
    NSMutableArray *set;
    set = [self createInitialCells:column row:row];
    return set;
}

- (Cell *)cellAtColumn:(NSInteger)column row:(NSInteger)row {
    return [[cellsArr objectAtIndex:row] objectAtIndex:column];
}

- (void)swapCells:(Cell *)firstCell secondCell:(Cell *)secondCell {
    NSInteger firstCellRow = firstCell.row;
    NSInteger firstCellColumn = firstCell.column;
    
    NSInteger secondCellColumn = secondCell.column;
    NSInteger secondCellRow = secondCell.row;
    
    secondCell.column = firstCellColumn;
    secondCell.row = firstCellRow;
    
    firstCell.column = secondCellColumn;
    firstCell.row = secondCellRow;
    
    Cell *tempCell = firstCell;
    
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
        //NSArray *reorderedObject    =   tempArr;

        [transposeArr addObject:reorderedObject];
    }
    
    transposeArr = [[transposeArr transpose] mutableCopy];
    
    NSMutableArray *transposeArr1   =   [NSMutableArray new];
    
    for(NSArray *arr1 in transposeArr){
        NSMutableArray *tempArr     =   [[NSMutableArray alloc] initWithArray:arr1];
        
        int rndValue                =   arc4random() % ([tempArr count]);
        NSArray *reorderedObject    =   [self shiftForward:tempArr withbits:rndValue];
       // NSArray *reorderedObject    =   tempArr;

        [transposeArr1 addObject:reorderedObject];
    }
    
    if ([arr isEqualToArray:transposeArr1]){
        transposeArr1   =   [[self createActualData:arr] mutableCopy];
    }

    return transposeArr1;
}

-(NSArray *)generateNumbers:(NSInteger)columns rows:(NSInteger)rows{
    NSMutableArray *rowsValue    =   [NSMutableArray new];

    for(int i = 0; i <rows - 1 ; i++ ){
        NSMutableArray *columnsValue    =   [NSMutableArray new];
        int columnsSum  =   0;
        for(int i = 0; i <columns - 1 ; i++ ){
            int rndValue    =   arc4random() % (5);
            columnsSum      +=  rndValue;
            [columnsValue addObject:[NSNumber numberWithInt:rndValue]];
        }
        [columnsValue addObject:[NSNumber numberWithInt:(10 - columnsSum)]];
        
        [rowsValue addObject:columnsValue];
    }
    
    NSMutableArray *firstColumn =   [rowsValue firstObject];
    NSMutableArray *lastColumn  =   [NSMutableArray new];

    for(int i = 0; i <firstColumn.count ; i++){
        int rowSum  =   0;

        for(NSMutableArray *columns in rowsValue){
            NSNumber *number    =   [columns objectAtIndex:i];
            int value           =   number.intValue;
            rowSum              +=  value;
        }
        
        [lastColumn addObject:[NSNumber numberWithInt:(10 - rowSum)]];
    }
    
    [rowsValue addObject:lastColumn];
    
    return rowsValue;
}

- (NSMutableArray *)createInitialCells:(NSInteger)column row:(NSInteger)row  {
    NSMutableArray *set     =   [NSMutableArray  new];
    
    NSArray *levelArr       =   [self getSplitImagesFromImage:self.puzzleImage withRow:row withColumn:column];
    self.levelArr           =   levelArr;
    
    NSMutableArray *arryWithIndexes =   [NSMutableArray new];
    
    [levelArr enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
        NSMutableArray *outerArr = [NSMutableArray new];
        // Loop through the columns in the current row...
        [array enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger column, BOOL *stop) {
            Cell *cell                  =   [self createCellAtColumn:column row:row withImg:img];
            cell.origionalRowIndex      =   row;
            cell.origionalColumnIndex   =   column;
            [outerArr addObject:cell];
        }];
        [arryWithIndexes addObject:outerArr];
    }];

    NSArray *arryWithIndexesWithShuffle =  [self createActualData:arryWithIndexes];
    
    self.NumColumns         =   [[arryWithIndexesWithShuffle firstObject] count];
    self.NumRows            =   [arryWithIndexesWithShuffle count];
    
    cellsArr                =   [NSMutableArray new];
    
    [arryWithIndexesWithShuffle enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
        NSMutableArray *outerArr = [NSMutableArray new];
        // Loop through the columns in the current row...
        [array enumerateObjectsUsingBlock:^(Cell *cell, NSUInteger column, BOOL *stop) {
            
            Cell *updatedCell                   =   [self createCellAtColumn:column row:row withImg:cell.img];
            updatedCell.origionalColumnIndex    =   cell.origionalColumnIndex;
            updatedCell.origionalRowIndex       =   cell.origionalRowIndex;
            
            [set addObject:updatedCell];
            [outerArr addObject:updatedCell];
        }];
        [cellsArr addObject:outerArr];
    }];
    
    return set;
}

- (Cell *)createUpdatedCellAtColumn:(NSInteger)column row:(NSInteger)row withImg:(UIImage*)img {
    Cell *cell         =   [[Cell alloc] init];
    cell.img           =   img;
    cell.column         =   column;
    cell.row            =   row;
    // _cells[column][row] =   cell;
    
    NSMutableArray *outerArr = [cellsArr  objectAtIndex:row];
    [outerArr replaceObjectAtIndex:column withObject:cell];
    
    [cellsArr replaceObjectAtIndex:row withObject:outerArr];
    
    return cell;
}

- (Cell *)createCellAtColumn:(NSInteger)column row:(NSInteger)row withImg:(UIImage*)img {
    Cell *cell         =   [[Cell alloc] init];
    cell.img           =   img;
    cell.column         =   column;
    cell.row            =   row;
    // _cells[column][row] =   cell;
    return cell;
}

@end

