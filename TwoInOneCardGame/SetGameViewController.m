//
//  SecondViewController.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 17/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardGame.h"
#import "SetCardView.h"

@interface SetGameViewController ()

@end

#define NUMBER_OF_INITIAL_CELLS 12

@implementation SetGameViewController

@synthesize game = _game;

- (CardGame *)game{
    if (!_game) {
        _game = [[SetCardGame alloc] init];
    }
    return _game;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SetCardGame *thisGame = (SetCardGame *)self.game;
    NSInteger remainingNumberOfCards = [self.game cardsLeft];
    return remainingNumberOfCards < thisGame.numberOfCardsInCollectionView ? remainingNumberOfCards : thisGame.numberOfCardsInCollectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    if (cell) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[SetCardView class]]) {
                SetCardView *cardView = (SetCardView *)view;
                SetGameCard *card = (SetGameCard *)[self.game cardAtIndex:indexPath.row];
                cardView.number = card.number;
                cardView.shapeType = card.shape;
                cardView.shadeType = card.shade;
                cardView.colourType = card.colour;
                cardView.faceUp = card.faceUp;
                cardView.unplayable = card.unplayable;
                cardView.matchStatus = card.matchStatus;
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
        //update the card flipped
        if (![[self.game cardAtIndex:indexPath.row] isFaceUp] == beforeFlipCardFace && !beforeFlipCardUnplayable) {
            [self updateCell:[self.cardCollectionView cellForItemAtIndexPath:indexPath] usingCard:[self.game cardAtIndex:indexPath.row] animation:YES];
        }
        
        //update other cards
        
        //delete matched card and supply more cards if meet condition
        
        
    }
    [self updateUI];
    
    //wait for 3 seconds : issue an acynchronis call to delete the matched cells
    if ([[self.game indexesOfMatchedCards] count] > 0) {
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            NSUInteger cardCountBeforeUpdate = [self.game cardsLeft];
            [self.cardCollectionView performBatchUpdates:^(void){
                
                NSIndexSet *indexesOfMatchedCards = [self.game indexesOfMatchedCards];
                NSMutableArray *indexArrayToDelete = [[NSMutableArray alloc] init];
                [indexesOfMatchedCards enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
                    [indexArrayToDelete addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                }];
                
                
                [self.game cleanMatchedCards];
                [self.cardCollectionView deleteItemsAtIndexPaths:indexArrayToDelete];
                SetCardGame *thisGame = (SetCardGame *)self.game;
                for(int i = 0;i < [indexArrayToDelete count] ;i++){
                    thisGame.numberOfCardsInCollectionView--;
                }
//                if (thisGame.numberOfCardsInCollectionView <= [self.game cardsLeft]) {
//                    
//                    NSMutableArray *indexArrayToInsert = [[NSMutableArray alloc] init];
//                    for(int i = 0;i < [indexArrayToDelete count] ;i++){
//                        [indexArrayToInsert addObject:[NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:0] - i - 1  inSection:0]];
//                    }
//                    
//                    [self.cardCollectionView insertItemsAtIndexPaths:indexArrayToInsert];
//                }
//                else{
//                    NSMutableArray *indexArrayToInsert = [[NSMutableArray alloc] init];
//                    for(int i = 0;i < (int)( [indexArrayToDelete count] + [self.game cardsLeft] - thisGame.numberOfCardsInCollectionView) ;i++){
//                        [indexArrayToInsert addObject:[NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:0] - i - 1  inSection:0]];
//                    }
//                    
//                    [self.cardCollectionView insertItemsAtIndexPaths:indexArrayToInsert];
//                }
                
            }completion:^(BOOL hasCompleted){
                [self.lbl_cardsLeft setText:[NSString stringWithFormat:@"Cards left: %ld", [self.game cardsLeft]]];
                if ([self.game cardsLeft] == 0 && cardCountBeforeUpdate != 0) {
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

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animation:(BOOL)animation{

    for (SetCardView *cardView in cell.contentView.subviews) {
        if ([cardView isKindOfClass:[SetCardView class]]) {
            SetGameCard *sc = (SetGameCard *)card;
            cardView.faceUp = sc.faceUp;
            cardView.unplayable = sc.unplayable;
            cardView.matchStatus = sc.matchStatus;
            cardView.number = sc.number;
            cardView.shapeType = sc.shape;
            cardView.shadeType = sc.shade;
            cardView.colourType = sc.colour;           
        }
    }
    
}

- (void)updateUI{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        [self updateCell:cell usingCard:card animation:NO];
    }
    
    //update other data label on the screen
    
    //update score
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    [self.lbl_cardsLeft setText:[NSString stringWithFormat:@"Cards left: %ld", [self.game cardsLeft]]];
}

- (IBAction)requestNewCard:(id)sender {
    //insert three new cards if available
    SetCardGame *thisGame = (SetCardGame *)self.game;
    if ([self.game cardsLeft] - [self.cardCollectionView numberOfItemsInSection:0] >= 3){
        [self.cardCollectionView performBatchUpdates:^(void){
            NSMutableArray *indexArrayToInsert = [[NSMutableArray alloc] init];
            for(int i = 0;i < 3 ;i++){
                thisGame.numberOfCardsInCollectionView += 1;
                [indexArrayToInsert addObject:[NSIndexPath indexPathForRow:thisGame.numberOfCardsInCollectionView - 1 inSection:0]];
            }
            
            [self.cardCollectionView insertItemsAtIndexPaths:indexArrayToInsert];
            
        }completion:nil];
        
        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:0] - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        
        
    }
    else{
        [[[UIAlertView alloc] initWithTitle:nil message:@"There is no more cards!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
    
    [self updateUI];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
