//
//  CardGame.h
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 17/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardGame : NSObject

//designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *) deck;

- (void)flipCardAtIndex: (NSUInteger)index;

-(Card *)cardAtIndex: (NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, getter = isGameStarted, readonly) BOOL gameStarted;
@property (nonatomic, readonly) NSAttributedString *verbose;

@end
