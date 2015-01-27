//
//  Card.h
//  Matchismo
//
//  Created by Ken Zhou on 2/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    FirstMatchStatus = 1,
    MatchStatusNone = FirstMatchStatus,
    MatchStatusMatched,
    MatchedStatusUnmatched,
    LastMatchStatus = MatchedStatusUnmatched
}CardMatchStatus;

@interface Card : NSObject



@property (nonatomic, strong) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;
@property (nonatomic) CardMatchStatus matchStatus;
@property (nonatomic, getter = isCompared) BOOL compared;

-(int)match: (NSArray *)otherCards;

@end
