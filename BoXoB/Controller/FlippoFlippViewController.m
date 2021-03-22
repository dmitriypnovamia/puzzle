//
//  ViewController.m
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "FlippoFlippViewController.h"
#import "Level.h"
#import "NSArray+transpose.h"
#import "BoXoB-Swift.h"
#import "UINavigationController+Fade.h"

@interface FlippoFlippViewController ()

@property(nonatomic,retain) IBOutlet CheerView *confetiView;

@end

@implementation FlippoFlippViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    
    NSInteger pendingHint   =   [[NSUserDefaults standardUserDefaults] integerForKey:@"pendingHint"];
    self.hintsLbl.text      =   [NSString stringWithFormat:@"%lu",(long)(pendingHint >= 0 ? pendingHint : 0)];
    [self.movesBtn setTitle:@"Moves: 0" forState:UIControlStateNormal];

    [self beginGame];
    [self applyTheme];
   // [self dummyIncreaseLevel];

}

-(void)dummyIncreaseLevel{
    NSUInteger levelNumberForStage  =   [[NSUserDefaults standardUserDefaults] integerForKey:self.stage];
    
    NSUInteger overAllLevelNumber  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"flippoflip_levelNumber"];
    
    if (self.levelNumber > levelNumberForStage){

        [[NSUserDefaults standardUserDefaults] setInteger:overAllLevelNumber + 1 forKey:@"flippoflip_levelNumber"];
        [[NSUserDefaults standardUserDefaults] setInteger:levelNumberForStage + 1 forKey:self.stage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)beginGame{
    [self.confetiView stop];
    self.confetiView.hidden = true;
    self.levelCompleteView.hidden = true;
    self.gameLayer.userInteractionEnabled   =   true;

    self.hintBtn.enabled    =   true;
    //hideNumbering           =   true;

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
    }
    else if (self.cameraPicPuzzle == true){
        //self.levelNumberLbl.text      =   @"Camera Puzzle";
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

-(void)startAfterImageLoad{
    if (self.puzzleImage.size.width != self.puzzleImage.size.height){
        if (self.puzzleImage.size.width < self.puzzleImage.size.height){
            self.puzzleImage = [UIImage imageWithImage:self.puzzleImage convertToSize:CGSizeMake(self.puzzleImage.size.width, self.puzzleImage.size.width)];
        }
        else{
            self.puzzleImage = [UIImage imageWithImage:self.puzzleImage convertToSize:CGSizeMake(self.puzzleImage.size.height, self.puzzleImage.size.height)];
        }
    }
    
    self.level              =   [[Level alloc] initWithPuzzle:self.puzzleImage text:self.puzzleText];
    self.level.emptyTiles   =   [NSMutableArray new];
    
    NSMutableArray *newCells    =   [self.level shuffle:self.gridSize row:self.gridSize];
    
    tileWidth   =   [UIScreen mainScreen].bounds.size.width/(self.level.NumColumns);
    tileHeight  =   tileWidth;
    
    _gameLayer.frame  =   CGRectMake(0, self.view.frame.size.height - ((self.level.NumRows)*tileHeight) - (tileHeight * 1.5), (self.level.NumColumns )*tileWidth, (self.level.NumRows)*tileHeight);
    _gameLayer.center   =   CGPointMake(_gameLayer.center.x , self.view.center.y +20);
    
    self.gameLayer.clipsToBounds    =   true;
    _gameLayer.layer.borderWidth = 4;
    
    //[self.hintBtn setBackgroundImage:[UIImage imageNamed:@"btnThemeImg"] forState:UIControlStateNormal];
    self.hintBtn.frame = CGRectMake(self.view.frame.size.width - 75, _gameLayer.frame.origin.y + _gameLayer.frame.size.height + 25, 50, 50);
    self.flipHBtn.frame = CGRectMake(25, self.hintBtn.frame.origin.y, 50, 50);
    self.flipVBtn.frame = CGRectMake(100, self.hintBtn.frame.origin.y, 50, 50);

    //[self.flipHBtn setBackgroundImage:[UIImage imageNamed:@"btnThemeImg"] forState:UIControlStateNormal];
    //[self.flipVBtn setBackgroundImage:[UIImage imageNamed:@"btnThemeImg"] forState:UIControlStateNormal];
    [self addSpritesForCells:newCells];
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(UIImage *)loadimage{
    NSString *workSpacePath=[[self applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)self.levelNumber]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]];
    
    return image;
}

- (void)addSpritesForCells:(NSMutableArray *)cells {
    NSMutableArray *allAddedCells = [NSMutableArray new];
    for (Cell *cell in cells) {
        CellImage *textCell = [self createCell:cell];
        
        NSUInteger randomIndex = 1 + arc4random() % 3;
        
        textCell.cell.currentTransform = textCell.imgView.transform;
        textCell.currentTransform = textCell.imgView.transform;
        
        if (randomIndex == 2){
            [self addTransformations:textCell];
        }
        
        [allAddedCells addObject:textCell];
        [self.gameLayer addSubview:textCell];
        
        int rndValue = arc4random() % 3;

        [self animateField:textCell withAnimationType:rndValue withDuration:0];
    }
}

- (void)updateSpritesForCells:(NSMutableSet *)cells withAnimation:(int)animationType{
    for (Cell *cell in cells) {
        CellImage *textCell = [self createCell:cell];

        textCell.imgView.transform = cell.currentTransform;
        textCell.a = cell.currentTransform.a;
        textCell.d = cell.currentTransform.d;

        [self.gameLayer addSubview:textCell];
        
        [self animateField:textCell withAnimationType:animationType withDuration:0.5];
    }
}

-(void)animateField:(CellImage *)lbl withAnimationType:(int)animationType withDuration:(float)duration{
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

-(CellImage *)createCell:(Cell *)cell{
    NSString *cellNumbering         =   [NSString stringWithFormat:@"%ld%ld",(long)cell.origionalRowIndex,(long)cell.origionalColumnIndex];
    CGPoint origin                  =   [self pointForColumn:cell.column row:cell.row];

    CellImage *textCell             =   [[CellImage alloc] initWithFrame:CGRectMake(origin.x, origin.y, tileWidth, tileHeight) img:cell.img cellNumbering:cellNumbering hideNumbering:true isResult:NO cell:cell];
    textCell.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [textCell addGestureRecognizer:tapGesture];
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

-(void)imageTapped:(UITapGestureRecognizer *)gesture{
    if (selectedImage != nil){
        //selectedImage.alpha = 1.0;
    }
    for(CellImage *view in _gameLayer.subviews){
        if ([view isKindOfClass:[CellImage class]]){
            view.layer.borderWidth = 0;
        }
    }
    
    selectedImage = (CellImage *)[gesture view];
    selectedImage.layer.borderWidth = 5;
    //img.alpha = 0.5;
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)checkResult{
    
    BOOL isSuccess = true;
   // [self addContinueView];
    
    for(CellImage *view in _gameLayer.subviews){
        if ([view isKindOfClass:[CellImage class]]){
            CellImage *cellView = (CellImage*)view;
            
            CGFloat currentFlipd = cellView.d;
            CGFloat currentFlipa = cellView.a;
            
            if (currentFlipd == -1 || currentFlipa == -1){
                isSuccess = false;
                break;
            }
        }
    }
    
    NSMutableArray *cellsArr    =   [NSMutableArray new];
    
    for (NSInteger row = 0; row < self.level.NumRows; row++) {
        NSMutableArray *rowArr  =   [NSMutableArray new];
        
        for (NSInteger column = 0; column < self.level.NumColumns; column++) {
            Cell *cell  =   [self.level cellAtColumn:column row:row];
            [rowArr addObject:cell.img];
            
        }
        [cellsArr addObject:rowArr];
    }
    
    if (![cellsArr isEqualToArray:self.level.levelArr]){
        isSuccess = false;
    }

    if (isSuccess == true){
        _hintBtn.enabled = false;


        self.gameLayer.userInteractionEnabled   =   false;
        NSLog(@"success");
        
        double delayInSeconds   =   0.5;
        dispatch_time_t popTime =   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:_gameLayer.bounds];
            imgView.image   = _puzzleImage;
            [_gameLayer addSubview:imgView];
            
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.confetiView.hidden = false;
                self.levelCompleteView.hidden = false;
                
                self.confetiView.layer.zPosition = 9999;
                self.levelCompleteView.layer.zPosition = 9999;
                
                [self.confetiView start];
                
                self.puzzleNameLbl.text =  self.puzzleName;
                //[self.puzzleNameLbl startGlowing];
                
            });
        });
        
        if (self.dailyPuzzle == false || self.cameraPicPuzzle == false){
            NSUInteger levelNumberForStage  =   [[NSUserDefaults standardUserDefaults] integerForKey:self.stage];
            
            NSUInteger overAllLevelNumber  =   [[NSUserDefaults standardUserDefaults] integerForKey:@"flippoflip_levelNumber"];
            
            if (self.levelNumber > levelNumberForStage){
                
                [[NSUserDefaults standardUserDefaults] setInteger:overAllLevelNumber + 1 forKey:@"flippoflip_levelNumber"];
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

-(void)addContinueView{
    self.bottomView.hidden = false;
    self.puzzleTextLbl.text = _puzzleText;
}

-(IBAction)tapToContinue:(id)sender{
    [self.navigationController fadePopViewController];
}

-(IBAction)back:(id)sender{
    [self.navigationController fadePopViewController];
}

-(IBAction)home:(id)sender{
    [self.navigationController fadePopToRootViewController];
}

-(IBAction)flipH:(UIButton *)btn{
    btn.enabled = false;
    
    CGFloat currentFlipd = selectedImage.d;
    CGFloat currentFlipa = selectedImage.a;

    if (currentFlipa == 0){
        currentFlipa = 1;
    }
    if (currentFlipd == 0){
        currentFlipd = 1;
    }
    
    CGAffineTransform translate = CGAffineTransformMakeScale(currentFlipa, -1 * currentFlipd);
    // Apply them to a view
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         selectedImage.imgView.transform = translate;
                         selectedImage.cell.currentTransform = selectedImage.imgView.transform;
                         selectedImage.d = -1 * currentFlipd;
                         [self checkResult];

                     }
                     completion:^(BOOL b) {
                         btn.enabled = true;

                     }];
}

