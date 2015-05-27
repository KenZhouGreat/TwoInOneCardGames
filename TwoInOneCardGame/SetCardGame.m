//
//  SetCardGame.m
//  Matchismo
//
//  Created by Ken Zhou on 10/12/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "SetCardGame.h"
#import "CardGame_Protected.m"
#import "SetGameCard.h"
#import "SetGameCardDeck.h"


@interface SetGameCard()

@end


@implementation SetCardGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 0
#define NUMBER_OF_INITIAL_CELLS 12

@synthesize numberOfCardsInCollectionView = _numberOfCardsInCollectionView;

- (NSInteger)numberOfCardsInCollectionView{
    if(!_numberOfCardsInCollectionView){
        _numberOfCardsInCollectionView = NUMBER_OF_INITIAL_CELLS;
    }
    return _numberOfCardsInCollectionView;
}

- (id)init{
    self = [super initWithCardCount:[SetGameCardDeck maxNumberOfCards] usingDeck:[[SetGameCardDeck alloc] init]];
    return self;
}


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
        if (!card.isUnplayable) {
            
            
            if (!card.faceUp) {
                if (card && !card.isUnplayable) {
                    NSMutableArray *validOtherCards = [[NSMutableArray alloc] init];
                    for (Card *otherCard in self.cards) {
                        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                            //construct two different otherCards array based on the game mode
                            [validOtherCards addObject:otherCard];
                            if ([validOtherCards count] < 3) {
                                continue;
                            }
                            else{
                                break;
                            }
                        }
                    }
                    
                    if ([validOtherCards count] == 2) {
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
                            for (Card *c in [validOtherCards arrayByAddingObject:card] ) {
                                c.matchStatus = MatchedStatusUnmatched;
                            }
                            card.matchStatus = MatchedStatusUnmatched;
                            self.score -= MISMATCH_PENALTY;
                            
                        }
                        
                        //Matched A, B, C ... for score
                        //A, B, C don't match (Penalty - score)
                        
                        
                        NSString *formatString;
                        formatString = matchScore?@" matched for %d":@" don't match.(Penalty %d)";
                        NSString *verboseString = [NSString stringWithFormat:formatString, matchScore?matchScore* MATCH_BONUS : -MISMATCH_PENALTY];
                        
                        NSMutableAttributedString *cardSetString = [[NSMutableAttributedString alloc] initWithAttributedString:((SetGameCard *)card).attributedContent];
                        for (SetGameCard *sc in validOtherCards) {
                            [cardSetString appendAttributedString:[[NSAttributedString alloc] initWithString:@"&"]];
                            [cardSetString appendAttributedString:sc.attributedContent];
                        }
                        
                        
                        [cardSetString appendAttributedString:[[NSAttributedString alloc] initWithString:verboseString]];
                        
                        
                        
                        self.verbose = cardSetString;
                        
                    }
                    
                    self.score -= FLIP_COST;
                }
                
                
                
            }
            card.faceUp = !card.isFaceUp;
        }
    }
}

@end
