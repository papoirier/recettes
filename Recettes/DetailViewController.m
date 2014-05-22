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

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize detail, scrollView;

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

#define INSET 18.0f
#define PADDING 5.0f
#define PADDING_LABEL 10.0f

float imageHeight, prepTimeHeight, ingredientsHeight, stepsHeight, authorHeight, sourceHeight, navBarHeight;
float totalHeight;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // title
    NSString * normalTitle = [detail objectForKey:@"title"];
    NSString * shortTitle = [detail objectForKey:@"shortTitle"];
    shortTitle != nil ? [self setTitle:shortTitle] : [self setTitle:normalTitle];
    
    
    // NAVIGATION BAR
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:YES];

    
    // HEIGHTS
    
    navBarHeight        = (20.0 + 44.0);
    imageHeight         = HEIGHT/2;
    prepTimeHeight      = 40.0;
    ingredientsHeight   = 0;
    stepsHeight         = 0;
    authorHeight        = 40.0;
    sourceHeight        = 40.0;
    

    
    // SCROLL VIEW
    
    CGRect scrollViewFrame = CGRectMake(0, 0, WIDTH, HEIGHT);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:scrollView];
    
    // LOADING ALL CONTENT
    
    [self loadImageDetailsWithXPosition:0 andYPostition:-navBarHeight andWidth:WIDTH andHeight:imageHeight];
    
    [self loadPrepTimeDetailsWithXPosition:0 andYPostition:imageHeight-navBarHeight andWidth:WIDTH/2 andHeight:prepTimeHeight];
    
    [self loadTotalTimeDetailsWithXPosition:WIDTH/2 andYPostition:imageHeight-navBarHeight andWidth:WIDTH/2 andHeight:prepTimeHeight];
    
    [self loadIngredientDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight-navBarHeight andWidth:WIDTH andHeight:ingredientsHeight];
    
    [self loadStepsDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight+ingredientsHeight-navBarHeight andWidth:WIDTH andHeight:stepsHeight];
    
    [self loadAuthorDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight+ingredientsHeight+stepsHeight-navBarHeight andWidth:WIDTH andHeight:authorHeight];
    
    [self loadSourceDetailsWithXPosition:0 andYPostition:imageHeight+prepTimeHeight+ingredientsHeight+stepsHeight+authorHeight-navBarHeight andWidth:WIDTH andHeight:sourceHeight];
    
    totalHeight = imageHeight + prepTimeHeight + ingredientsHeight + stepsHeight + authorHeight + sourceHeight-navBarHeight;
    scrollView.contentSize = CGSizeMake(WIDTH, totalHeight);
    
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
                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};

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
    [textView sizeToFit];
    [textView actLikeTextLabel];
    [scrollView addSubview:textView];
}

// -----------------------------------------------------------------------
#pragma mark - PREP TIME
// -----------------------------------------------------------------------

- (void)loadPrepTimeDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    [self timeTextWithRegularString:@"préparation " andKey:@"prepTime" inTextView:prepTimeTextView withXPosition:rectXPosition andYPostition:rectYPosition andWidth:rectWidth andHeight:rectHeight];
}

// -----------------------------------------------------------------------
#pragma mark - TOTAL TIME
// -----------------------------------------------------------------------

- (void)loadTotalTimeDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    [self timeTextWithRegularString:@"total " andKey:@"totalTime" inTextView:totalTimeTextView withXPosition:rectXPosition andYPostition:rectYPosition andWidth:rectWidth andHeight:rectHeight];
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
    ingredientsTitleParagraphStyle.paragraphSpacingBefore = 18;
    ingredientsTitleParagraphStyle.maximumLineHeight = 18.0 * 1.2;
    ingredientsTitleParagraphStyle.headIndent = INSET;
    
    NSDictionary * ingredientsTextViewAttributes = @{NSFontAttributeName: BROWN_18, NSParagraphStyleAttributeName: ingredientsParagraphStyle};
    NSDictionary * titlesTextViewAttributes = @{NSFontAttributeName: BROWN_BOLD_18, NSParagraphStyleAttributeName: ingredientsTitleParagraphStyle};

    CGRect ingredientsTextViewRect = CGRectMake(rectXPosition + PADDING, rectYPosition, rectWidth - PADDING*2, rectHeight);
    
    UITextView * ingredientsTextView = [[UITextView alloc] initWithFrame:ingredientsTextViewRect];
    
    NSArray * ingredients = [detail objectForKey:@"ingredients"];
    NSArray * manyIngredients = [detail objectForKey:@"manyIngredients"];
    //NSLog(@"many ing: %@", manyIngredients);
    
    if (manyIngredients != nil) {
        
        NSMutableAttributedString * mtbl     = [[NSMutableAttributedString alloc] init];
        
        for (NSDictionary * dict in manyIngredients) {
            // title of multiple ingredient list
            NSString * title    = [NSString stringWithFormat:@"%@\n", [dict objectForKey:@"title"]];
            //NSString * title    = [NSString stringWithFormat:@"%@\n", [[dict objectForKey:@"title"] uppercaseString]];
            
            
            // list of multiple ingredients
            NSArray  * ingred   = [dict objectForKey:@"ingredientList"];
            NSString * ingredientListString = [NSString stringWithFormat:@"%@\n", [ingred componentsJoinedByString:@"\n"]];
            
            NSAttributedString * ingredientsAttributedString = [[NSAttributedString alloc] initWithString:ingredientListString attributes:ingredientsTextViewAttributes];
            NSAttributedString * ingredientTitlesAttributedString = [[NSAttributedString alloc] initWithString:title attributes:titlesTextViewAttributes];

            [mtbl appendAttributedString:ingredientTitlesAttributedString];
            [mtbl appendAttributedString:ingredientsAttributedString];
        }
        
        // now that we have the full string lets setup up the view
        
        ingredientsTextView.attributedText = mtbl;
        [ingredientsTextView sizeToFit];
        [ingredientsTextView actLikeTextLabel];
        [scrollView addSubview:ingredientsTextView];
        
    }
    
    else if (ingredients != nil) {
        NSString * ingredientsString = [ingredients componentsJoinedByString:@"\n"];
        NSAttributedString * ingredientsAttributedString = [[NSAttributedString alloc] initWithString:ingredientsString attributes:ingredientsTextViewAttributes];
        ingredientsTextView.attributedText = ingredientsAttributedString;
        [ingredientsTextView sizeToFit];
        [ingredientsTextView actLikeTextLabel];
        [scrollView addSubview:ingredientsTextView];
    }
    
    
    ingredientsHeight = ingredientsTextView.frame.size.height;
    //NSLog(@"ingredients height: %f", ingredientsHeight);
}

