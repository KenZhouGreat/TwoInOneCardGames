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

@implementation SetCardGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 0

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
                    for (Card *c in validOtherCards) {
                        c.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    
                }
                else{
                    for (Card *c in [validOtherCards arrayByAddingObject:card] ) {
                        c.faceUp = !c.faceUp;
                    }
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

@end
