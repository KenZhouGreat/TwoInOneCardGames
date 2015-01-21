//
//  CardGame_Protected.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 17/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardGame ()

@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; //of card
@property (readwrite, nonatomic, getter = isGameStarted) BOOL gameStarted;
@property (nonatomic, readwrite) NSAttributedString *verbose;


@end
