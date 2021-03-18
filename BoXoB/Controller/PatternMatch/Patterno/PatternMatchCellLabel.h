//
//  CellLabel.h
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternMatchCell.h"


@interface PatternMatchCellLabel : UIView

@property(nonatomic,retain) UILabel *label;
@property(nonatomic,retain) UILabel *numberingLabel;
@property(nonatomic) BOOL hideNumbering;

@property(nonatomic,retain) PatternMatchCell *cell;
- (id)initWithFrame:(CGRect)theFrame text:(NSString *)text cellNumbering:(NSString *)cellNumbering hideNumbering:(BOOL)hideNumbering;
@end
