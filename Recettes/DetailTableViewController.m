//
//  DetailTableViewController.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/5/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AppUtils.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

@synthesize detail;

#define HEIGHT self.view.frame.size.height
#define WIDTH self.view.frame.size.width
#define CELL_HEIGHT 44.0
#define IMAGE_HEIGHT 200

#define BROWN_14 [UIFont fontWithName:@"BrownStd-Regular" size:14]
#define INSET 10.0f

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [detail objectForKey:@"title"];
    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:220.0/255.0 alpha:1.0];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  // remove the extra cells
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------------
#pragma mark - STYLING THE PARAGRAPHS
// -----------------------------------------------------------------------

//- (CGFloat)applyParagraphAttributestoString:(NSString *)string
//{
//    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
//    float lineHeightMultiple = 1.2;
//    pStyle.paragraphSpacingBefore = 14 * lineHeightMultiple/2;
//    pStyle.maximumLineHeight = 14 * lineHeightMultiple;
//    pStyle.headIndent = INSET;
//    NSDictionary * textViewAttributes = @{NSFontAttributeName: BROWN_14, NSParagraphStyleAttributeName: pStyle};
//    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:string attributes:textViewAttributes];
//    CGRect attRect = [attributedString boundingRectWithSize:CGSizeMake(WIDTH, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    return abs(attRect.size.height) + (INSET*2);
//}

- (void)applyStyleToTextView:(UITextView *)textView withString:(NSString *)string andHeadIndent:(CGFloat)indent
{
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    float lineHeightMultiple = 1.2;
    pStyle.paragraphSpacing = 14 * lineHeightMultiple/2;
    //pStyle.paragraphSpacingBefore = 0;
    pStyle.maximumLineHeight = 14 * lineHeightMultiple;
    pStyle.headIndent = indent;
    NSDictionary * textViewAttributes = @{NSFontAttributeName: BROWN_14, NSParagraphStyleAttributeName: pStyle};
    textView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:textViewAttributes];
    [textView setContentInset:UIEdgeInsetsMake(-INSET, 30, 0, -30)];
    [textView actLikeTextLabel];
    [textView sizeToFit];
}




// -----------------------------------------------------------------------
#pragma mark - NUMBER OF SECTIONS
// -----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return detail == nil ? 0 : 1;
}

// -----------------------------------------------------------------------
#pragma mark - NUMBER OF ROWS IN SECTIONS
// -----------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

