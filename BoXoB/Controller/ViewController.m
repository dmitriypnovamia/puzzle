//
//  ViewController.m
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "ViewController.h"
#import "Level.h"
#import "NSArray+transpose.h"
#import "BoXoB-Swift.h"
#import "UINavigationController+Fade.h"

@interface ViewController ()

@property(nonatomic,retain) IBOutlet CheerView *confetiView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    
    [self beginGame];
    [self applyTheme];
}

-(void)dummyIncreaseLevel{
    NSUInteger levelNumberForStage  =   [[NSUserDefaults standardUserDefaults] integerForKey:self.stage];
    NSUInteger overAllLevelNumber  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"picCross_levelNumber"];
    
    if (self.levelNumber > levelNumberForStage){
        [[NSUserDefaults standardUserDefaults] setInteger:overAllLevelNumber + 1 forKey:@"picCross_levelNumber"];
        [[NSUserDefaults standardUserDefaults] setInteger:levelNumberForStage + 1 forKey:self.stage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)beginGame{
    [self.confetiView stop];
    self.confetiView.hidden = true;
    self.levelCompleteView.hidden = true;

    for(UIImageView *view in _gameLayer.subviews){
        //if ([view isKindOfClass:[UIImageView class]]){
        [view removeFromSuperview];
        //}
    }
    
    if (self.dailyPuzzle == true){
        self.nextLabel.text      =   @"Back";
        self.levelNumberLbl.text      =   @"Daily Puzzle";
        
        NSMutableArray *viewCons = self.navigationController.viewControllers.mutableCopy;
        [viewCons removeObjectAtIndex:viewCons.count - 2];
        self.navigationController.viewControllers = viewCons;
        [self startAfterImageLoad];

    }
    else if (self.cameraPicPuzzle == true){
        [self startAfterImageLoad];
    }
    else{
        self.levelNumberLbl.text      =   [NSString stringWithFormat:@"Level: %lu",(unsigned long)self.levelNumber];
        self.puzzleImage = [UIImage imageNamed:[NSString stringWithFormat:@"%lu",(unsigned long)self.levelNumber]];
        
        if (self.puzzleImage == nil){
            self.puzzleImage = [self loadimage];
            
            if (self.puzzleImage == nil){
                // load from firebase
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [appDelegate downloadImageWithLevelNumber:self.levelNumber success:^(UIImage * _Nonnull image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.puzzleImage = image;
                        [self startAfterImageLoad];
                    });
                }];
            }
            else{
                [self startAfterImageLoad];
            }
        }
        else{
            [self startAfterImageLoad];
        }
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(UIImage *)loadimage{
    NSString *workSpacePath=[[self applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)self.levelNumber]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
    
    return image;
}

-(void)startAfterImageLoad{
    self.gameLayer.userInteractionEnabled   =   true;
    //hideNumbering           =   true;
    self.hintBtn.enabled    =   true;
    
    
    self.level              =   [[Level alloc] initWithPuzzle:self.puzzleImage text:self.puzzleText];
    self.level.emptyTiles   =   [NSMutableArray new];
    
    NSMutableArray *newCells    =   [self.level shuffle:self.gridSize row:self.gridSize];
    
    tileWidth   =   [UIScreen mainScreen].bounds.size.width/(self.level.NumColumns);
    tileHeight  =   tileWidth;
    
    _gameLayer.frame  =  CGRectMake(0, self.view.frame.size.height - ((self.level.NumRows)*tileHeight) - (tileHeight * 1.5), (self.level.NumColumns )*tileWidth, (self.level.NumRows)*tileHeight);
    _gameLayer.center   =   CGPointMake(_gameLayer.center.x , self.view.center.y + 20);
    _gameLayer.backgroundColor = [UIColor whiteColor];
    _gameLayer.layer.borderWidth = 4;
    //_gameLayer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.gameLayer.clipsToBounds    =   true;
    //    [self.view addSubview:_gameLayer];
    self.hintBtn.frame = CGRectMake(self.view.frame.size.width - 75, _gameLayer.frame.origin.y + _gameLayer.frame.size.height + 25, 50, 50);
    //[self.hintBtn setBackgroundImage:[UIImage imageNamed:@"btnThemeImg"] forState:UIControlStateNormal];
    
    [self addSpritesForCells:newCells];
}

- (void)addSpritesForCells:(NSMutableArray *)cells {
    NSMutableArray *allAddedCells = [NSMutableArray new];
    for (Cell *cell in cells) {
        CellLabel *textCell = [self createCell:cell];
        [allAddedCells addObject:textCell];
        [self.gameLayer addSubview:textCell];
        
        int rndValue = arc4random() % 3;

        [self animateField:textCell withAnimationType:rndValue withDuration:0];
    }
}

- (void)updateSpritesForCells:(NSMutableArray *)cells withAnimation:(int)animationType{
    for (Cell *cell in cells) {
        CellLabel *textCell = [self createCell:cell];
        [self.gameLayer addSubview:textCell];
        [self animateField:textCell withAnimationType:animationType withDuration:0.5];
    }
}

-(void)animateField:(CellLabel *)lbl withAnimationType:(int)animationType withDuration:(float)duration{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setType:kCATransitionPush];
    
    if(animationType == 0)
        [animation setSubtype:kCATransitionFromLeft];
    if(animationType == 1)
        [animation setSubtype:kCATransitionFromRight];
    if(animationType == 2)
        [animation setSubtype:kCATransitionFromTop];
    if(animationType == 3)
        [animation setSubtype:kCATransitionFromBottom];
    
    [animation setTimingFunction:[CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionDefault]];
    
    [[lbl layer] addAnimation:animation forKey:nil];
}

