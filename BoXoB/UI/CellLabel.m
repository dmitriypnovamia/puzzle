//
//  CellLabel.m
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "CellLabel.h"
#import "Theme.h"

@implementation CellLabel

- (id)initWithFrame:(CGRect)theFrame img:(UIImage *)img cellNumbering:(NSString *)cellNumbering hideNumbering:(BOOL)hideNumbering isResult:(BOOL)isResult cell:(Cell*)cell{
    self = [super initWithFrame:theFrame];
    
    if (self) {
        self.hideNumbering  = hideNumbering;
        [self addLabel:img isResult:isResult withRowIndex:cell.column];
        [self addNumberingLabel:cellNumbering isResult:isResult];
    }
    
    return self;
}

-(void)addLabel:(UIImage *)img isResult:(BOOL)isResult withRowIndex:(int)withRowIndex{
    
    self.imgView    =   [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height-2 )];

    self.imgView.image  = img;

    [self addSubview: self.imgView];
}

-(void)addNumberingLabel:(NSString *)withText isResult:(BOOL)isResult {
    self.numberingLabel                     =   [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 20 , 5, 15, 15)];
    self.numberingLabel.text                =   withText;
    self.numberingLabel.font                =   [UIFont boldSystemFontOfSize:10];
    self.numberingLabel.hidden              =   self.hideNumbering;
    self.numberingLabel.textAlignment       =   NSTextAlignmentCenter;
    self.numberingLabel.backgroundColor     =   [UIColor whiteColor];
    [self addSubview:self.numberingLabel];
    self.numberingLabel.textColor            =   [[Theme sharedManager] gridTextColor];
    //[self applyShadowTo:self.numberingLabel];

}

-(void)applyShadowTo:(UILabel*)lbl{
    float shadowSize = 1.0f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(lbl.frame.origin.x - shadowSize / 2,
                                                                           lbl.frame.origin.y - shadowSize / 2,
                                                                           lbl.frame.size.width + shadowSize,
                                                                           lbl.frame.size.height + shadowSize)];
    lbl.layer.masksToBounds = NO;
    lbl.layer.shadowColor   = [UIColor blackColor].CGColor;
    lbl.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    lbl.layer.shadowOpacity = 0.1f;
    lbl.layer.shadowPath = shadowPath.CGPath;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
