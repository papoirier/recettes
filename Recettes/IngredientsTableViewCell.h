//
//  IngredientsTableViewCell.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/30/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientsTableViewCell : UITableViewCell

@property (nonatomic, retain) UITextView    * ingredientNameLabel;
@property (nonatomic, retain) UITextView    * ingredientQuantityLabel;
@property (nonatomic, retain) UIView        * underCover;
@property (nonatomic, retain) UIView        * cover;
@property (nonatomic, retain) UILabel       * underCoverLabel;

#define INGREDIENT_CELL_HEIGHT 60

@end
