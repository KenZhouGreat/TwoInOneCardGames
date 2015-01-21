//
//  FirstViewController.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 17/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "MatchGameViewController.h"
#import "CardMatchingGame.h"
#import "MatchCardView.h"

@interface MatchGameViewController ()

@end

@implementation MatchGameViewController

#define NUMBER_OF_INITIAL_CELLS 24



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return NUMBER_OF_INITIAL_CELLS;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    if (cell) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[MatchCardView class]]) {
                MatchCardView *cardView = (MatchCardView *)view;
                PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:indexPath.row];
                card.faceUp = YES;
                [cardView setCard:card];
            }
        }
    }
    
    return cell;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.game = [[CardMatchingGame alloc] init];
}



@end
