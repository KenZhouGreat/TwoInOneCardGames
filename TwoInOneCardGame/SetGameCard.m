//
//  SetGameCard.m
//  Matchismo
//
//  Created by Ken Zhou on 9/12/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "SetGameCard.h"


@interface SetGameCard()
@property (nonatomic, readwrite) NSAttributedString *attributedContent;

@end

@implementation SetGameCard



@synthesize attributedContent = _attributedContent;

- (NSAttributedString*) attributedContent{
    if (!_attributedContent) {
        NSString *baseString;
        NSString *patternString;
        //set shape
        
        if (self.shade != SetShadeNone ) {
            switch (self.shape) {
                case SetShapeCircle:
                    baseString = @"●";
                    break;
                    
                case SetShapeSquare:
                    baseString = @"■";
                    break;
                    
                case SetShapeTriangle:
                    baseString = @"▲";
                    break;
                    
                default:
                    break;
            }
            
        }
        else{
            switch (self.shape) {
                    
                case SetShapeCircle:
                    baseString = @"○";
                    break;
                    
                case SetShapeSquare:
                    baseString = @"◻︎";
                    break;
                    
                case SetShapeTriangle:
                    baseString = @"△";
                    break;
                    
                default:
                    break;
                    
            }
        }
        
        patternString = baseString;
        //set number
        for (int i = 1; i < self.number; i++) {
            patternString = [patternString stringByAppendingString:baseString];
        }
        
        //set shade
        float shadeAlpha;
        switch (self.shade) {
            case SetShadeShadowed:
                shadeAlpha = 0.2f;
                break;
                
            case SetShadeSolid:
                shadeAlpha = 1.0f;
                break;
                
            default:
                shadeAlpha = 1.0f;
                break;
        }

        //set colour
        UIColor *patternColour;
        switch (self.colour) {
            case SetColourBlue:
                patternColour = [UIColor blueColor];
                break;
                
            case SetColourGreen:
                patternColour = [UIColor greenColor];
                break;
                
            case SetColourRed:
                patternColour = [UIColor redColor];
                break;
                
            default:
                break;
        }
        
        //setting the attributes for the nsattributed string which stands for the card face
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary: @{NSForegroundColorAttributeName:[patternColour colorWithAlphaComponent:shadeAlpha], NSFontAttributeName: [UIFont systemFontOfSize: [UIFont systemFontSize]]}];
        
        if ([baseString  isEqual: @"●"] ) {
            [attr setObject:[UIFont systemFontOfSize: [UIFont systemFontSize] + 10] forKey:NSFontAttributeName];
        }
        
        if ([baseString  isEqual: @"◻︎"]){
            [attr setObject:[UIFont systemFontOfSize: [UIFont systemFontSize] + 5] forKey:NSFontAttributeName];
        }
        
        
        
        _attributedContent = [[NSAttributedString alloc] initWithString:patternString attributes:attr];
        
    }
    return _attributedContent;
}


- (int)match:(NSArray *)otherCards{
    int score = 0;
    
    //match rules
    //either three cards of the same kind or every card is of a different kind from each other
    
    //add self card into otherCards array make a new array
    //for each aspect create a bool array which record the times of a type emerged
    //the count of "YES" for each aspect should be either 1 or the count of the types
    
    NSArray *potentialCardSet = [otherCards arrayByAddingObject:self];
    
    BOOL shapeBits[LastShape+1];
    for (int i = 0; i <= LastShape; i++) {
        shapeBits[i] = NO;
    }
    
    BOOL colourBits[LastColour+1];
    for (int i = 0; i <= LastColour; i++) {
        colourBits[i] = NO;
    }
    
    BOOL shadeBits[LastShade+1];
    for (int i = 0; i <= LastShade; i++) {
        shadeBits[i] = NO;
    }
    
    BOOL numberBits[3];
    for (int i = 0; i < 3; i++) {
        numberBits[i] = NO;
    }
    
    
    for (SetGameCard *sc in potentialCardSet) {
        shapeBits[sc.shape] = YES;
        colourBits[sc.colour] = YES;
        shadeBits[sc.shade] = YES;
        numberBits[sc.number-1] = YES;
    }
    
    //shape match
    int shapeKindCount = 0;
    for (int i = 0; i <= LastShape; i++) {
        if (shapeBits[i]) {
            shapeKindCount++;
        }
    }
    
    //if kind number is not one or not number of kinds return 0 indicates a mismatch
    if (shapeKindCount != 1 && shapeKindCount != LastShape + 1) {
        return 0;
    }
    
    //colour match
    int colourKindCount = 0;
    for (int i = 0; i <= LastColour; i++) {
        if (colourBits[i]) {
            colourKindCount++;
        }
    }
    
    if (colourKindCount != 1 && colourKindCount != LastColour + 1) {
        return 0;
    }
    
    //shade match
    int shadeKindCount = 0;
    for (int i = 0; i <= LastShade; i++) {
        if (shadeBits[i]) {
            shadeKindCount++;
        }
    }
    
    if (shadeKindCount != 1 && shadeKindCount != LastShade + 1) {
        return 0;
    }
    
    //number match
    int numberCount = 0;
    for (int i = 0; i < 3; i++) {
        if (numberBits[i]) {
            numberCount++;
        }
    }
    
    if (numberCount != 1 && numberCount != 3) {
        return 0;
    }
    
    score = 5;
    
    return score;
}




@end
