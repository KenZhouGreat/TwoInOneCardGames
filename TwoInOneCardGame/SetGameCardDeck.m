//
//  SetGameCardDeck.m
//  Matchismo
//
//  Created by Ken Zhou on 10/12/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "SetGameCardDeck.h"
#import "SetGameCard.h"

@implementation SetGameCardDeck

-(id)init
{
    self = [super init];
    if (self) {
        for (int i = FirstShape; i <= LastShape; i++) {
            for (int j = FirstColour; j <= LastColour; j++) {
                for (int k = FirstShade; k <= LastShade; k++) {
                    for (int l = 1; l <= 3; l++) {
                        SetGameCard *sc = [[SetGameCard alloc] init];
                        [sc setNumber:l];
                        [sc setShade:k];
                        [sc setColour:j];
                        [sc setShape:i];
                        [self addCard:sc atTop:NO];
                    }
                }
            }
        }
    }
    
    return self;
}


@end
