//
//  ViewController.h
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Level.h"
#import "CellLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Glow.h"
#import <StoreKit/StoreKit.h>
#import "Theme.h"
#import "BaseViewController.h"

@interface ViewController : BaseViewController
{
    CGFloat tileWidth;
    CGFloat tileHeight;
    NSArray *products;
    BOOL hideNumbering;
    int movesCount;
    NSTimer *randomTimer;
    NSMutableArray *randomAnimations;
}

@property (nonatomic,strong) UIImage * puzzleImage;
@property (nonatomic,strong) NSString * puzzleText;
@property (nonatomic,strong) NSString * puzzleName;

@property (nonatomic,strong) NSString * puzzleId;
@property (nonatomic,strong) NSString * stage;
@property (nonatomic,strong) NSString * readAbleStage;

@property (nonatomic,assign) NSUInteger levelNumber;
    
@property (nonatomic,assign) int gridSize;
@property (nonatomic,assign) BOOL dailyPuzzle;
@property (nonatomic,assign) BOOL cameraPicPuzzle;

@property (weak, nonatomic) IBOutlet UILabel *hintsLbl;
@property (weak, nonatomic) IBOutlet UILabel *levelNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *levelStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *puzzleNameLbl;
@property (weak, nonatomic) IBOutlet UIView *gameLayer;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@property (weak, nonatomic) IBOutlet UIView *hintView;
@property (weak, nonatomic) IBOutlet UIView *levelCompleteView;

@property (weak, nonatomic) IBOutlet UIView *levelNumberView;
@property(nonatomic,retain) IBOutlet UIView *headerView;
@property(nonatomic,retain) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *hintBtn;
@property (weak, nonatomic) IBOutlet UIButton *movesBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (assign, nonatomic) NSInteger swipeFromColumn;
@property (assign, nonatomic) NSInteger swipeFromRow;
@property (strong, nonatomic) Level *level;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *btnsView;

- (void)addSpritesForCells:(NSMutableArray *)cells;

-(IBAction)hint:(id)sender;
-(IBAction)rate:(id)sender;

@end

