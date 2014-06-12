//
//  IngredientsTableViewController.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/30/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "IngredientsTableViewController.h"
#import "IngredientsTableViewCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "UIViewController+NavBarAppearance.h"
#import "AppUtils.h"

@interface IngredientsTableViewController ()

@end

@implementation IngredientsTableViewController

@synthesize data, pan;

- (id)initWithIngredients:(NSMutableArray *)ingredients
{
    // overriding the init function in MainTableViewController
    self = [super init];
    if (self) {
        data = [NSMutableArray arrayWithArray:ingredients];
    }
    return self;
}

// -----------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self removeHairlineFromNavigationBar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // NAVIGATION BAR
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    // title
    NSString * theTitle = NSLocalizedString(@"ingredients_title", nil);
    [self setTitle:theTitle];
    
    // right button
    UIBarButtonItem * ingredientsListButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissIngredientsList:)];
    self.navigationItem.rightBarButtonItem = ingredientsListButton;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];  // remove the extra cells
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.navigationController.view addGestureRecognizer:pan];
    
    cellRef = nil;
}

// -----------------------------------------------------------------------

- (void)dismissIngredientsList:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// -----------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// -----------------------------------------------------------------------
#pragma mark - SAVE THE DATA
// -----------------------------------------------------------------------
- (void)saveData {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSData * saveThisData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [defs setObject:saveThisData forKey:@"recipes"];
    [defs synchronize];
}


// ---------------------------------------------------
#pragma mark - NUMBER OF SECTIONS
// ---------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data ? 1 : 0;
}

// ---------------------------------------------------
#pragma mark - NUMBER OF ROWS IN SECTIONS
// ---------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

// ---------------------------------------------------
#pragma mark - CONSTRUCT THE CELL
// ---------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    IngredientsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[IngredientsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    NSDictionary * theIngredient = [data objectAtIndex:indexPath.row];
    NSString * name     = [theIngredient objectForKey:NSLocalizedString(@"ingredient_name", nil)];
    NSString * quantity = [theIngredient objectForKey:NSLocalizedString(@"ingredient_qty", nil)];
    
    cell.ingredientNameLabel.text = name;
    cell.ingredientQuantityLabel.text = quantity;
    
    // under cover
    [cell.underCover setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0]];
    [cell.underCoverLabel setTextColor:[UIColor colorWithWhite:1 alpha:0]];
    
    // cover
    float cellAlpha = (float)((indexPath.row + 1) * (data.count - 2));
    [cell.cover setBackgroundColor:[UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:cellAlpha/100]];
    
    return cell;
}

// -----------------------------------------------------------------------
#pragma mark - CELL HEIGHT
// -----------------------------------------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return INGREDIENT_CELL_HEIGHT;
}

// -----------------------------------------------------------------------
#pragma mark - PANNING GESTURE
// -----------------------------------------------------------------------

- (BOOL)panHandler:(UIPanGestureRecognizer *)recognizer
{
    // location in view where user has touched
    CGPoint touchPoint = [recognizer locationInView:self.tableView];
    float cellOpening = round(self.view.frame.size.width/3);
    float openTrigger = 0.75;
    
    // BEGAN //
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (cellRef == nil) {
            NSIndexPath * pannedIndexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
            IngredientsTableViewCell * cell = (IngredientsTableViewCell *)[self.tableView cellForRowAtIndexPath:pannedIndexPath];
            
            if (cell) {
                // set the touch offset
                offset = touchPoint;
                offset.x -= cell.cover.frame.origin.x;
                
                // store a ref to the cell we touched
                cellRef = cell;
                cell.underCover.backgroundColor = [UIColor greenColor];
                cell.underCover.alpha = 0;
                
                cellRef.underCoverLabel.textColor = [UIColor whiteColor];
                cellRef.underCoverLabel.alpha = 0;
            }
            
        }
    }
    
    // CHANGED //
    if (recognizer.state == UIGestureRecognizerStateChanged && cellRef != nil) {
        CGRect originalFrame = cellRef.frame;
        float newX = touchPoint.x - offset.x;
        originalFrame.origin = CGPointMake(newX, 0);
        CGPoint translation = [recognizer translationInView:self.tableView];
        
        cellRef.underCover.alpha = 0;
        float openCellAlpha = 0;
        float w = self.view.frame.size.width;
        openCellAlpha = (translation.x * w) / (cellOpening*0.85);
        
        cellRef.underCover.alpha = openCellAlpha/w;
        cellRef.underCoverLabel.alpha = openCellAlpha/w;
        
        // clamping so it doesn't go left past 0
        if (originalFrame.origin.x < 0) {
            originalFrame.origin.x = 0;
        }
        
        else if (originalFrame.origin.x >= cellOpening) {
            originalFrame.origin.x = cellOpening;
        }
        
        cellRef.cover.frame = originalFrame;
    }
    
    // ENDED //
    if (recognizer.state == UIGestureRecognizerStateEnded && cellRef != nil) {
        __block CGRect originalFrame = cellRef.frame;
        CGPoint translation = [recognizer translationInView:self.tableView];
        CGPoint vel = [recognizer velocityInView:cellRef.cover];
        float percentage = touchPoint.x / cellRef.cover.frame.size.width;
        
        // open it!
        if ((translation.x > cellOpening * openTrigger) || (percentage > openTrigger && vel.x > 0)) {

        // animation to bring the cell cover's x position back to 0
        [self closeCell:cellRef onComplete:^(void){
                
                
                CGPoint location = [recognizer locationInView:self.tableView];
                NSIndexPath * pannedIndexPath = [self.tableView indexPathForRowAtPoint:location];
                //NSLog(@"selected row: %ld", (long)pannedIndexPath.row);
                
                originalFrame.origin  = CGPointMake(cellOpening, 0);
                //cellRef.cover.backgroundColor = [UIColor brownColor];
                
                #pragma mark - move cell on swipe, save the data
                // if cell exists at that location, bring in down
                if ([self.tableView cellForRowAtIndexPath:pannedIndexPath]) {
                    
                    NSIndexPath * destinationIndexPath = [NSIndexPath indexPathForRow:data.count-1 inSection:0];
                    
                    [self.tableView moveRowAtIndexPath:pannedIndexPath toIndexPath:destinationIndexPath];
                    [data exchangeObjectAtIndex:pannedIndexPath.row withObjectAtIndex:destinationIndexPath.row];
                    
                    //[self.tableView reloadData];
                    //[self saveData];
                }
                
           }];
            
        }
        
        // close it if it's not opened wide enough
        else {
            originalFrame.origin  = CGPointMake(0, 0);
            [self closeCell:cellRef onComplete:nil];
        }
        
        // we are no longer using cell ref - nil it
        cellRef = nil;
    }
    
    return YES;
}


// -----------------------------------------------------------------------
#pragma mark - close the cell
// -----------------------------------------------------------------------

- (void)closeCell:(IngredientsTableViewCell *)cell onComplete:(BasicBlock)callback
{
    [IngredientsTableViewCell animateWithDuration:0.25
                                     delay:0
                                   options:(UIViewAnimationCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
                                animations:^{
                                    cell.cover.frame = CGRectMake(0, 0, self.view.frame.size.width, INGREDIENT_CELL_HEIGHT);
                                }
                                completion:^(BOOL finished){
                                    if (callback) {
                                        // now it's C++
                                        callback();
                                    }
                                }];
}


// -----------------------------------------------------------------------
#pragma mark - END DISPLAY
// -----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