// -----------------------------------------------------------------------
#pragma mark - STEPS
// -----------------------------------------------------------------------

- (void)loadStepsDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    CGRect stepsTextViewRect = CGRectMake(rectXPosition + PADDING, rectYPosition, rectWidth - PADDING*2, rectHeight);
    
    UITextView * stepsTextView = [[UITextView alloc] initWithFrame:stepsTextViewRect];
    NSArray * steps = [detail objectForKey:@"steps"];
    NSString * stepsString = [steps componentsJoinedByString:@"\n"];
    
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.paragraphSpacing = 7.0;
    //pStyle.paragraphSpacingBefore = 0;
    pStyle.maximumLineHeight = 18.0 * 1.2;
    pStyle.headIndent = 0;
    NSDictionary * stepsTextViewAttributes = @{NSFontAttributeName: BROWN_18, NSParagraphStyleAttributeName: pStyle};
    NSAttributedString * stepsAttributedString = [[NSAttributedString alloc] initWithString:stepsString attributes:stepsTextViewAttributes];
    
    stepsTextView.attributedText = stepsAttributedString;
    [stepsTextView sizeToFit];
    [stepsTextView actLikeTextLabel];
    [scrollView addSubview:stepsTextView];
    
    stepsHeight = stepsTextView.frame.size.height;
    //NSLog(@"steps height: %f", stepsHeight);
}

// -----------------------------------------------------------------------
#pragma mark - AUTHOR
// -----------------------------------------------------------------------

- (void)loadAuthorDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    CGRect authorTextViewRect = CGRectMake(rectXPosition + PADDING_LABEL, rectYPosition, rectWidth, rectHeight);
    
    NSString * author = [detail objectForKey:@"author"];
    UILabel * authorLabel = [[UILabel alloc] initWithFrame:authorTextViewRect];
    //authorLabel.backgroundColor = [UIColor blueColor];
    authorLabel.text = [NSString stringWithFormat:@"Inspiré par %@", author];
    authorLabel.font = BROWN_18;
    [scrollView addSubview:authorLabel];
}

// -----------------------------------------------------------------------
#pragma mark - SOURCE
// -----------------------------------------------------------------------

- (void)loadSourceDetailsWithXPosition:(CGFloat)rectXPosition andYPostition:(CGFloat)rectYPosition andWidth:(CGFloat)rectWidth andHeight:(CGFloat)rectHeight
{
    CGRect sourceTextViewRect = CGRectMake(rectXPosition + PADDING_LABEL, rectYPosition, rectWidth, rectHeight);
    
    UIView * buttonView = [[UIView alloc] initWithFrame:sourceTextViewRect];
    //buttonView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:buttonView];
    
    UIButton * sourceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //sourceButton.backgroundColor = [UIColor blueColor];
    sourceButton.titleLabel.font = BROWN_14;
    [sourceButton setTitle:@"Source" forState:UIControlStateNormal];
    [sourceButton sizeToFit];
    sourceButton.tag = 444;
    [sourceButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:sourceButton];
}

// ALERT FOR THE SOURCE BUTTON

- (void)buttonTouched:(id)sender {
    UIAlertView * sourceButtonAlert = [[UIAlertView alloc] initWithTitle:@"Ouvrir Safari?" message:@"Vous allez quitter cette application" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ouvrir", nil];
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

- (void)noNavBar
{
    CGRect buttonRect = CGRectMake(0, 20, 120, 30);
    UIView * backButtonView = [[UIView alloc] initWithFrame:buttonRect];
    CGRect backButtonRect = CGRectMake(20, 0, 30, 20);
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backButtonRect;
    UIImage * backButtonImg = [UIImage imageNamed:@"back.png"];
    [backButton setBackgroundImage:backButtonImg forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * theButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = theButton;
    
    /*
     backButton.titleLabel.font = BROWN_18;
     [backButton setTitle:@"Recettes" forState:UIControlStateNormal];
     backButton.frame = backButtonRect;
     [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    [backButtonView addSubview:backButton];
    [self.view addSubview:backButtonView];
}

// -----------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
