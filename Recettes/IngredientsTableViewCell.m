//
//  IngredientsTableViewCell.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/30/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "IngredientsTableViewCell.h"
#import "AppUtils.h"
#import "Fonts.h"

@implementation IngredientsTableViewCell

@synthesize underCover, underCoverLabel, cover, ingredientNameLabel, ingredientQuantityLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float width = self.frame.size.width;
        float textPush = INGREDIENT_CELL_HEIGHT/2 - 16;
        
        CGRect cellRect = CGRectMake(0, 0, width, INGREDIENT_CELL_HEIGHT);
        
        #pragma mark - under the cell
        underCover = [[UIView alloc] initWithFrame:cellRect];
        
        underCoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INGREDIENT_CELL_HEIGHT/2 - INGREDIENT_CELL_HEIGHT/2.65, width/2, INGREDIENT_CELL_HEIGHT*4.0/5.0)];
        underCoverLabel.font = BROWN_BOLD_14;
        underCoverLabel.text = @"DONE \nDID IT!";
        underCoverLabel.numberOfLines = 0;
        
        [underCover addSubview:underCoverLabel];
        [self addSubview:underCover];
        
        // -----------------------------------------------------------------------
        #pragma mark - all the contents of the cell
        cover = [[UIView alloc] initWithFrame:cellRect];
        //cover.backgroundColor = [UIColor greenColor];
        [self addSubview:cover];
        
        // -----------------------------------------------------------------------
        #pragma mark - ingredient name
        ingredientNameLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, textPush, width*0.66, INGREDIENT_CELL_HEIGHT)];
        ingredientNameLabel.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.paragraphSpacing = 0;
        pStyle.maximumLineHeight = 18;
        pStyle.headIndent = 0;
        pStyle.alignment = NSTextAlignmentLeft;
        NSDictionary * nameTextViewAttributes = @{NSFontAttributeName: BROWN_18,
                                                   NSForegroundColorAttributeName: [UIColor blackColor],
                                                   NSParagraphStyleAttributeName: pStyle};
        NSAttributedString * nameAttributedString = [[NSAttributedString alloc] initWithString:@" " attributes:nameTextViewAttributes];
        ingredientNameLabel.attributedText = nameAttributedString;
        ingredientNameLabel.userInteractionEnabled = NO;
        [ingredientNameLabel actLikeTextLabel];
        [cover addSubview:ingredientNameLabel];
        
        // -----------------------------------------------------------------------
        #pragma mark - ingredient quantity
        ingredientQuantityLabel = [[UITextView alloc] initWithFrame:CGRectMake(width*0.66+10, textPush+4, width/3-10*2, INGREDIENT_CELL_HEIGHT)];
        ingredientQuantityLabel.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle * pStyleQty = [[NSMutableParagraphStyle alloc] init];
        pStyleQty.paragraphSpacing = 0;
        pStyleQty.maximumLineHeight = 14;
        pStyleQty.headIndent = 0;
        pStyleQty.alignment = NSTextAlignmentRight;
        NSDictionary * quantityTextViewAttributes = @{NSFontAttributeName: BROWN_14,
                                                   NSForegroundColorAttributeName: [UIColor blackColor],
                                                   NSParagraphStyleAttributeName: pStyleQty};
        NSAttributedString * quantityAttributedString = [[NSAttributedString alloc] initWithString:@" " attributes:quantityTextViewAttributes];
        ingredientQuantityLabel.attributedText = quantityAttributedString;
        ingredientQuantityLabel.userInteractionEnabled = NO;
        [ingredientQuantityLabel actLikeTextLabel];
        [cover addSubview:ingredientQuantityLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}



@end
