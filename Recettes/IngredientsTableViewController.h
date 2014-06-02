//
//  IngredientsTableViewController.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/30/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientsTableViewController : UITableViewController

- (id)initWithIngredients:(NSArray *)ingredients;

@property (nonatomic, retain) NSArray * data;

@end
