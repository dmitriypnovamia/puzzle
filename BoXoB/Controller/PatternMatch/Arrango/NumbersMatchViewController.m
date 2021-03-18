//
//  ViewController.m
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "NumbersMatchViewController.h"
#import "PatternMatchLevel.h"
#import "UINavigationController+Fade.h"
#import "BoXoB-Swift.h"

@interface NumbersMatchViewController ()

@property(nonatomic,retain) IBOutlet CheerView *confetiView;

@end

@implementation NumbersMatchViewController

-(IBAction)back:(id)sender{
    [self.navigationController fadePopViewController];
}

-(IBAction)home:(id)sender{
    [self.navigationController fadePopToRootViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.levelNumberLblView.layer.cornerRadius  =   self.levelNumberLblView.frame.size.height/2;
    self.levelNumberLblView.layer.masksToBounds =   true;
    
    self.hintView.layer.cornerRadius  =   self.levelNumberLblView.frame.size.height/2;
    self.hintView.layer.masksToBounds =   true;
    self.movesLbl.text      =   @"0";

    [self beginGame];
    self.pointslable.textColor = [[Theme sharedManager] btnsTitleColor];

   // [self dummyIncreaseLevel];
}

-(void)dummyIncreaseLevel{
    NSUInteger levelNumberForStage  =   [[NSUserDefaults standardUserDefaults] integerForKey:self.stage];
    NSUInteger overAllLevelNumber  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"arrangeNumbers_levelNumber"];
    
    if (self.levelNumber > levelNumberForStage){

        [[NSUserDefaults standardUserDefaults] setInteger:overAllLevelNumber + 1 forKey:@"arrangeNumbers_levelNumber"];
        [[NSUserDefaults standardUserDefaults] setInteger:levelNumberForStage + 1 forKey:self.stage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)showAvailableHints{
    NSInteger pendingHint   =   [[NSUserDefaults standardUserDefaults] integerForKey:@"pendingHint"];
    self.hintsLbl.text      =   [NSString stringWithFormat:@"%lu",pendingHint >= 0 ? pendingHint : 0];
}

-(void)beginGame{
    for(PatternMatchCellLabel *view in _gameLayer.subviews){
        if ([view isKindOfClass:[PatternMatchCellLabel class]]){
            [view removeFromSuperview];
        }
    }
    
    [self.confetiView stop];
    self.confetiView.hidden = true;
    self.levelCompleteView.hidden = true;
    
    [self showAvailableHints];
    self.movesLbl.text      =   @"0";
    self.hintBtn.enabled    =   true;
    //hideNumbering           =   true;
    
    NSUInteger levelTypeRndValue    =   0;

    if ([self.stage isEqualToString:@"arrangeNumbers_New_Born"]){
        levelTypeRndValue = 0;
    }
    else if([self.stage isEqualToString:@"arrangeNumbers_Playing_Kid"]){
        levelTypeRndValue = 1;
    }
    else if([self.stage isEqualToString:@"arrangeNumbers_Smarty_Boy"]){
        levelTypeRndValue = 2;
    }
    else if([self.stage isEqualToString:@"arrangeNumbers_Bachelor"]){
        levelTypeRndValue = 3;
    }
    else if([self.stage isEqualToString:@"arrangeNumbers_Dad"]){
        levelTypeRndValue = 4;
    }
    else if([self.stage isEqualToString:@"arrangeNumbers_Grand_Father"]){
        levelTypeRndValue = 5;
    }
    else if([self.stage isEqualToString:@"arrangeNumbers_Super_Man"]){
        levelTypeRndValue = 6;
    }
    else{
        levelTypeRndValue = 0;
    }
    
    if (self.dailyPuzzle == true){
        self.nextLabel.text      =   @"Back";
        self.levelNumberLbl.text      =   @"Daily Puzzle";
        NSMutableArray *viewCons = self.navigationController.viewControllers.mutableCopy;
        [viewCons removeObjectAtIndex:viewCons.count - 2];
        self.navigationController.viewControllers = viewCons;
    }
    else if (self.cameraPicPuzzle == true){
        //self.levelNumberLbl.text      =   @"Camera Puzzle";
    }
    else{
        self.levelNumberLbl.text    =   [NSString stringWithFormat:@"Level: %lu",(unsigned long)self.levelNumber];
    }
    
    self.level                  =   [[PatternMatchLevel alloc] initWithFile:@"NumbersMatchLevels"];
    self.level.emptyTiles       =   [NSMutableArray new];
    
    self.redoBtn.enabled        =   false;
    self.undoBtn.enabled        =   false;
    
    NSSet *newCells             =   [self.level shuffle:levelTypeRndValue];
    
    tileWidth   =   [UIScreen mainScreen].bounds.size.width/(self.level.NumColumns);
    tileHeight  =   tileWidth;
    
    _gameLayer.frame  =   CGRectMake(0, 0, (self.level.NumColumns)*tileWidth, (self.level.NumRows)*tileHeight);
    _gameLayer.center   =   CGPointMake(_gameLayer.center.x , self.view.center.y + 20);
    _gameLayer.backgroundColor          =   [UIColor colorWithWhite:1 alpha:0.8];
    _gameLayer.layer.borderWidth = 4;

    self.gameLayer.clipsToBounds        =   true;
    self.hintBtn.frame = CGRectMake(self.view.frame.size.width - 75, _gameLayer.frame.origin.y + _gameLayer.frame.size.height + 25, 50, 50);
    [self.hintBtn setBackgroundImage:[UIImage imageNamed:@"btnThemeImg"] forState:UIControlStateNormal];

    _gameLayer.layer.zPosition = 100;
    
    [self addSpritesForCells:newCells];
}

- (void)addSpritesForCells:(NSSet *)cells {
    NSMutableArray *allAddedCells = [NSMutableArray new];
    for (PatternMatchCell *cell in cells) {
        PatternMatchCellLabel *textCell = [self createCell:cell];
        [allAddedCells addObject:textCell];
        [self.gameLayer addSubview:textCell];
        
        int rndValue = arc4random() % 3;

        [self animateField:textCell withAnimationType:rndValue withDuration:0];
    }
}

- (void)updateSpritesForCells:(NSSet *)cells withAnimation:(int)animationType{
    for (PatternMatchCell *cell in cells) {
        PatternMatchCellLabel *textCell = [self createCell:cell];
        
        [self.gameLayer addSubview:textCell];
        
        [self animateField:textCell withAnimationType:animationType withDuration:0.5];
    }
}

-(void)animateField:(PatternMatchCellLabel *)lbl withAnimationType:(int)animationType withDuration:(float)duration{
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

-(PatternMatchCellLabel *)createCell:(PatternMatchCell *)cell{
    NSString *celltext              =   [NSString stringWithFormat:@"%lu",(unsigned long)cell.type];
    NSString *cellNumbering         =   [NSString stringWithFormat:@"%ld%ld",(long)cell.origionalRowIndex,cell.origionalColumnIndex];
    CGPoint origin                  =   [self pointForColumn:cell.column row:cell.row];
    PatternMatchCellLabel *textCell             =   [[PatternMatchCellLabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, tileWidth, tileHeight) text:celltext cellNumbering:cellNumbering hideNumbering:true];
    textCell.layer.borderColor      =   [UIColor grayColor].CGColor;
    textCell.layer.borderWidth      =   1.0f;
    
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

-(void)swipe:(UISwipeGestureRecognizer *)gesture{
    PatternMatchCellLabel *lbl = (PatternMatchCellLabel *)[gesture view];
    
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
    
    self.movesLbl.text  =   [NSString stringWithFormat:@"%ld",[self.movesLbl.text integerValue] + 1];
}

-(void)changeAllCellsFromCell:(PatternMatchCell *)cell fromDirection:(int)direction isFromUndoRedo:(BOOL)fromUndoRedo{
    if (direction == 0){
        PatternMatchCell *lastCell =   [self.level cellAtColumn:self.level.NumColumns - 1 row:cell.row];
        
        [self animateField:(PatternMatchCellLabel *)lastCell.sprite withAnimationType:0 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [lastCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells  =   [NSMutableSet new];
        for (NSInteger column       =   self.level.NumColumns - 1; column > 0; column--) {
            PatternMatchCell *cellToUse         =   [self.level cellAtColumn:column - 1     row:cell.row];
            PatternMatchCell *createdCell       =   [self.level createUpdatedCellAtColumn:column   row:cell.row withText:cellToUse.type];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;

            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
        }
        PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:0  row:cell.row withText:lastCell.type];
        
        createdCell.origionalColumnIndex    =   lastCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   lastCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:0];
    }
    else if (direction == 1){
        PatternMatchCell *firstCell =   [self.level cellAtColumn:0 row:cell.row];

        [self animateField:(PatternMatchCellLabel *)firstCell.sprite withAnimationType:1 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [firstCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        for (NSInteger column = 0; column < self.level.NumColumns - 1; column++) {
            PatternMatchCell *cellToUse    =   [self.level cellAtColumn:column + 1     row:cell.row];
            PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:column   row:cell.row withText:cellToUse.type];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            
            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
            
        }
        PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:self.level.NumColumns -1    row:cell.row withText:firstCell.type];
        
        createdCell.origionalColumnIndex    =   firstCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   firstCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:1];
    }
    
    else if (direction == 2){
        PatternMatchCell *firstCell =   [self.level cellAtColumn:cell.column row:0];
        
        [self animateField:(PatternMatchCellLabel *)firstCell.sprite withAnimationType:2 withDuration:0.5] ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [firstCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        for (NSInteger row = 0; row < self.level.NumRows - 1; row++) {
            PatternMatchCell *cellToUse    =   [self.level cellAtColumn:cell.column    row:row + 1];
            PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column   row:row  withText:cellToUse.type];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            
            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
            
        }
        PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column    row:self.level.NumRows - 1 withText:firstCell.type];
        createdCell.origionalColumnIndex    =   firstCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   firstCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:2];
    }
    else if (direction == 3){
        PatternMatchCell *lastCell =   [self.level cellAtColumn:cell.column row:self.level.NumRows - 1];

        [self animateField:(PatternMatchCellLabel *)lastCell.sprite withAnimationType:3 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [lastCell.sprite removeFromSuperview];
        });

        NSMutableSet *updatedCells = [NSMutableSet new];
        
        for (NSInteger row = self.level.NumRows - 1; row > 0; row--) {
            PatternMatchCell *cellToUse    =   [self.level cellAtColumn:cell.column    row:row - 1];
            PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column   row:row withText:cellToUse.type];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            
            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
        }
        
        PatternMatchCell *createdCell  =   [self.level createUpdatedCellAtColumn:cell.column    row:0 withText:lastCell.type];
        createdCell.origionalColumnIndex    =   lastCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   lastCell.origionalRowIndex;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:3];
    }
    
    if(!fromUndoRedo){
        UndoRedoAction *undoRedo = [UndoRedoAction new];
        undoRedo.cell = cell;
        undoRedo.direction = direction;
        [self.level.undoArr addObject:undoRedo];
    }
    
    [self checkResult];
}