// -----------------------------------------------------------------------
#pragma mark - NUMBER OF ROWS IN SECTIONS
// -----------------------------------------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray  * ingredients = [detail objectForKey:@"ingredients"];
    NSString * ingredientsString = [ingredients componentsJoinedByString:@"\n"];
    NSArray  * steps = [detail objectForKey:@"steps"];
    NSString * stepsString = [steps componentsJoinedByString:@"\n"];
    
    float lineHeightMultiple = 1.2;
    float paragraphSpacing = 14.0 * lineHeightMultiple/2;
    
    if (indexPath.row == 0) {
        return IMAGE_HEIGHT;
    }
    else if (indexPath.row == 2) {
        NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.paragraphSpacing = paragraphSpacing;
        //pStyle.paragraphSpacingBefore = 0;
        pStyle.maximumLineHeight = 14 * lineHeightMultiple;
        pStyle.headIndent = INSET;
        NSDictionary * textViewAttributes = @{NSFontAttributeName: BROWN_14, NSParagraphStyleAttributeName: pStyle};
        NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:ingredientsString attributes:textViewAttributes];
        CGRect attRect = [attributedString boundingRectWithSize:CGSizeMake(WIDTH-INSET*2, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float numberOfIngredientsParagraphs = ingredients.count-1;
        //NSLog(@"%f", numberOfParagraphs);
        
        return abs(attRect.size.height) + numberOfIngredientsParagraphs*paragraphSpacing;
    }
    else if (indexPath.row == 3) {
        NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.paragraphSpacing = paragraphSpacing;
        //pStyle.paragraphSpacingBefore = 0;
        pStyle.maximumLineHeight = 14 * lineHeightMultiple;
        pStyle.headIndent = 0;
        NSDictionary * textViewAttributes = @{NSFontAttributeName: BROWN_14, NSParagraphStyleAttributeName: pStyle};
        NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:stepsString attributes:textViewAttributes];
        CGRect attRect = [attributedString boundingRectWithSize:CGSizeMake(WIDTH-INSET*2, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        float numberOfStepsParagraphs = steps.count-1;
        return abs(attRect.size.height) + numberOfStepsParagraphs*paragraphSpacing;
    }
    return CELL_HEIGHT;
    
}

// -----------------------------------------------------------------------
#pragma mark - CONSTRUCTING THE CELL
// -----------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect defaultCellRect       = CGRectMake(0, 0, WIDTH, CELL_HEIGHT);
    CGRect imageRect             = CGRectMake(0, 0, WIDTH, IMAGE_HEIGHT);
    CGRect textViewRect          = CGRectMake(INSET, 0, WIDTH-INSET*2, 0);
    //CGRect textViewRect          = CGRectMake(0, 0, WIDTH, 1);
    
    static NSString * detailCell = @"detailCell";
    UITableViewCell * cell       = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:detailCell];
    }
    
    // image
    if (indexPath.row == 0) {
        NSString * image = [detail objectForKey:@"image"];
        UIImageView * dImage = [[UIImageView alloc] initWithFrame:imageRect];
        //dImage.backgroundColor = [UIColor redColor];
        dImage.contentMode = UIViewContentModeScaleAspectFill;
        [dImage setClipsToBounds:YES];
        dImage.image = [UIImage imageNamed:image];
        [cell addSubview:dImage];
    }
    
    // prep time, total time
    else if (indexPath.row == 1) {
        NSString * prepTime = [detail objectForKey:@"prepTime"];
        UILabel * prepTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2, CELL_HEIGHT)];
        prepTimeLabel.text = [NSString stringWithFormat:@"%@ minutes", prepTime];
        prepTimeLabel.backgroundColor = [UIColor blueColor];
        prepTimeLabel.font = BROWN_14;
        NSString * totalTime = [detail objectForKey:@"totalTime"];
        UILabel * totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, CELL_HEIGHT)];
        totalTimeLabel.text = [NSString stringWithFormat:@"%@ minutes", totalTime];
        totalTimeLabel.backgroundColor = [UIColor purpleColor];
        totalTimeLabel.font = BROWN_14;
        
        [cell addSubview:prepTimeLabel];
        [cell addSubview:totalTimeLabel];
        
    }
    
    // ingredients
    else if (indexPath.row == 2) {
        cell.backgroundColor = [UIColor redColor];
        NSArray * ingredients = [detail objectForKey:@"ingredients"];
        NSString * ingredientsString = [ingredients componentsJoinedByString:@"\n"];
        UITextView * ingredientsTextView = [[UITextView alloc] initWithFrame:textViewRect];
        ingredientsTextView.backgroundColor = [UIColor lightGrayColor];
        [self applyStyleToTextView:ingredientsTextView withString:ingredientsString andHeadIndent:14];
        ingredientsTextView.tag = 222;
        [cell addSubview:ingredientsTextView];
    }
    
    // steps
    else if (indexPath.row == 3) {
        NSArray * steps = [detail objectForKey:@"steps"];
        NSString * stepsString = [steps componentsJoinedByString:@"\n"];
        UITextView * stepsTextView = [[UITextView alloc] initWithFrame:textViewRect];
        stepsTextView.backgroundColor = [UIColor greenColor];
        [self applyStyleToTextView:stepsTextView withString:stepsString andHeadIndent:0];
        stepsTextView.tag = 333;
        [cell addSubview:stepsTextView];
    }
    
    // author
    else if (indexPath.row == 4) {
        NSString * author = [detail objectForKey:@"author"];
        UILabel * dAuthor = [[UILabel alloc] initWithFrame:defaultCellRect];
        dAuthor.backgroundColor = [UIColor blueColor];
        dAuthor.text = author;
        dAuthor.font = BROWN_14;
        [cell addSubview:dAuthor];
    }
    
    // source
    else if (indexPath.row == 5) {
        UIButton * sourceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //sourceButton.backgroundColor = [UIColor blueColor];
        sourceButton.titleLabel.font = BROWN_14;
        [sourceButton setTitle:@"Source" forState:UIControlStateNormal];
        [sourceButton sizeToFit];
        sourceButton.tag = 444;
        [sourceButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:sourceButton];
    }
    
    return cell;
}

// ALERT FOR THE SOURCE BUTTON

- (void)buttonTouched:(id)sender {
    UIAlertView * sourceButtonAlert = [[UIAlertView alloc] initWithTitle:@"Open Safari?" message:@"You’ll leave this app" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open", nil];
    [sourceButtonAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString * source = [detail objectForKey:@"source"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:source]];
    }
}

@end