-(CellLabel *)createCell:(Cell *)cell{
    NSString *cellNumbering         =   [NSString stringWithFormat:@"%ld%ld",(long)cell.origionalRowIndex,(long)cell.origionalColumnIndex];
    CGPoint origin                  =   [self pointForColumn:cell.column row:cell.row];

    CellLabel *textCell             =   [[CellLabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, tileWidth, tileHeight) img:cell.img cellNumbering:cellNumbering hideNumbering:true isResult:NO cell:cell];

    
    UISwipeGestureRecognizer    *leftSwipegesture   =   [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipegesture.direction  =   UISwipeGestureRecognizerDirectionLeft;
    
    [textCell addGestureRecognizer:leftSwipegesture];
    
    UISwipeGestureRecognizer    *rightSwipegesture   =   [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipegesture.direction  =   UISwipeGestureRecognizerDirectionRight;
    
    [textCell addGestureRecognizer:rightSwipegesture];
    
    UISwipeGestureRecognizer    *upSwipegesture     =   [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    upSwipegesture.direction  =   UISwipeGestureRecognizerDirectionUp;
    
    [textCell addGestureRecognizer:upSwipegesture];
    
    UISwipeGestureRecognizer    *downSwipegesture   =   [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    downSwipegesture.direction  =   UISwipeGestureRecognizerDirectionDown;
    
    [textCell addGestureRecognizer:downSwipegesture];
    
    cell.sprite             =   textCell;
    textCell.cell           =   cell;
    
    return textCell;
}

-(CellLabel *)createResultCell:(Cell *)cell{
    NSString *cellNumbering         =   [NSString stringWithFormat:@"%ld%ld",(long)cell.origionalRowIndex,(long)cell.origionalColumnIndex];
    CGPoint origin                  =   [self pointForColumn:cell.column row:cell.row];
    
    CellLabel *textCell             =   [[CellLabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, tileWidth, tileHeight) img:cell.img cellNumbering:cellNumbering hideNumbering:YES isResult:YES cell:cell];

    cell.sprite             =   textCell;
    textCell.cell           =   cell;
    
    return textCell;
}

-(void)randomAnimation{
    int rndValue  =   arc4random() % 4;
    int rndValue1  =   arc4random() % self.level.NumColumns;
    int rndValue2  =   arc4random() % self.level.NumRows;

    Cell *lastCell =   [self.level cellAtColumn:rndValue1 row:rndValue2];

    if(rndValue == 0)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:2 isFromUndoRedo:false];
        NSMutableDictionary *obj = [NSMutableDictionary new];
        [obj setObject:@3 forKey:@"direction"];
        [obj setObject:lastCell forKey:@"cell"];

        [randomAnimations addObject:obj];
    }
    else if(rndValue == 1)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:3 isFromUndoRedo:false];
        
        NSMutableDictionary *obj = [NSMutableDictionary new];
        [obj setObject:@2 forKey:@"direction"];
        [obj setObject:lastCell forKey:@"cell"];
        
        [randomAnimations addObject:obj];
    }
    else if(rndValue == 2)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:1 isFromUndoRedo:false];

        NSMutableDictionary *obj = [NSMutableDictionary new];
        [obj setObject:@0 forKey:@"direction"];
        [obj setObject:lastCell forKey:@"cell"];
        
        [randomAnimations addObject:obj];

    }
    else if(rndValue == 3)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:0 isFromUndoRedo:false];
        NSMutableDictionary *obj = [NSMutableDictionary new];
        [obj setObject:@1 forKey:@"direction"];
        [obj setObject:lastCell forKey:@"cell"];
        
        [randomAnimations addObject:obj];

    }
}

