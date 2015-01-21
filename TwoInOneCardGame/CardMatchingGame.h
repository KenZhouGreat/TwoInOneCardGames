//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ken Zhou on 16/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "CardGame.h"
#import "CardGame_Protected.m"


typedef enum {
    kTwoCardMode,
    kThreeCardMode
}gameModeType;

@interface CardMatchingGame : CardGame


@property (nonatomic) gameModeType gameMode;


- (id)init;


@end
