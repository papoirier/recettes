//
//  MainTableViewController.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/5/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"

@interface MainTableViewController : UITableViewController {
    CGPoint             offset;
    MainTableViewCell * cellRef;
    NSIndexPath       * sourceIndex;
    UIBezierPath      * shadowPath;
}

@property (nonatomic, retain) NSMutableArray               * data;
@property (nonatomic, retain) UIPanGestureRecognizer       * pan;
@property (nonatomic, retain) UILongPressGestureRecognizer * longPress;

- (void)loadData;

@end