-(IBAction)flipV:(UIButton *)btn{
    btn.enabled = false;

    CGFloat currentFlipd = selectedImage.d;
    CGFloat currentFlipa = selectedImage.a;
    if (currentFlipa == 0){
        currentFlipa = 1;
    }
    if (currentFlipd == 0){
        currentFlipd = 1;
    }
    CGAffineTransform translate = CGAffineTransformMakeScale(-1 * currentFlipa,currentFlipd);
    // Apply them to a view
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         selectedImage.imgView.transform = translate;
                         selectedImage.cell.currentTransform = selectedImage.imgView.transform;
                         selectedImage.a = -1 * currentFlipa;
                         [self checkResult];
                     }
                     completion:^(BOOL b) {
                         btn.enabled = true;

                     }];
}

-(IBAction)hint:(id)sender{
    selectedImage = nil;
    
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
    
        for(CellImage *view in _gameLayer.subviews){
            if ([view isKindOfClass:[CellImage class]]){
                if(view.cell.origionalRowIndex != view.cell.row || view.cell.origionalColumnIndex != view.cell.column){
                    [cellsToReplace addObject:view];
                }
            }
        }
    
        if (cellsToReplace.count > 0){
            int rndValue = arc4random() % [cellsToReplace count];
            CellImage *firstViewToMove = (CellImage *)[cellsToReplace objectAtIndex:rndValue];
            CellImage *secondViewToMove;
        
            for(CellImage *view in _gameLayer.subviews){
                if ([view isKindOfClass:[CellImage class]]){
                    if(view.cell.origionalRowIndex == firstViewToMove.cell.row && view.cell.origionalColumnIndex == firstViewToMove.cell.column){
                        secondViewToMove = view;
                    
                        break;
                    }
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
        }
        else{
            for(CellImage *view in _gameLayer.subviews){
                if ([view isKindOfClass:[CellImage class]]){
                    CellImage *cellView = (CellImage*)view;
                
                    CGFloat currentFlipd = cellView.d;
                    CGFloat currentFlipa = cellView.a;
                
                    if (currentFlipd == -1 || currentFlipa == -1){
                        [cellsToReplace addObject:view];
                    //break;
                    }
                }
            }
        
            if (cellsToReplace.count > 0){
                int rndValue = arc4random() % [cellsToReplace count];
                CellImage *firstViewToMove = (CellImage *)[cellsToReplace objectAtIndex:rndValue];
//                CGAffineTransform translate = CGAffineTransformMakeScale(1, 1);
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void) {
                                 // Apply them to a view
                                 firstViewToMove.imgView.transform = CGAffineTransformIdentity;
                                 firstViewToMove.cell.currentTransform = CGAffineTransformIdentity;
                                 firstViewToMove.d = 1;
                                 firstViewToMove.a = 1;
                                 
                             }
                             completion:^(BOOL b) {
                                 double delayInSeconds   =   0.3;
                                 dispatch_time_t popTime =   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                     [self checkResult];
                                 });
                             }];
            }
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
    self.levelNumberLbl.textColor = [[Theme sharedManager] btnsTintColor];
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

