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
                cardView.suit = card.suit;
                cardView.rank = card.rank;
                cardView.unplayable = card.unplayable;
                cardView.faceUp = card.faceUp;
                cardView.matchStatus = card.matchStatus;
                
                [cardView setTag:indexPath.row];
            }
        }
    }
    
    return cell;
}

- (IBAction)flipCardAction:(id)sender {
    //get the indexpath of the card get flliped
    UITapGestureRecognizer *tapRecongnizer = (UITapGestureRecognizer *)sender;
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:[tapRecongnizer locationInView:self.cardCollectionView]];
    
    
    if (indexPath) {
        //call the flip card from the Game model with specific index
        Card *cardBeforeFlip = [self.game cardAtIndex:indexPath.row];
        BOOL beforeFlipCardFace = [cardBeforeFlip isFaceUp];
        BOOL beforeFlipCardUnplayable = [cardBeforeFlip isUnplayable];
        [self.game flipCardAtIndex:indexPath.row];
        if (![[self.game cardAtIndex:indexPath.row] isFaceUp] == beforeFlipCardFace && !beforeFlipCardUnplayable) {
            [self updateCell:[self.cardCollectionView cellForItemAtIndexPath:indexPath] usingCard:[self.game cardAtIndex:indexPath.row] animation:YES];
        }
        
        
    }
    
    [self updateUI];
   
    
    //remember the animation should only happen for that spcific cell, could be resolved by adding that selected/flipped card window
}



-(void)updateUI{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];

        [self updateCell:cell usingCard:card animation:NO];
    }
    
    //update other data label on the screen
    
    //update score
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    
}


-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animation:(BOOL)animation{
    
    
        
    
        
        for (MatchCardView *cardView in cell.contentView.subviews) {
            if ([cardView isKindOfClass:[MatchCardView class]]) {
                PlayingCard *pc = (PlayingCard *)card;
                
                if (!animation) {
                    cardView.suit = pc.suit;
                    cardView.faceUp = pc.faceUp;
                    cardView.rank = pc.rank;
                    cardView.unplayable = pc.unplayable;
                    cardView.matchStatus = pc.matchStatus;
                }
                else{
                    [UIView transitionWithView:cardView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromRight
                                    animations:^{
                                        cardView.suit = pc.suit;
                                        cardView.faceUp = pc.faceUp;
                                        cardView.rank = pc.rank;
                                        cardView.unplayable = pc.unplayable;
                                        cardView.matchStatus = pc.matchStatus;
                                    }
                                    completion:nil];
                    
                }
                
                
            }
        }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.game = [[CardMatchingGame alloc] init];
}



@end
