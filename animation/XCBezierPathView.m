//
//  XCBezierPathView.m
//  animation
//
//  Created by JohnnyPan on 15/12/25.
//  Copyright © 2015年 JohnnyPan. All rights reserved.
//

#import "XCBezierPathView.h"

@implementation XCBezierPathView

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.path stroke];
    
    
}


@end
