//
//  MatchCardView.h
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 18/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCard.h"


@interface MatchCardView : UIView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSInteger rank;
@property (nonatomic, getter=isFaceUp) BOOL faceUp;
@property (nonatomic, getter=isMatched) BOOL matched;
@property (nonatomic, getter=isCompared) BOOL compared;
@property (nonatomic, getter=isUnplayable) BOOL unplayable;

@end
