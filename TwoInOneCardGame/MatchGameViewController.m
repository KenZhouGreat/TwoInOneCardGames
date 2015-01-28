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
@property (strong, nonatomic) IBOutlet UISegmentedControl *gameModeSelector;
@property (strong, nonatomic) IBOutlet UILabel *lbl_cardsLeft;

@end


@implementation MatchGameViewController

#define NUMBER_OF_INITIAL_CELLS 24

@synthesize game = _game;

- (CardGame *)game{
    if (!_game) {
        _game = [[CardMatchingGame alloc] init];
    }
    return _game;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger remainingNumberOfCards = [[self.game cards] count];
    return remainingNumberOfCards < NUMBER_OF_INITIAL_CELLS ? remainingNumberOfCards : NUMBER_OF_INITIAL_CELLS;
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
    
    //wait for 3 seconds : issue an acynchronis call to delete the matched cells
    if ([[self.game indexesOfMatchedCards] count] > 0) {
        
        
        
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            NSUInteger cardCountBeforeUpdate = [self.game.cards count];
            [self.cardCollectionView performBatchUpdates:^(void){
                
                NSIndexSet *indexesOfMatchedCards = [self.game indexesOfMatchedCards];
                NSMutableArray *indexArrayToDelete = [[NSMutableArray alloc] init];
                [indexesOfMatchedCards enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
                    [indexArrayToDelete addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                }];
                
                
                [self.game cleanMatchedCards];
                [self.cardCollectionView deleteItemsAtIndexPaths:indexArrayToDelete];
                
                if (NUMBER_OF_INITIAL_CELLS <= [self.game.cards count]) {
                    
                    NSMutableArray *indexArrayToInsert = [[NSMutableArray alloc] init];
                    for(int i = 0;i < [indexArrayToDelete count] ;i++){
                        [indexArrayToInsert addObject:[NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:0] - i - 1  inSection:0]];
                    }
                    
                    [self.cardCollectionView insertItemsAtIndexPaths:indexArrayToInsert];
                }
                else{
                    NSMutableArray *indexArrayToInsert = [[NSMutableArray alloc] init];
                    for(int i = 0;i < (int)( [indexArrayToDelete count] + [self.game.cards count] - NUMBER_OF_INITIAL_CELLS) ;i++){
                        [indexArrayToInsert addObject:[NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:0] - i - 1  inSection:0]];
                    }
                    
                    [self.cardCollectionView insertItemsAtIndexPaths:indexArrayToInsert];
                }
                
            }completion:^(BOOL hasCompleted){
                [self.lbl_cardsLeft setText:[NSString stringWithFormat:@"Cards left: %ld", [self.game.cards count]]];
                if ([self.game.cards count] == 0 && cardCountBeforeUpdate != 0) {
                    [[[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                message:@"You have matched all the cards! Click 'Ok' to start again."
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"Ok", nil] show];
                }
                
            }];
            
            
            
            
        });
        
    }
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        
//    }
//}


- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    CardMatchingGame *matchingGame = (CardMatchingGame *)self.game;
    matchingGame.gameMode = (gameModeType)sender.selectedSegmentIndex;
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
    
    self.gameModeSelector.enabled = !self.game.gameStarted;
    [self.gameModeSelector setSelectedSegmentIndex:[(CardMatchingGame *)self.game gameMode]];
    
    [self.lbl_cardsLeft setText:[NSString stringWithFormat:@"Cards left: %ld", [self.game.cards count]]];
    
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
   }



@end
