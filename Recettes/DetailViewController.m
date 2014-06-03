//
//  DetailViewController.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/6/18.
//  Copyright (c) 2018 Pierre-Alexandre Poirier. All rights reserved.
//

#import "DetailViewController.h"
#import "AppUtils.h"
#import "Fonts.h"
#import "MainTableViewController.h"
#import "IngredientsTableViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize detail, scrollView;

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

#define INSET 18.0f
#define PADDING 5.0f
#define PADDING_LABEL 10.0f

float imageHeight, prepTimeHeight, ingredientsHeight, directionsHeight, authorHeight, sourceHeight, navBarHeight;
float totalHeight;
float rulePadHeight = 21.0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // title
    NSString * normalTitle = [detail objectForKey:NSLocalizedString(@"title", nil)];
    NSString * shortTitle = [detail objectForKey:NSLocalizedString(@"short_title", nil)];
    shortTitle != nil ? [self setTitle:shortTitle] : [self setTitle:normalTitle];
    
    
    // NAVIGATION BAR
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    // right button
    UIBarButtonItem * ingredientsListButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ingredients_title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(displayIngredientsList:)];
    self.navigationItem.rightBarButtonItem = ingredientsListButton;

    
    // HEIGHTS
    
    navBarHeight        = (20.0 + 44.0);
    imageHeight         = HEIGHT/2;
    prepTimeHeight      = 40.0;
    ingredientsHeight   = 0;
    directionsHeight    = 0;
    authorHeight        = 40.0;
    sourceHeight        = 40.0;
    
    // SCROLL VIEW
    
    CGRect scrollViewFrame = CGRectMake(0, 0, WIDTH, HEIGHT);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    // LOADING ALL CONTENT
    
    [self loadImageDetailsWithXPosition:0 andYPostition:-navBarHeight andWidth:WIDTH andHeight:imageHeight];
    
    [self loadPrepTimeDetailsWithXPosition:PADDING+1 andYPostition:imageHeight-navBarHeight+PADDING_LABEL andWidth:WIDTH/2 andHeight:prepTimeHeight];
    
    [self loadTotalTimeDetailsWithXPosition:(WIDTH/2)+PADDING andYPostition:imageHeight-navBarHeight+PADDING_LABEL andWidth:WIDTH/2 andHeight:prepTimeHeight];
    
    //[self loadIngredientDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight-navBarHeight+PADDING_LABEL andWidth:WIDTH andHeight:ingredientsHeight];
    
    [self loadDirectionsDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight+ingredientsHeight-navBarHeight+PADDING_LABEL andWidth:WIDTH andHeight:directionsHeight];
    
    [self loadSourceDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight+ingredientsHeight+directionsHeight-navBarHeight+PADDING_LABEL andWidth:WIDTH andHeight:sourceHeight];
    
    totalHeight = imageHeight + prepTimeHeight + ingredientsHeight + directionsHeight + authorHeight -navBarHeight+rulePadHeight*2;
    scrollView.contentSize = CGSizeMake(WIDTH, totalHeight);
    
}

// -----------------------------------------------------------------------
#pragma mark - DISPLAY INGREDIENTS LIST
// -----------------------------------------------------------------------

- (void)displayIngredientsList:(id)sender
{
    NSArray * ingredients = [detail objectForKey:@"ingredients"];
    IngredientsTableViewController * itvc = [[IngredientsTableViewController alloc] initWithIngredients:ingredients];
    
    // adding the navigation controller
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:itvc];
    //[nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


// METHODS

// -----------------------------------------------------------------------
#pragma mark - IMAGE
// -----------------------------------------------------------------------

- (void)loadImageDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    CGRect imageViewRect = CGRectMake(rectXPosition, rectYPosition, rectWidth, rectHeight);
    NSString * image = [detail objectForKey:@"image"];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    imageView.image = [UIImage imageNamed:image];
    [scrollView addSubview:imageView];
}

// -----------------------------------------------------------------------
#pragma mark - FONTS FOR COOKING TIMES
// -----------------------------------------------------------------------

