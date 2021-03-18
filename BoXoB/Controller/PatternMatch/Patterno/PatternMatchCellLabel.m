//
//  CellLabel.m
//  CandyCrushUIKit
//
//  Created by iOSAppWorld on 30/06/16.
//  Copyright © 2016 iOSAppWorld. All rights reserved.
//

#import "PatternMatchCellLabel.h"

@implementation PatternMatchCellLabel

- (id)initWithFrame:(CGRect)theFrame text:(NSString *)text cellNumbering:(NSString *)cellNumbering hideNumbering:(BOOL)hideNumbering {
    self = [super initWithFrame:theFrame];
    
    if (self) {
        self.hideNumbering  = hideNumbering;
        [self addLabel:text];
        [self addNumberingLabel:cellNumbering];
    }
    
    return self;
}

-(void)addLabel:(NSString *)withText{
    self.label                      =   [[UILabel alloc]initWithFrame:self.bounds];
    self.label.text                 =   withText;
    self.label.backgroundColor      =   [UIColor colorWithWhite:1 alpha:0.4];
    self.label.textAlignment        =   NSTextAlignmentCenter;
    self.label.font                 =   [UIFont systemFontOfSize:(self.frame.size.width*50/100)];
    self.label.textColor            =   [UIColor blackColor];
    [self addSubview:self.label];
}

-(void)addNumberingLabel:(NSString *)withText{
    int width   =   (self.frame.size.width*25/100) > 25 ? 25 : (self.frame.size.width*25/100);
    int fontSize   =   (self.frame.size.width*15/100) > 10 ? 10 : (self.frame.size.width*15/100);

    self.numberingLabel                     =   [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - (width + 5) , 5, width, width)];
    self.numberingLabel.text                =   withText;
//    self.numberingLabel.layer.cornerRadius  =   ((self.frame.size.width *35)/200);
//    self.numberingLabel.layer.masksToBounds =   true;
    self.numberingLabel.layer.borderColor   =   [UIColor darkGrayColor].CGColor;
    self.numberingLabel.backgroundColor     =   [UIColor lightGrayColor];

    self.numberingLabel.layer.borderWidth   =   1;
    self.numberingLabel.textColor           =   [UIColor whiteColor];
    self.numberingLabel.font                =   [UIFont boldSystemFontOfSize:fontSize];
    self.numberingLabel.adjustsFontSizeToFitWidth         = YES;

    self.numberingLabel.hidden              =   self.hideNumbering;
    self.numberingLabel.textAlignment       =   NSTextAlignmentCenter;

    //self.numberingLabel.backgroundColor     =   [UIColor clearColor];
    
    [self addSubview:self.numberingLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
