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

#define NUMBER_OF_INITIAL_CELLS 81

@implementation SetGameViewController

@synthesize game = _game;

- (CardGame *)game{
    if (!_game) {
        _game = [[SetCardGame alloc] init];
    }
    return _game;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger remainingNumberOfCards = [self.game cardsLeft];
    return remainingNumberOfCards < NUMBER_OF_INITIAL_CELLS ? remainingNumberOfCards : NUMBER_OF_INITIAL_CELLS;
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
//                cardView.matchStatus = card.matchStatus;
//                [cardView setTag:indexPath.row];
            }
        }
    }
    
    return cell;
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
