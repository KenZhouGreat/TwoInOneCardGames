//
//  MatchCardView.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 18/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "MatchCardView.h"

@implementation MatchCardView

#pragma mark - Setters

- (void)setRank:(NSInteger)rank{
    _rank = rank;
    [self setNeedsDisplay];
}

-(void)setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
     [self setNeedsDisplay];
}

- (void)setMatched:(BOOL)matched{
    _matched =matched;
//    [self setNeedsDisplay];
}

- (void)setCompared:(BOOL)compared{
    _compared = compared;
    [self setNeedsDisplay];
}

- (void)setUnplayable:(BOOL)unplayable{
    _unplayable = unplayable;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRectFrame = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                                cornerRadius:5.0];
    [[UIColor clearColor] setStroke];
    [roundedRectFrame addClip];
    [roundedRectFrame stroke];
    
    
    if ([self isFaceUp]) {
        UIImage *cardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank]
        , @{@"♠︎":@"S",@"♣︎":@"C",@"♥︎":@"H",@"♦︎":@"D"}[self.suit]]];
        if (cardImage) {
            [cardImage drawInRect:self.bounds];
        }
    }
    else{
        UIImage *backImage = [UIImage imageNamed:@"_cardback"];
        if (backImage) {
            [backImage drawInRect:self.bounds];
        }
    }
}





#pragma mark - initializer
-(void)setUp{

}

-(void)awakeFromNib{
    [self setUp];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setUp];
    return self;
}


@end
