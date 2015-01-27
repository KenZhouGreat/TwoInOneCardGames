//
//  CardGameViewController_Protected.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 18/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGameViewController.h"
#import "CardGame.h"

@interface CardGameViewController()

@property (nonatomic, strong) CardGame *game;
@property (strong, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *dealButton;


-(void)updateCell:(UICollectionViewCell *)cell
        usingCard:(Card *)card
        animation:(BOOL)animation; //abstract

@end