-(void)addTransformations:(CellImage*)view{
    NSUInteger randomIndex = 1 + arc4random() % 3;

    if (randomIndex == 0){
        CGAffineTransform translate = CGAffineTransformMakeScale(-1, 1);
        // Apply them to a view
        view.imgView.transform = translate;
        view.a = -1;
        view.d = 1;

    }
    else if (randomIndex == 1){
        CGAffineTransform translate = CGAffineTransformMakeScale(-1, -1);
        // Apply them to a view
        view.imgView.transform = translate;
        view.a = -1;
        view.d = -1;
    }
    else if (randomIndex == 2){
        CGAffineTransform translate = CGAffineTransformMakeScale(1, -1);
        // Apply them to a view
        view.imgView.transform = translate;
        view.a = 1;
        view.d = -1;
    }
    else{
        CGAffineTransform translate = CGAffineTransformMakeScale(-1, 1);
        // Apply them to a view
        view.imgView.transform = translate;
        view.a = -1;
        view.d = 1;
    }
    
    view.cell.currentTransform = view.imgView.transform;
    view.currentTransform = view.imgView.transform;
}

-(void)swipe:(UISwipeGestureRecognizer *)gesture{
    CellImage *lbl = (CellImage *)[gesture view];
    
    if(gesture.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self changeAllCellsFromCell:lbl fromDirection:2 isFromUndoRedo:false];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self changeAllCellsFromCell:lbl fromDirection:3 isFromUndoRedo:false];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self changeAllCellsFromCell:lbl fromDirection:1 isFromUndoRedo:false];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self changeAllCellsFromCell:lbl fromDirection:0 isFromUndoRedo:false];
    }
    
    movesCount += 1;
    [self.movesBtn setTitle:[NSString stringWithFormat:@"Moves: %d",movesCount] forState:UIControlStateNormal];
}

