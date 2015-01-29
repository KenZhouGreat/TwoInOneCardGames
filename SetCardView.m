//
//  SetGameCardView.m
//  LabSetCardFace
//
//  Created by Ken Zhou on 29/01/2015.
//  Copyright (c) 2015 Ken Zhou. All rights reserved.
//

#import "SetCardView.h"

#define PATTERN_SIZE_FACTOR 4
#define PATTERN_STROKE_WIDTH 1
#define PATTERN_SPACING self.bounds.size.width/20

@implementation SetCardView

- (void)setShadeType:(ShadeType)shadeType{
    _shadeType = shadeType;
    [self setNeedsDisplay];
}

- (void)setNumber:(int)number{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShapeType:(ShapeType)shapeType{
    _shapeType = shapeType;
    [self setNeedsDisplay];
}

- (void)setColourType:(ColourType)colourType{
    _colourType = colourType;
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //card frames
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5];
    [CLR_WASH_GREEN setStroke];
    [[UIColor whiteColor] setFill];
    [framePath addClip];
    [framePath fill];
    

    
    UIBezierPath *innerFramePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 2, 2) cornerRadius:5];
    
    
    [innerFramePath addClip];
    
    
    
    //decide shade & colour
    CGFloat alphaComponent = 0;
    if (self.shapeType == SetShadeNone) {
        alphaComponent = 0;
    }
    else if(self.shapeType == SetShadeSolid){
        alphaComponent = 1;
    }
    else if(self.shapeType == SetShadeShadowed){
        alphaComponent = 0.2;
    }
    //set fill & stroke
    if (self.colourType == SetColourPurple) {
        [[[UIColor purpleColor] colorWithAlphaComponent:alphaComponent] setFill];
        [[UIColor purpleColor] setStroke];
    }
    if (self.colourType == SetColourRed){
        [[[UIColor redColor] colorWithAlphaComponent:alphaComponent] setFill];
        [[UIColor redColor] setStroke];
    }
    if (self.colourType == SetColourGreen){
        [[[UIColor greenColor] colorWithAlphaComponent:alphaComponent] setFill];
        [[UIColor greenColor] setStroke];
    }
    
    //decide shape & number
    if (self.shapeType == SetShapeDimond) {
        [self drawDimondWithNumber:self.number];
    }
    else if(self.shapeType == SetShapeSquiggle){
        [self drawSquiggleWithNumber:self.number];
    }
    else if(self.shapeType == SetShapeOval){
        [self drawOvalWithNumber:self.number];
    }
    
    [framePath setLineWidth:2];
    [framePath stroke];
    [innerFramePath setLineWidth:2];
    [innerFramePath stroke];

    
//    [[UIColor greenColor] setStroke];
//    UIBezierPath *newPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(self.bounds.size.width/2 - 1, self.bounds.size.height/2 - 1, 2, 2) cornerRadius:2];
//    [newPath stroke];
    
}





- (void)drawDimondWithNumber:(int) number{
    
    if (number == 1) {
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth/2, centerPointInBounds.y - elementHeight/2);
        
        [self drawDimondAtPoint:elementOrigin];
    }
    if (number == 2) {
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth - PATTERN_SPACING/2, centerPointInBounds.y - elementHeight/2);
        [self drawDimondAtPoint:elementOrigin];
        
        //translate context to right
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, elementWidth + PATTERN_SPACING, 0);
        [self drawDimondAtPoint:elementOrigin];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
        
        
        
    }
    if (number == 3) {
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth/2, centerPointInBounds.y - elementHeight/2);
        [self drawDimondAtPoint:elementOrigin];
        
        
        //translate context to left
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, - elementWidth - PATTERN_SPACING, 0);
        [self drawDimondAtPoint:elementOrigin];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());

        
        //translate context to right
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, elementWidth + PATTERN_SPACING, 0);
        [self drawDimondAtPoint:elementOrigin];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
    
    
}

- (void)drawDimondAtPoint:(CGPoint) p{
    CGFloat width = self.bounds.size.width;
    CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
    CGFloat height = self.bounds.size.height;
    CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
    
    
    UIBezierPath *dimondPath = [[UIBezierPath alloc] init];
    [dimondPath moveToPoint:CGPointMake(p.x + elementWidth/2, p.y)];
    [dimondPath addLineToPoint:CGPointMake(p.x, p.y + elementHeight/2)];
    [dimondPath addLineToPoint:CGPointMake(p.x + elementWidth/2, p.y + elementHeight)];
    [dimondPath addLineToPoint:CGPointMake(p.x + elementWidth, p.y + elementHeight/2)];
    [dimondPath closePath];
    [dimondPath setLineWidth:PATTERN_STROKE_WIDTH];
    [dimondPath stroke];
    [dimondPath fill];
}