-(void)randomAnimationCorrect{
    NSMutableDictionary *obj  =   [randomAnimations lastObject];
    int rndValue = [[obj objectForKey:@"direction"] intValue];
    
//    int rndValue1  =   arc4random() % self.level.NumColumns;
//    int rndValue2  =   arc4random() % self.level.NumRows;
    
    Cell *lastCell =   [obj objectForKey:@"cell"];
    
    if(rndValue == 2)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:2 isFromUndoRedo:false];
    }
    else if(rndValue == 3)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:3 isFromUndoRedo:false];
    }
    else if(rndValue == 1)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:1 isFromUndoRedo:false];
    }
    else if(rndValue == 0)
    {
        [self changeAllCellsFromCell:lastCell fromDirection:0 isFromUndoRedo:false];
    }
    
    [randomAnimations removeLastObject];
}


-(void)swipe:(UISwipeGestureRecognizer *)gesture{
    CellLabel *lbl = (CellLabel *)[gesture view];
    
    if(gesture.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self changeAllCellsFromCell:lbl.cell fromDirection:2 isFromUndoRedo:false];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self changeAllCellsFromCell:lbl.cell fromDirection:3 isFromUndoRedo:false];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self changeAllCellsFromCell:lbl.cell fromDirection:1 isFromUndoRedo:false];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self changeAllCellsFromCell:lbl.cell fromDirection:0 isFromUndoRedo:false];
    }
    
    movesCount += 1;
    [self.movesBtn setTitle:[NSString stringWithFormat:@"Moves: %d",movesCount] forState:UIControlStateNormal];
}

-(void)changeAllCellsFromCell:(Cell *)cell fromDirection:(int)direction isFromUndoRedo:(BOOL)fromUndoRedo{
    if (direction == 0){
        Cell *lastCell =   [self.level cellAtColumn:self.level.NumColumns - 1 row:cell.row];
        
        [self animateField:(CellLabel *)lastCell.sprite withAnimationType:0 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [lastCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells  =   [NSMutableSet new];
        for (NSInteger column       =   self.level.NumColumns - 1; column > 0; column--) {
            Cell *cellToUse         =   [self.level cellAtColumn:column - 1 row:cell.row];
            Cell *createdCell       =   [self.level createUpdatedCellAtColumn:column   row:cell.row withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;

            [updatedCells addObject:createdCell];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [cellToUse.sprite removeFromSuperview];
            });
        }
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:0  row:cell.row withImg:lastCell.img];
        
        createdCell.origionalColumnIndex    =   lastCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   lastCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:0];
    }
    else if (direction == 1){
        Cell *firstCell =   [self.level cellAtColumn:0 row:cell.row];

        [self animateField:(CellLabel *)firstCell.sprite withAnimationType:1 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [firstCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        for (NSInteger column = 0; column < self.level.NumColumns - 1; column++) {
            Cell *cellToUse    =   [self.level cellAtColumn:column + 1     row:cell.row];
            Cell *createdCell  =   [self.level createUpdatedCellAtColumn:column   row:cell.row withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            
            [updatedCells addObject:createdCell];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [cellToUse.sprite removeFromSuperview];
            });
        }
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:self.level.NumColumns -1  row:cell.row withImg:firstCell.img];
        
        createdCell.origionalColumnIndex    =   firstCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   firstCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:1];
    }
    
    else if (direction == 2){
        Cell *firstCell =   [self.level cellAtColumn:cell.column row:0];
        
        [self animateField:(CellLabel *)firstCell.sprite withAnimationType:2 withDuration:0.5] ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [firstCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        for (NSInteger row = 0; row < self.level.NumRows - 1; row++) {
            Cell *cellToUse    =   [self.level cellAtColumn:cell.column    row:row + 1];
            Cell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column   row:row  withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            
            [updatedCells addObject:createdCell];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [cellToUse.sprite removeFromSuperview];
            });
        }
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column    row:self.level.NumRows - 1 withImg:firstCell.img];
        createdCell.origionalColumnIndex    =   firstCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   firstCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:2];
    }
    else if (direction == 3){
        Cell *lastCell =   [self.level cellAtColumn:cell.column row:self.level.NumRows - 1];

        [self animateField:(CellLabel *)lastCell.sprite withAnimationType:3 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [lastCell.sprite removeFromSuperview];
        });

        NSMutableSet *updatedCells = [NSMutableSet new];
        
        for (NSInteger row = self.level.NumRows - 1; row > 0; row--) {
            Cell *cellToUse    =   [self.level cellAtColumn:cell.column    row:row - 1];
            Cell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column   row:row withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            
            [updatedCells addObject:createdCell];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [cellToUse.sprite removeFromSuperview];
            });
        }
        
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column    row:0 withImg:lastCell.img];
        createdCell.origionalColumnIndex    =   lastCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   lastCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:3];
    }
    
    [self checkResult];
}

