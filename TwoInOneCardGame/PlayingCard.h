//
//  PlayingCard.h
//  Matchismo
//
//  Created by Ken Zhou on 3/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;


+(NSArray *)validSuits;
+(NSUInteger)maxRank;


@end
