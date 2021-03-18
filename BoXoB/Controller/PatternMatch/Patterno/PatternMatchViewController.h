//
//  ViewController.h
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternMatchLevel.h"
#import "PatternMatchCellLabel.h"
#import "UndoRedoAction.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Glow.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import "BaseViewController.h"

@interface PatternMatchViewController : BaseViewController<SKProductsRequestDelegate>
{
    CGFloat tileWidth;
    CGFloat tileHeight;
    BOOL hideNumbering;
    
    NSArray *products;
    NSString *hint5Price;
    NSString *hint20Price;
    NSString *hint50Price;
    NSString *proPrice;

    SKProduct *hint5Product;
    SKProduct *hint20Product;
    SKProduct *hint50Product;
    SKProduct *proProduct;

    NSArray *inAppProducts;
    SKProductsRequest *productsRequest;
    SKProduct *productId;
    MBProgressHUD *HUD;
    NSTimer *randomTimer;
    NSMutableArray *randomAnimations;

}
@property (nonatomic,assign) BOOL dailyPuzzle;
@property (nonatomic,assign) BOOL cameraPicPuzzle;

@property (nonatomic,assign) NSUInteger dailyPuzzleLevelNo;

@property (nonatomic,assign) NSUInteger levelNumber;
@property (nonatomic,strong) NSString * stage;
@property (weak, nonatomic) IBOutlet UILabel *movesLbl;
@property (weak, nonatomic) IBOutlet UILabel *hintsLbl;
@property (weak, nonatomic) IBOutlet UILabel *levelNumberLbl;
@property (weak, nonatomic) IBOutlet UIButton *settings;
@property (weak, nonatomic) IBOutlet UIButton *undoBtn;
@property (weak, nonatomic) IBOutlet UIButton *redoBtn;
@property (weak, nonatomic) IBOutlet UIButton *hintBtn;
@property (weak, nonatomic) IBOutlet UIView *levelCompleteView;
@property (weak, nonatomic) IBOutlet UIView *gameLayer;

@property (weak, nonatomic) IBOutlet UIView *hintView;
@property (weak, nonatomic) IBOutlet UIView *levelNumberLblView;

@property (assign, nonatomic) NSInteger swipeFromColumn;
@property (assign, nonatomic) NSInteger swipeFromRow;
@property (strong, nonatomic) PatternMatchLevel *level;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

- (void)addSpritesForCells:(NSSet *)cells;
- (void)addTiles ;

-(IBAction)hint:(id)sender;
-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;
-(IBAction)rate:(id)sender;

@end

