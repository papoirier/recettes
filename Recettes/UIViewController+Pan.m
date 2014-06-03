//
//  UIViewController+Pan.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 6/3/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "UIViewController+Pan.h"

@implementation UITableViewController (UITableViewControllerExtension)

    /*
- (void)pan:(UIGestureRecognizer *)recognizer inTableView:(UITableView *)tableView withCellReference:(UITableViewCell *)cellRef withTouchPoint:(CGPoint)touchPoint withOffset:(CGPoint)offset
{

    CGRect originalFrame = cellRef.frame;
    float newX = touchPoint.x - offset.x;
    originalFrame.origin = CGPointMake(newX, 0);
    CGPoint translation = [recognizer.state translationInView:self.tableView];
    
    cellRef.underCover.alpha = 0;
    float openCellAlpha = 0;
    float w = self.view.frame.size.width;
    openCellAlpha = (translation.x * w) / (cellOpening*0.85);
    
    cellRef.underCover.alpha = openCellAlpha/w;
    cellRef.underCoverLabel.alpha = openCellAlpha/w;
    
    // clamping so it doesn't go left past 0
    if (originalFrame.origin.x < 0) {
        originalFrame.origin.x = 0;
    }
    
    else if (originalFrame.origin.x >= cellOpening) {
        originalFrame.origin.x = cellOpening;
    }
    
    cellRef.cover.frame = originalFrame;
    
}
     
      */

@end
