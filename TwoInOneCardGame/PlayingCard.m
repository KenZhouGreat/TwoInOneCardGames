//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ken Zhou on 3/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


-(int)match:(NSArray *)otherCards
{
    int score = 0;
    BOOL continueRankComparison = YES;
    BOOL continueSuitComparison = YES;
    
    for (PlayingCard *pc in otherCards) {
        
        if (![[pc suit] isEqualToString:[self suit]]) {
            continueSuitComparison = NO;
        }
        
        if (pc.rank != self.rank) {
             continueRankComparison = NO;
        }
        
        if (!continueSuitComparison && !continueRankComparison) {
            break;
        }
   
    }
    
    if (continueRankComparison) {
        score = otherCards.count * 3;
    }
    
    if (continueSuitComparison) {
        score = otherCards.count;
    }

    return score;
}


-(NSString *)contents
{
    return [[PlayingCard rankStrings][[self rank]] stringByAppendingString: [self suit]];
}



+(NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    rankStrings =[[NSArray alloc] initWithObjects:@"?"
                  ,@"A", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                  @"J",@"Q",@"K",nil];
    return rankStrings;
}


@synthesize suit = _suit;

- (void) setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit? _suit : @"?";
}


+(NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if(!validSuits) validSuits = @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
    return validSuits;
}

+(NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

@end
