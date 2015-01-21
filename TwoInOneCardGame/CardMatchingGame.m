//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ken Zhou on 16/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"



@implementation CardMatchingGame

-(id)init{
    self = [self initWithCardCount:[PlayingCardDeck maxCardCount] usingDeck:[[PlayingCardDeck alloc] init]];
    return self;
}


- (gameModeType)gameMode{
    if (!_gameMode){
        _gameMode = kTwoCardMode;
    }
    return _gameMode;
}



#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void) flipCardAtIndex:(NSUInteger)index{
    self.gameStarted = YES;
    Card *card = [self cardAtIndex:index];
    if (!card.faceUp) {
        if (card && !card.isUnplayable) {
            NSMutableArray *validOtherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    //construct two different otherCards array based on the game mode
                    [validOtherCards addObject:otherCard];
                    if ([validOtherCards count] < self.gameMode + 1) {
                        continue;
                    }
                    else{
                        break;
                    }
                }
            }
            
            if ([validOtherCards count] == self.gameMode + 1) {
                int matchScore = [card match:validOtherCards];
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *c in validOtherCards) {
                        c.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    
                }
                else{
                    for (Card *c in validOtherCards) {
                        c.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                }
                
                NSString *verboseString;
                
                verboseString = [NSString stringWithFormat:@"Card %@ %@", card.contents, matchScore? @"matches " : @"mismatches "];
                
                for (Card *c in validOtherCards) {
                    verboseString = [verboseString stringByAppendingString:[NSString stringWithFormat:@"%@Card %@", (c == validOtherCards.firstObject)?@"" : @", ", c.contents]];
                }
                
                verboseString = [verboseString stringByAppendingString:[NSString stringWithFormat:@" for %d", matchScore?matchScore* MATCH_BONUS : -MISMATCH_PENALTY]];
                
                self.verbose = [[NSAttributedString alloc] initWithString:verboseString];
                
            }
         
            
     
            
            self.score -= FLIP_COST;
        }
        
    }
    card.faceUp = !card.isFaceUp;
}




@end
