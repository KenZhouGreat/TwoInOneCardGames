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
    
    //if there is unmatched card remain faceUp clean it
    NSMutableArray *unmatchedCards = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable && card.matchStatus == MatchedStatusUnmatched) {
            //construct two different otherCards array based on the game mode
            [unmatchedCards addObject:card];
        }
    }
    
    if (unmatchedCards.count > 0) {
        for (Card *c in unmatchedCards) {
            c.faceUp = NO;
            c.matchStatus = MatchStatusNone;
        }
    }
    else{
        
        //otherwise do the flip
        if (!card.isUnplayable) {
            
            
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
                    
                    card.matchStatus = MatchStatusNone;
                    
                    if ([validOtherCards count] == self.gameMode + 1) {
                        int matchScore = [card match:validOtherCards];
                        if (matchScore) {
                            card.unplayable = YES;
                            card.matchStatus = MatchStatusMatched;
                            for (Card *c in validOtherCards) {
                                c.unplayable = YES;
                                c.matchStatus = MatchStatusMatched;
                            }
                            self.score += matchScore * MATCH_BONUS;
                            
                        }
                        else{
                            card.matchStatus = MatchedStatusUnmatched;
                            for (Card *c in validOtherCards) {
                                
                                c.matchStatus = MatchedStatusUnmatched;
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
    }
}




@end
