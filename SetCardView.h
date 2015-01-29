//
//  SetGameCardView.h
//  LabSetCardFace
//
//  Created by Ken Zhou on 29/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetGameCard.h"

@interface SetCardView : UIView

@property (nonatomic) int number;
@property (nonatomic) ColourType colourType;
@property (nonatomic) ShadeType shadeType;
@property (nonatomic) ShapeType shapeType;

@end
