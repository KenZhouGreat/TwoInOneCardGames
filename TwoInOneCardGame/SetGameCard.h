//
//  SetGameCard.h
//  Matchismo
//
//  Created by Ken Zhou on 9/12/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "Card.h"

@interface SetGameCard : Card

typedef enum {
    FirstShape = 0,
    SetShapeTriangle = FirstShape,
    SetShapeSquare,
    SetShapeCircle,
    LastShape = SetShapeCircle
}ShapeType;

@property (nonatomic) ShapeType  shape;


typedef enum {
    FirstColour = 0,
    SetColourRed = FirstColour,
    SetColourGreen,
    SetColourBlue,
    LastColour = SetColourBlue
}ColourType;

@property (nonatomic) ColourType colour;

@property (nonatomic) int number;

typedef enum{
    FirstShade = 0,
    SetShadeSolid = FirstShade,
    SetShadeShadowed,
    SetShadeNone,
    LastShade = SetShadeNone
}ShadeType;

@property (nonatomic) ShadeType shade;

@property (nonatomic) BOOL isSelected;

@property (nonatomic, readonly) NSAttributedString *attributedContent;





@end