-(void)checkResult{
    NSMutableArray *cellsArr    =   [NSMutableArray new];
    
    for (NSInteger row = 0; row < self.level.NumRows; row++) {
        NSMutableArray *rowArr  =   [NSMutableArray new];
        
        for (NSInteger column = 0; column < self.level.NumColumns; column++) {
            Cell *cell  =   [self.level cellAtColumn:column row:row];
            [rowArr addObject:cell.img];
            
        }
        [cellsArr addObject:rowArr];
    }
    
    if ([cellsArr isEqualToArray:self.level.levelArr]){
        _hintBtn.enabled = false;
//        if (self.puzzleId.length > 0){
//            PuzzleModel *puzzle = [[PuzzleModel alloc] initWithId:self.puzzleId name:@"" icon:@"" isSolved:true text:@""];
//            [CoreDataHandler savePuzzleAsSolvedWithPuzzle:puzzle];
//        }

        self.gameLayer.userInteractionEnabled   =   false;
        NSLog(@"success");
        
        double delayInSeconds   =   0.5;
        dispatch_time_t popTime =   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           // [_gameLayer startGlowing];
            self.confetiView.hidden = false;
            self.levelCompleteView.hidden = false;
            
            self.confetiView.layer.zPosition = 9999;
            self.levelCompleteView.layer.zPosition = 9999;
            
            [self.confetiView start];
            
            //self.puzzleNameLbl.text =  self.puzzleName;
            //[self.puzzleNameLbl startGlowing];
        });
        
        delayInSeconds = 1.0;
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:_gameLayer.bounds];
            imgView.image   = _puzzleImage;
            [_gameLayer addSubview:imgView];
    
           // [[RequestReview shared] showReview];
        });
        
        if (self.dailyPuzzle == false || self.cameraPicPuzzle == false){
            NSUInteger levelNumberForStage  =   [[NSUserDefaults standardUserDefaults] integerForKey:self.stage];
            NSUInteger overAllLevelNumber  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"picCross_levelNumber"];
            
            if (self.levelNumber > levelNumberForStage){
                [[NSUserDefaults standardUserDefaults] setInteger:overAllLevelNumber + 1 forKey:@"picCross_levelNumber"];
                [[NSUserDefaults standardUserDefaults] setInteger:levelNumberForStage + 1 forKey:self.stage];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

-(IBAction)tapNext:(id)sender{
    if (self.dailyPuzzle == true){
        [self.navigationController popViewControllerAnimated:true];
    }
    else{
        if (self.levelNumber <= 11) {
            self.levelNumber += 1;
            [self beginGame];
            
            if (self.levelNumber % 10 == 0){
                //[self openCoinsWheel];
            }
            else if (self.levelNumber % 2 == 0){
                //[self showVideoAds];
            }
            else if (self.levelNumber % 3 == 0){
                [self rate];
            }
        } else {
            self.levelNumber = 1;
            [self.navigationController popViewControllerAnimated:true];
        }
    }
}

-(void)rate{
    if (@available(iOS 10.3, *)) {
        if ([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            [SKStoreReviewController requestReview];
        }
    } else {
        // Fallback on earlier versions
    }
}

-(IBAction)back:(id)sender{
    [self.navigationController fadePopViewController];
}

-(IBAction)home:(id)sender{
    [self.navigationController fadePopToRootViewController];
}

-(IBAction)hint:(id)sender{
    BOOL toBuy                  =   false;
    int pendingHints  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];

    if (pendingHints - 20 < 0){
        toBuy   =   true;
    }

    BOOL isProversion   =   [[NSUserDefaults standardUserDefaults ] boolForKey:[InAppIds proVersionId]];

    if(isProversion == true){
        toBuy   =   false;
    }

    if (toBuy == false) {
        
        [self addHints:-20];
        
        NSMutableArray *cellsToReplace = [NSMutableArray new];
        
        for(CellLabel *view in _gameLayer.subviews){
            if ([view isKindOfClass:[CellLabel class]]){
                NSLog(@"CellLabel");
                
                if(view.cell.origionalRowIndex != view.cell.row || view.cell.origionalColumnIndex != view.cell.column){
                    [cellsToReplace addObject:view];
                    NSLog(@"cellsToReplace view.cell.row ==== %lu",view.cell.row);
                    NSLog(@"cellsToReplace view.cell.column ==== %lu",view.cell.column);
                }
//                view.numberingLabel.hidden  =   false;
            }
        }
        
        if (cellsToReplace.count > 0){
            int rndValue = arc4random() % [cellsToReplace count];
            CellLabel *firstViewToMove = (CellLabel *)[cellsToReplace objectAtIndex:rndValue];
            CellLabel *secondViewToMove;
            
            NSLog(@"firstViewToMove view.cell.row ==== %lu",firstViewToMove.cell.row);
            NSLog(@"firstViewToMove view.cell.column ==== %lu",firstViewToMove.cell.column);
            
            for(CellLabel *view in _gameLayer.subviews){
                if ([view isKindOfClass:[CellLabel class]]){
                    if(view.cell.row == firstViewToMove.cell.origionalRowIndex && view.cell.column == firstViewToMove.cell.origionalColumnIndex){
                        secondViewToMove = view;
                        
                        NSLog(@"secondViewToMove view.cell.row ==== %lu",view.cell.row);
                        NSLog(@"secondViewToMove view.cell.column ==== %lu",view.cell.column);
                        
                        break;
                    }
                }
            }
            
            [self.level swapCells:firstViewToMove.cell secondCell:secondViewToMove.cell];
            
            CGRect firstViewFrame = firstViewToMove.frame;
            CGRect secondViewFrame = secondViewToMove.frame;
            
            [UIView animateWithDuration:0.4
                             animations:^{
                                 firstViewToMove.frame = secondViewFrame;
                                 secondViewToMove.frame = firstViewFrame;
                             }];
            
            double delayInSeconds   =   0.5;
            dispatch_time_t popTime =   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self checkResult];
            });
        }
    }
    else{
        //buy hints

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoGame" bundle:nil];
        BuyCoinsViewController *purchaseVC = [storyboard instantiateViewControllerWithIdentifier:@"BuyCoinsViewController"];
        [self.navigationController pushFadeViewController:purchaseVC];
    }
}

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*tileWidth , row*tileHeight );
}

