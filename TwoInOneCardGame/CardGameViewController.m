//
//  CardGameViewController.m
//  TwoInOneCardGame
//
//  Created by Ken Zhou on 17/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardGameViewController_Protected.m"
#import "CardMatchingGame.h"

@interface CardGameViewController ()








@end

#define NUMBER_OF_INITIAL_CELLS 10

@implementation CardGameViewController

-(CardGame *)game{
    if (!_game) {
        _game = [[CardGame alloc] initWithCardCount:NUMBER_OF_INITIAL_CELLS usingDeck:[[Deck alloc] init]];
    }
    return _game;
}


#pragma mark - collectionView delegates and datasources
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return NUMBER_OF_INITIAL_CELLS;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIButton *aButton = [cell.contentView subviews][0];
    if (aButton) {
        aButton.tag = indexPath.row;
        [aButton setTitle:@"Default" forState:UIControlStateNormal];
    }
    
    
    return cell;
}




#pragma mark IBActions
- (IBAction)reDealCards:(id)sender {
    //UIAlertView confirmation
    //Re deal cards
    [[[UIAlertView alloc] initWithTitle:@"Are you sure to quit?"
                               message:@"By clicking the 'Ok', the whole game will be reset."
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil] show];
}

- (IBAction)flipCard:(id)sender {
    UIButton *aButton = (UIButton*)sender;
    NSLog(@"%ld", aButton.tag);
    [self updateUI];
}




#pragma alertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        NSLog(@"button ok clicked");
#warning implement redeal logic
    }
}

#pragma mark - UI updates
- (void)updateUI{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"You should override this method in the subclass"
                                 userInfo:nil];
}

-(void)updateCell:(UICollectionViewCell *)cell
        usingCard:(Card *)card
        animation:(BOOL)animation
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"You should override this method in the subclass"
                                 userInfo:nil];
}



#pragma mark - lifecycle calls

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


@end