- (void)timeTextWithRegularString:(NSString *)regString andKey:(NSString *)key inTextView:(UITextView *)textView withXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    // FONTS FOR TIMES
    regFont  = @{NSFontAttributeName: BROWN_14};
    boldFont = @{NSFontAttributeName: BROWN_BOLD_14,
                 //NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                 };

    NSString * rString = [NSString stringWithFormat:@"%@", regString];
    NSAttributedString * one = [[NSAttributedString alloc] initWithString:rString attributes:regFont];
    NSString * str = [detail objectForKey:key];
    NSString * bString = [NSString stringWithFormat:@"%@ min", str];
    NSAttributedString * two = [[NSAttributedString alloc] initWithString:bString attributes:boldFont];
    
    NSMutableAttributedString * prepTimeString = [[NSMutableAttributedString alloc] initWithAttributedString:one];
    [prepTimeString appendAttributedString:two];
    
    CGRect timeRect = CGRectMake(rectXPosition, rectYPosition, rectWidth, rectHeight);
    textView = [[UITextView alloc] initWithFrame:timeRect];
    
    textView.backgroundColor = [UIColor whiteColor];
    textView.attributedText = prepTimeString;
    //[textView sizeToFit];
    [textView actLikeTextLabel];
    
    [scrollView addSubview:textView];
}

// -----------------------------------------------------------------------
#pragma mark - PREP TIME
// -----------------------------------------------------------------------

- (void)loadPrepTimeDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    [self timeTextWithRegularString:NSLocalizedString(@"directions_title", nil) andKey:@"prep_time" inTextView:prepTimeTextView withXPosition:rectXPosition andYPostition:rectYPosition andWidth:rectWidth andHeight:rectHeight];
}

// -----------------------------------------------------------------------
#pragma mark - TOTAL TIME
// -----------------------------------------------------------------------

- (void)loadTotalTimeDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    [self timeTextWithRegularString:NSLocalizedString(@"total", nil) andKey:@"total_time" inTextView:totalTimeTextView withXPosition:rectXPosition andYPostition:rectYPosition andWidth:rectWidth andHeight:rectHeight];
}

// -----------------------------------------------------------------------
#pragma mark - INGREDIENTS
// -----------------------------------------------------------------------

- (void)loadIngredientDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    
    NSMutableParagraphStyle * ingredientsParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    ingredientsParagraphStyle.paragraphSpacing = 7.0;
    ingredientsParagraphStyle.maximumLineHeight = 18.0 * 1.2;
    ingredientsParagraphStyle.headIndent = INSET;
    
    NSMutableParagraphStyle * ingredientsTitleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    ingredientsTitleParagraphStyle.paragraphSpacing = 7.0;
    ingredientsTitleParagraphStyle.paragraphSpacingBefore = 7.0;
    ingredientsTitleParagraphStyle.maximumLineHeight = 18.0 * 1.2;
    ingredientsTitleParagraphStyle.headIndent = 0;
    
    NSDictionary * titlesTextViewAttributes = @{NSFontAttributeName: BROWN_BOLD_18, NSParagraphStyleAttributeName: ingredientsTitleParagraphStyle};

    CGRect ingredientsTextViewRect = CGRectMake(rectXPosition + PADDING, rectYPosition + rulePadHeight, rectWidth - PADDING*2, rectHeight + rulePadHeight);
    UITextView * ingredientsTextView = [[UITextView alloc] initWithFrame:ingredientsTextViewRect];

    NSArray * ingredients = [detail objectForKey:@"ingredients"];
 
    if (ingredients != nil) {
        
        NSMutableAttributedString * mtbl = [[NSMutableAttributedString alloc] init];
        
        for (NSDictionary * dict in ingredients) {
            // title of multiple ingredient list
            NSString * theIngredient    = [NSString stringWithFormat:@"%@\n", [dict objectForKey:NSLocalizedString(@"ingredient_name", nil)]];
            NSAttributedString * ingredientTitlesAttributedString = [[NSAttributedString alloc] initWithString:theIngredient attributes:titlesTextViewAttributes];
            
            [mtbl appendAttributedString:ingredientTitlesAttributedString];
        }
        
        // now that we have the full string lets setup up the view
        ingredientsTextView.attributedText = mtbl;
        [ingredientsTextView sizeToFit];
        [ingredientsTextView actLikeTextLabel];
        [scrollView addSubview:ingredientsTextView];
        ingredientsHeight = ingredientsTextView.frame.size.height;
    }
    
    // rule
    [self addRuleWithXPosition:rectXPosition andYPostition:rectYPosition toView:scrollView];
}

// -----------------------------------------------------------------------
#pragma mark - DIRECTIONS
// -----------------------------------------------------------------------

