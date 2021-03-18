//
//  CellLabel.h
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"


@interface CellLabel : UIView

@property(nonatomic,retain) UIImageView *imgView;
@property(nonatomic,retain) UILabel *numberingLabel;
@property(nonatomic) BOOL hideNumbering;

@property(nonatomic,retain) Cell *cell;
- (id)initWithFrame:(CGRect)theFrame img:(UIImage *)img cellNumbering:(NSString *)cellNumbering hideNumbering:(BOOL)hideNumbering isResult:(BOOL)isResult cell:(Cell*)cell;
@end