-(void)applyTheme{
    [self applyShadowTo:self.headerView];
    [self roundCorner:self.levelNumberView];
    
    for(UIView*v in _btnsView){
        [self roundCorner:v];
        
        v.layer.borderColor =   [[Theme sharedManager] btnsTintColor].CGColor;
        v.layer.borderWidth =   1;
    }
    
    [self.hintBtn setTintColor:[[Theme sharedManager] btnsTintColor] ];
    [self.backBtn setTintColor:[[Theme sharedManager] btnsTintColor] ];
    [self.movesBtn setTintColor:[[Theme sharedManager] btnsTintColor] ];
    [self.rateBtn setTintColor:[[Theme sharedManager] btnsTintColor] ];
    
    [self.movesBtn setTitleColor:[[Theme sharedManager] btnsTintColor] forState:UIControlStateNormal];
    
    self.hintsLbl.textColor = [[Theme sharedManager] btnsTintColor];
    //self.levelNumberLbl.textColor = [[Theme sharedManager] btnsTintColor];
    self.pointslable.textColor = [[Theme sharedManager] btnsTitleColor];

    self.hintsLbl.backgroundColor = [[Theme sharedManager] themeColor];
    
    //self.view.backgroundColor           =   [[Theme sharedManager] themeColor];
    self.headerView.backgroundColor     =   [[Theme sharedManager] themeColor];
}

-(void)applyShadowTo:(UIView*)view{
    float shadowSize = 5.0f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(view.frame.origin.x - shadowSize / 2,
                                                                           view.frame.origin.y - shadowSize / 2,
                                                                           [UIScreen mainScreen].bounds.size.width + shadowSize,
                                                                           view.frame.size.height + shadowSize)];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [[Theme sharedManager] gridShadowColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowPath = shadowPath.CGPath;
}

-(void)roundCorner:(UIView*)view{
    view.layer.cornerRadius  =   view.frame.size.height/2;
    view.layer.masksToBounds =   true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
