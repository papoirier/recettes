//
//  PassthroughView.m
//  Otsuka
//
//  Created by Todd Vanderlin on 5/1/12.
//  Copyright (c) 2012 Interactive Design. All rights reserved.
//

#import "PassthroughView.h"

@implementation PassthroughView

@synthesize passer;

// -----------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

// -----------------------------------------------------------------
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        return passer;
    }    
    return nil;
}

@end