-(void)changeAllCellsFromCell:(CellImage *)img fromDirection:(int)direction isFromUndoRedo:(BOOL)fromUndoRedo{
    if (direction == 0){
        Cell *lastCell =   [self.level cellAtColumn:self.level.NumColumns - 1 row:img.cell.row];
        
        [self animateField:(CellImage *)lastCell.sprite withAnimationType:0 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [lastCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells  =   [NSMutableSet new];
        for (NSInteger column       =   self.level.NumColumns - 1; column > 0; column--) {
            Cell *cellToUse         =   [self.level cellAtColumn:column - 1     row:img.cell.row];
            Cell *createdCell       =   [self.level createUpdatedCellAtColumn:column   row:img.cell.row withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            createdCell.currentTransform = cellToUse.currentTransform;
            
            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
        }
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:0  row:img.cell.row withImg:lastCell.img];
        
        createdCell.origionalColumnIndex    =   lastCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   lastCell.origionalRowIndex;
        createdCell.currentTransform = lastCell.currentTransform;

        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:0];
    }
    else if (direction == 1){
        Cell *firstCell =   [self.level cellAtColumn:0 row:img.cell.row];
        
        [self animateField:(CellImage *)firstCell.sprite withAnimationType:1 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [firstCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        for (NSInteger column = 0; column < self.level.NumColumns - 1; column++) {
            Cell *cellToUse    =   [self.level cellAtColumn:column + 1     row:img.cell.row];
            Cell *createdCell  =   [self.level createUpdatedCellAtColumn:column   row:img.cell.row withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            createdCell.currentTransform = cellToUse.currentTransform;

            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
            
        }
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:self.level.NumColumns -1  row:img.cell.row withImg:firstCell.img];
        
        createdCell.origionalColumnIndex    =   firstCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   firstCell.origionalRowIndex;
        createdCell.currentTransform = firstCell.currentTransform;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:1];
    }
    
    else if (direction == 2){
        Cell *firstCell =   [self.level cellAtColumn:img.cell.column row:0];
        
        [self animateField:(CellImage *)firstCell.sprite withAnimationType:2 withDuration:0.5] ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [firstCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        for (NSInteger row = 0; row < self.level.NumRows - 1; row++) {
            Cell *cellToUse    =   [self.level cellAtColumn:img.cell.column    row:row + 1];
            Cell *createdCell  =   [self.level createUpdatedCellAtColumn:img.cell.column   row:row  withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            createdCell.currentTransform = cellToUse.currentTransform;

            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
            
        }
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:img.cell.column    row:self.level.NumRows - 1 withImg:firstCell.img];
        createdCell.origionalColumnIndex    =   firstCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   firstCell.origionalRowIndex;
        createdCell.currentTransform = firstCell.currentTransform;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:2];
    }
    else if (direction == 3){
        Cell *lastCell =   [self.level cellAtColumn:img.cell.column row:self.level.NumRows - 1];
        
        [self animateField:(CellImage *)lastCell.sprite withAnimationType:3 withDuration:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [lastCell.sprite removeFromSuperview];
        });
        
        NSMutableSet *updatedCells = [NSMutableSet new];
        
        for (NSInteger row = self.level.NumRows - 1; row > 0; row--) {
            Cell *cellToUse    =   [self.level cellAtColumn:img.cell.column    row:row - 1];
            Cell *createdCell  =   [self.level createUpdatedCellAtColumn:img.cell.column   row:row withImg:cellToUse.img];
            createdCell.origionalColumnIndex    =   cellToUse.origionalColumnIndex;
            createdCell.origionalRowIndex       =   cellToUse.origionalRowIndex;
            createdCell.currentTransform = cellToUse.currentTransform;

            [updatedCells addObject:createdCell];
            [cellToUse.sprite removeFromSuperview];
        }
        
        Cell *createdCell  =   [self.level createUpdatedCellAtColumn:img.cell.column    row:0 withImg:lastCell.img];
        createdCell.origionalColumnIndex    =   lastCell.origionalColumnIndex;
        createdCell.origionalRowIndex       =   lastCell.origionalRowIndex;
        createdCell.currentTransform = lastCell.currentTransform;
        
        [updatedCells addObject:createdCell];
        [self updateSpritesForCells:updatedCells withAnimation:3];
    }
    [self checkResult];
}

@end
