//
//  CardGame.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 17/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "CardGame.h"
#import "CardGame_Protected.m"

@implementation CardGame
- (BOOL)isGameStarted{
    if (!_gameStarted) {
        _gameStarted = NO;
    }
    return _gameStarted;
}

-(NSMutableArray *)cards{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ?  self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *) deck{
    self = [super init];
    if (self) {
        for (int i =0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else{
                self = nil;
                break;
            }
            
            
        }
    }
    return self;
}

- (void)flipCardAtIndex:(NSUInteger)index{
    [self cardAtIndex:index].faceUp = ! [self cardAtIndex:index].faceUp;
}

- (void)cleanMatchedCards{
    NSMutableIndexSet *matchedCardsIndexes = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i < [self.cards count];i++) {
        Card *c = [self cardAtIndex:i];
        if (c.matchStatus == MatchStatusMatched) {
            [matchedCardsIndexes addIndex:i];
        }
    }
    [self.cards removeObjectsAtIndexes:matchedCardsIndexes];
}

-(NSIndexSet *)indexesOfMatchedCards{
    NSMutableIndexSet *matchedCardsIndexes = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i < [self.cards count];i++) {
        Card *c = [self cardAtIndex:i];
        if (c.matchStatus == MatchStatusMatched) {
            [matchedCardsIndexes addIndex:i];
        }
    }
    return matchedCardsIndexes;
}


@end
