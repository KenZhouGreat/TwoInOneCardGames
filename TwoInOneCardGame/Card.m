//
//  Card.m
//  Matchismo
//
//  Created by Ken Zhou on 2/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "Card.h"

@implementation Card

-(CardMatchStatus)matchStatus{
    if (!_matchStatus) {
        _matchStatus = MatchStatusNone;
    }
    return _matchStatus;
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *c in otherCards) {
        if ([[c contents] isEqualToString:[self contents]]) {
            score = 1;
        }
    }
    
    return score;
}

@end
