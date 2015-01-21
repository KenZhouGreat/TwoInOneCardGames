//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Ken Zhou on 3/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"


@implementation PlayingCardDeck



+ (NSInteger)maxCardCount{
        return [[PlayingCard validSuits] count] * [PlayingCard maxRank];

}

-(id)init
{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *pc = [[PlayingCard alloc] init];
                [pc setSuit:suit];
                [pc setRank:rank];
                [self addCard:pc atTop:NO];
            }
        }
    }
    
    return self;
}

@end
