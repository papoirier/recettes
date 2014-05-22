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

#define TITLES_PADDING 12.0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect cellRect = CGRectMake(0, 0, self.frame.size.width, CELL_HEIGHT);
        

        #pragma mark - under the cell
        underCover = [[UIView alloc] initWithFrame:cellRect];
 
        underCoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CELL_HEIGHT/2 - CELL_HEIGHT/2.65, self.frame.size.width/2, CELL_HEIGHT*4.0/5.0)];
        underCoverLabel.font = BROWN_18;
        underCoverLabel.text = @"DONE \nDID \nIT!";
        underCoverLabel.numberOfLines = 0;

        [underCover addSubview:underCoverLabel];
        [self addSubview:underCover];
        
        // -----------------------------------------------------------------------
        #pragma mark - all the contents of the cell
        cover = [[UIView alloc] initWithFrame:cellRect];
        cover.backgroundColor = [UIColor blueColor];
        [self addSubview:cover];
        
        // -----------------------------------------------------------------------
        #pragma mark - recipe image
        recipeImageView = [[UIImageView alloc] initWithFrame:cellRect];
        recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [recipeImageView setClipsToBounds:YES];
        [cover addSubview:recipeImageView];
        
        // -----------------------------------------------------------------------
        #pragma mark - color of selected cell
        darkSelectedView = [[UIView alloc] initWithFrame:cellRect];
        [cover insertSubview:darkSelectedView aboveSubview:recipeImageView];
        
        // -----------------------------------------------------------------------
        #pragma mark - recipe title
        recipeTitleLabel = [[UITextView alloc] initWithFrame:CGRectMake(TITLES_PADDING, 0, self.frame.size.width-TITLES_PADDING*2, 70)];
        recipeTitleLabel.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.paragraphSpacing = 0;
        pStyle.maximumLineHeight = 24;
        pStyle.headIndent = 0;
        pStyle.alignment = NSTextAlignmentCenter;
        NSDictionary * stepsTextViewAttributes = @{NSFontAttributeName: BROWN_22, NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: pStyle};
        NSAttributedString * stepsAttributedString = [[NSAttributedString alloc] initWithString:@" " attributes:stepsTextViewAttributes];
        recipeTitleLabel.attributedText = stepsAttributedString;
        recipeTitleLabel.userInteractionEnabled = NO;
        [recipeTitleLabel actLikeTextLabel];
        [cover addSubview:recipeTitleLabel];
        
        // -----------------------------------------------------------------------
        #pragma mark - recipe total time
        recipeTotalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 20)];
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
    
    #pragma mark - color selected cell
    if (selected) {
        darkSelectedView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    } else {
        darkSelectedView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    }

}

@end
