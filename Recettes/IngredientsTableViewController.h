//
//  IngredientsTableViewController.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/30/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsTableViewCell.h"

@interface IngredientsTableViewController : UITableViewController {
    CGPoint                    offset;
    IngredientsTableViewCell * cellRef;
        NSIndexPath          * sourceIndex;
}

@property (nonatomic, retain) NSMutableArray         * data;
@property (nonatomic, retain) UIPanGestureRecognizer * pan;

- (id)initWithIngredients:(NSMutableArray *)ingredients;

@end