- (void)drawSquiggleWithNumber: (int)number{
    if (number == 1) {
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth/2, centerPointInBounds.y - elementHeight/2);
        
        [self drawSquiggleAtPoint:elementOrigin];
    }
    if (number == 2) {
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth - PATTERN_SPACING/2, centerPointInBounds.y - elementHeight/2);
        [self drawSquiggleAtPoint:elementOrigin];
        
        //translate context to right
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, elementWidth + PATTERN_SPACING, 0);
        [self drawSquiggleAtPoint:elementOrigin];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
        
        
        
    }
    if (number == 3) {
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth/2, centerPointInBounds.y - elementHeight/2);
        [self drawSquiggleAtPoint:elementOrigin];
        
        
        //translate context to left
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, - elementWidth - PATTERN_SPACING, 0);
        [self drawSquiggleAtPoint:elementOrigin];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
        
        
        //translate context to right
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, elementWidth + PATTERN_SPACING, 0);
        [self drawSquiggleAtPoint:elementOrigin];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}


- (void)drawSquiggleAtPoint:(CGPoint) p{
    CGFloat width = self.bounds.size.width;
    CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
    CGFloat height = self.bounds.size.height;
    CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
    
    UIBezierPath *squigglePath = [[UIBezierPath alloc] init];
    [squigglePath moveToPoint:CGPointMake(p.x + elementWidth/4, p.y)];
    [squigglePath addQuadCurveToPoint:CGPointMake(p.x+elementWidth/4, p.y+elementHeight/4 * 3) controlPoint:CGPointMake(p.x + elementWidth/2, p.y + elementHeight /4)];
    [squigglePath addQuadCurveToPoint:CGPointMake(p.x+elementWidth/4 * 3, p.y+elementHeight) controlPoint:CGPointMake(p.x + elementWidth/2, p.y + elementHeight)];
    [squigglePath addQuadCurveToPoint:CGPointMake(p.x+elementWidth/4 * 3, p.y+elementHeight/4) controlPoint:CGPointMake(p.x + elementWidth/2, p.y + elementHeight/4*3)];
    [squigglePath addQuadCurveToPoint:CGPointMake(p.x+elementWidth/4, p.y) controlPoint:CGPointMake(p.x + elementWidth/2, p.y )];
    [squigglePath setLineWidth:PATTERN_STROKE_WIDTH];
    [squigglePath stroke];
    [squigglePath fill];
    
}


- (void)drawOvalWithNumber:(int) number{
    if (number == 1) {
        
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth/2, centerPointInBounds.y - elementHeight/2);
        [self drawOvalAtPoint:elementOrigin];
    }
    if (number == 2) {
        
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth - PATTERN_SPACING/2, centerPointInBounds.y - elementHeight/2);
        [self drawOvalAtPoint:elementOrigin];
        
        //translate context to right
        CGContextRef context =  UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, elementWidth + PATTERN_SPACING, 0);
        [self drawOvalAtPoint:elementOrigin];
        CGContextRestoreGState(context);
        
        
    }
    if (number == 3){
        
        CGFloat width = self.bounds.size.width;
        CGFloat elementWidth = width / PATTERN_SIZE_FACTOR;
        CGFloat height = self.bounds.size.height;
        CGFloat elementHeight = height / PATTERN_SIZE_FACTOR;
        CGPoint centerPointInBounds = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) ;
        CGPoint elementOrigin = CGPointMake(centerPointInBounds.x - elementWidth/2, centerPointInBounds.y - elementHeight/2);
        [self drawOvalAtPoint:elementOrigin];
        
        //translate context to left
        CGContextRef context =  UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, - elementWidth - PATTERN_SPACING, 0);
        [self drawOvalAtPoint:elementOrigin];
        CGContextRestoreGState(context);
        
        //translate context to right
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, elementWidth + PATTERN_SPACING, 0);
        [self drawOvalAtPoint:elementOrigin];
        CGContextRestoreGState(context);
        
        
        

        
        
    }
    
    
}


- (void)drawOvalAtPoint:(CGPoint) p{
    //push context
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    
    CGRect ovalRect = CGRectMake(p.x, p.y, self.bounds.size.width/PATTERN_SIZE_FACTOR, self.bounds.size.height/PATTERN_SIZE_FACTOR);
    
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    [ovalPath setLineWidth:PATTERN_STROKE_WIDTH];
    [ovalPath stroke];
    [ovalPath fill];
    
    
    //pop context
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}


@end
