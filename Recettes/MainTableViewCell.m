//
//  MainTableViewCell.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/6/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "MainTableViewCell.h"
#import "UIImage+ImageEffects.h"
#import "AppUtils.h"
#import "Fonts.h"

@implementation MainTableViewCell

@synthesize recipeImageView, recipeTitleLabel, recipeTotalTimeLabel;
@synthesize darkSelectedView;
@synthesize underCover, cover, underCoverLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect cellRect = CGRectMake(0, 0, self.frame.size.width, CELL_HEIGHT);
        
        
        underCover = [[UIView alloc] initWithFrame:cellRect];
        //underCover.backgroundColor = [UIColor greenColor];
        
        underCoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CELL_HEIGHT/2 - CELL_HEIGHT/2.65, self.frame.size.width/2, CELL_HEIGHT*4.0/5.0)];
        underCoverLabel.font = BROWN_18;
        underCoverLabel.text = @"DONE \nDID \nIT!";
        underCoverLabel.numberOfLines = 0;

        [underCover addSubview:underCoverLabel];
        [self addSubview:underCover];

        cover = [[UIView alloc] initWithFrame:cellRect];
        cover.backgroundColor = [UIColor blueColor];
        [self addSubview:cover];
        

        recipeImageView = [[UIImageView alloc] initWithFrame:cellRect];
        recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
        //recipeImageView.backgroundColor= [UIColor orangeColor];
        [recipeImageView setClipsToBounds:YES];
        [cover addSubview:recipeImageView];
        
        darkSelectedView = [[UIView alloc] initWithFrame:cellRect];
        [cover insertSubview:darkSelectedView aboveSubview:recipeImageView];
        
        recipeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        //recipeTitleLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        recipeTitleLabel.font = BROWN_22;
        recipeTitleLabel.numberOfLines = 0;
        recipeTitleLabel.textAlignment = NSTextAlignmentCenter;
        recipeTitleLabel.textColor = [UIColor whiteColor];
        [cover addSubview:recipeTitleLabel];
        
        recipeTotalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 30)];
        //recipeTotalTimeLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        recipeTotalTimeLabel.font = BROWN_14;
        recipeTotalTimeLabel.numberOfLines = 0;
        recipeTotalTimeLabel.textAlignment = NSTextAlignmentCenter;
        recipeTotalTimeLabel.textColor = [UIColor whiteColor];
        [cover addSubview:recipeTotalTimeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        darkSelectedView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    } else {
        darkSelectedView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    }

}

@end
