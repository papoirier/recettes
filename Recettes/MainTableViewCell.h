//
//  MainTableViewCell.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/6/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell {
    CGPoint  offset;
}

@property (nonatomic, retain) UIImageView   * recipeImageView;
@property (nonatomic, retain) UITextView    * recipeTitleLabel;
@property (nonatomic, retain) UILabel       * recipeTotalTimeLabel;

@property (nonatomic, retain) UIView        * darkSelectedView;

@property (nonatomic, retain) UIView        * underCover;
@property (nonatomic, retain) UIView        * cover;
@property (nonatomic, retain) UILabel       * underCoverLabel;

#define CELL_HEIGHT 100
#define VOMIT_COLOR [UIColor colorWithRed:1 green:0.5 blue:0.2 alpha:0.5]

@end