- (void)loadDirectionsDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    CGRect directionsTextViewRect = CGRectMake(rectXPosition + PADDING, rectYPosition + rulePadHeight, rectWidth - PADDING*2, rectHeight + rulePadHeight);
    UITextView * directionsTextView = [[UITextView alloc] initWithFrame:directionsTextViewRect];
    NSArray * directions = [detail objectForKey:NSLocalizedString(@"directions", nil)];
    NSString * directionsString = [directions componentsJoinedByString:@"\n"];
    
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.paragraphSpacing = 7.0;
    //pStyle.paragraphSpacingBefore = 0;
    pStyle.maximumLineHeight = 18.0 * 1.2;
    pStyle.headIndent = 0;
    NSDictionary * directionsTextViewAttributes = @{NSFontAttributeName: BROWN_18, NSParagraphStyleAttributeName: pStyle};
    NSAttributedString * directionsAttributedString = [[NSAttributedString alloc] initWithString:directionsString attributes:directionsTextViewAttributes];
    
    directionsTextView.attributedText = directionsAttributedString;
    [directionsTextView sizeToFit];
    [directionsTextView actLikeTextLabel];
    [scrollView addSubview:directionsTextView];
    
    directionsHeight = directionsTextView.frame.size.height + rulePadHeight;
    
//    CGRect rulePad = CGRectMake(rectXPosition, rectYPosition, WIDTH, rulePadHeight);
//    UIView * rulePadView = [[UIView alloc] initWithFrame:rulePad];
//    [rulePadView setBackgroundColor:[UIColor redColor]];
//    [scrollView addSubview:rulePadView];
    
    // rule
    [self addRuleWithXPosition:rectXPosition andYPostition:rectYPosition toView:scrollView];
}

// -----------------------------------------------------------------------
#pragma mark - AUTHOR & SOURCE
// -----------------------------------------------------------------------

- (void)loadSourceDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    // author
    CGRect authorTextViewRect = CGRectMake(rectXPosition + PADDING_LABEL, rectYPosition + rulePadHeight, rectWidth, rectHeight + rulePadHeight);
    //NSString * author = [detail objectForKey:@"author"];
    UIView * authorView = [[UIView alloc] initWithFrame:authorTextViewRect];
    UILabel * authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 72, rectHeight)];
    authorLabel.text = [NSString stringWithFormat:NSLocalizedString(@"inspired", nil)];
    authorLabel.font = BROWN_14;
    [authorView addSubview:authorLabel];
    [scrollView addSubview:authorView];
    
    // source
    CGRect sourceTextViewRect = CGRectMake(75, 6, 200, rectHeight);
    UIView * buttonView = [[UIView alloc] initWithFrame:sourceTextViewRect];
    //[buttonView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
    [authorView addSubview:buttonView];
    
    UIButton * sourceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sourceButton.titleLabel.font = BROWN_14;
    NSString * author = [detail objectForKey:@"author"];
    [sourceButton setTitle:author forState:UIControlStateNormal];
    [sourceButton sizeToFit];
    sourceButton.tag = 444;
    [sourceButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:sourceButton];
    
    
    // rule
    [self addRuleWithXPosition:rectXPosition andYPostition:rectYPosition toView:scrollView];
    
}

// ALERT FOR THE SOURCE BUTTON

- (void)buttonTouched:(id)sender {
    UIAlertView * sourceButtonAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title", nil) message:NSLocalizedString(@"message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel_btn", nil) otherButtonTitles:NSLocalizedString(@"other_btn", nil), nil];
    [sourceButtonAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString * source = [detail objectForKey:@"source"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:source]];
    }
}

// -----------------------------------------------------------------------
#pragma mark - HORIZONTAL RULE
// -----------------------------------------------------------------------

- (void)addRuleWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition toView:(UIView *)view
{
    CGRect rulePad = CGRectMake(rectXPosition, rectYPosition, WIDTH, rulePadHeight);
    UIView * rulePadView = [[UIView alloc] initWithFrame:rulePad];
    [rulePadView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:rulePadView];
    
    float ruleThickness = 1.0;
    CGRect ruleFrame = CGRectMake(rectXPosition+PADDING_LABEL, (rulePadHeight-ruleThickness)/2, WIDTH - PADDING_LABEL*2, ruleThickness);
    UIView * ruleView = [[UIView alloc] initWithFrame:ruleFrame];
    ruleView.backgroundColor = [UIColor blackColor];
    [rulePadView addSubview:ruleView];
}

// -----------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