-(void)checkResult{
    NSMutableArray *cellsArr = [NSMutableArray new];
    for (NSInteger row = 0; row < self.level.NumRows; row++) {
        NSMutableArray *rowArr = [NSMutableArray new];
        for (NSInteger column = 0; column < self.level.NumColumns; column++) {
            PatternMatchCell *cell  =   [self.level cellAtColumn:column row:row];
            [rowArr addObject:[NSNumber numberWithInteger:cell.type]];
        }
        [cellsArr addObject:rowArr];
    }
    
    if ([cellsArr isEqualToArray:self.level.levelArr]) {
        NSLog(@"success");
        _hintBtn.enabled = false;
       // [randomTimer invalidate];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.confetiView.hidden = false;
            self.levelCompleteView.hidden = false;
            
            self.gameLayer.layer.zPosition = 100;
            self.confetiView.layer.zPosition = 9999;
            self.levelCompleteView.layer.zPosition = 10000;
            
            [self.confetiView start];
        });

        if (self.dailyPuzzle == false || self.cameraPicPuzzle == false){
            NSUInteger levelNumberForStage  =   [[NSUserDefaults standardUserDefaults] integerForKey:self.stage];
            
            if (self.levelNumber > levelNumberForStage){
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
        self.levelNumber += 1;
        
        [self beginGame];
        
        if (self.levelNumber % 10 == 0){
            [self openCoinsWheel];
        }
        else if (self.levelNumber % 2 == 0){
            [self showVideoAds];
        }
        else if (self.levelNumber % 3 == 0){
            [self rate];
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
        
        for(PatternMatchCellLabel *view in _gameLayer.subviews){
            if ([view isKindOfClass:[PatternMatchCellLabel class]]){

                if(view.cell.origionalRowIndex != view.cell.row || view.cell.origionalColumnIndex != view.cell.column){
                    [cellsToReplace addObject:view];
                }
                //                view.numberingLabel.hidden  =   false;
            }
        }
        
        if (cellsToReplace.count > 0){
            int rndValue = arc4random() % [cellsToReplace count];
            PatternMatchCellLabel *firstViewToMove = (PatternMatchCellLabel *)[cellsToReplace objectAtIndex:rndValue];
            PatternMatchCellLabel *secondViewToMove;
            
            for(PatternMatchCellLabel *view in _gameLayer.subviews){
                if ([view isKindOfClass:[PatternMatchCellLabel class]]){
                    if(view.cell.origionalRowIndex == firstViewToMove.cell.row && view.cell.origionalColumnIndex == firstViewToMove.cell.column){
                        
                        secondViewToMove = view;
                        
                        break;
                    }
                    //                view.gameLayernumberingLabel.hidden  =   false;
                }
            }
            
            [self.level swapCells:firstViewToMove.cell secondCell:secondViewToMove.cell];
            
            CGRect firstViewFrame = firstViewToMove.frame;
            CGRect secondViewFrame = secondViewToMove.frame;
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 firstViewToMove.frame = secondViewFrame;
                                 secondViewToMove.frame = firstViewFrame;
                             }];
            
            double delayInSeconds   =   0.3;
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

-(IBAction)undo:(UIButton *)sender{
    UndoRedoAction *action  =   [self.level.undoArr lastObject];
    
    if(action.direction == 0){
        [self changeAllCellsFromCell:action.cell fromDirection:1 isFromUndoRedo:true];
        action.direction    =   1;
    }
    else if(action.direction == 1){
        [self changeAllCellsFromCell:action.cell fromDirection:0 isFromUndoRedo:true];
        action.direction = 0;
    }
    else if(action.direction == 2){
        [self changeAllCellsFromCell:action.cell fromDirection:3 isFromUndoRedo:true];
        action.direction    =   3;
    }
    else if(action.direction == 3){
        [self changeAllCellsFromCell:action.cell fromDirection:2 isFromUndoRedo:true];
        action.direction = 2;
    }
    [self.level.undoArr removeLastObject];
    [self.level.redoArr addObject:action];
    
    if (self.level.undoArr.count == 0){
        self.undoBtn.enabled    =   false;
    }
    
    self.redoBtn.enabled        =   true;
}

-(IBAction)redo:(UIButton *)sender{
    UndoRedoAction *action  =   [self.level.redoArr lastObject];
    
    if(action.direction == 0){
        [self changeAllCellsFromCell:action.cell fromDirection:1 isFromUndoRedo:true];
        action.direction    =   1;
    }
    else if(action.direction == 1){;
        [self changeAllCellsFromCell:action.cell fromDirection:0 isFromUndoRedo:true];
        action.direction    =   0;
    }
    else if(action.direction == 2){
        [self changeAllCellsFromCell:action.cell fromDirection:3 isFromUndoRedo:true];
        action.direction    =   3;
    }
    else if(action.direction == 3){
        [self changeAllCellsFromCell:action.cell fromDirection:2 isFromUndoRedo:true];
        action.direction    =   2;
    }
    
    [self.level.redoArr removeLastObject];
    [self.level.undoArr addObject:action];
    
    if (self.level.redoArr.count == 0){
        self.redoBtn.enabled    =   false;
    }
    self.undoBtn.enabled        =   true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
