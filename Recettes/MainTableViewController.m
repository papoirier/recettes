//
//  MainTableViewController.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/5/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "MainTableViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "IngredientsTableViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIViewController+NavBarAppearance.h"
#import "Fonts.h"
#import "AppUtils.h"

@interface MainTableViewController ()
@end

@implementation MainTableViewController

@synthesize data, pan, longPress;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    //self.title = @"Recettes";
    [self setTitle:NSLocalizedString(@"recipes", nil)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // hide navigation bar
    [self.navigationController.navigationBar.topItem setTitle:@""];     // hide back button text
    
    [self removeHairlineFromNavigationBar];
    
    // remove the extra cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // initializing gestures
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.tableView addGestureRecognizer:longPress];

    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.navigationController.view addGestureRecognizer:pan];
    
    cellRef = nil;
    
}

// -----------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// -----------------------------------------------------------------------
#pragma mark - LOAD THE DATA
// -----------------------------------------------------------------------

- (void)loadData
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSData * savedData = [defs objectForKey:@"recipes"];
    
    if(savedData == nil) {
        data = [AppDelegate getAppInstance].allRecipesData; // loading the data from the AppDelegate
        NSData * saveThisData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [defs setObject:saveThisData forKey:@"recipes"];
        [defs synchronize];
    }
    else {
        data = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        //NSLog(@"data loaded, yaho");
    }
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

// -----------------------------------------------------------------------
#pragma mark - NAVIGATION BAR STUFF
// -----------------------------------------------------------------------

// hide nav bar on this view controller
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// ---------------------------------------------------
#pragma mark - NUMBER OF SECTIONS
// ---------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data == nil ? 0 : 1;
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
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // load the data in the cell, from the data loaded from the AppDelegate
        NSDictionary * recipesData = [data objectAtIndex:indexPath.row];
        
        // image
        NSString * image = [recipesData objectForKey:@"image"];
        cell.recipeImageView.image = [UIImage imageNamed:image];
        UIImage *effectImage = nil;
        effectImage = [cell.recipeImageView.image applyLightEffectWithBlurRadius:10];
        cell.recipeImageView.image = effectImage;
        
        // title
        NSString * titleKey = NSLocalizedString(@"title", nil);
        NSString * title = [recipesData objectForKey:titleKey];
        cell.recipeTitleLabel.text = title;
        
        // subtitle
        NSString * subtitle = [recipesData objectForKey:@"total_time"];
        cell.recipeTotalTimeLabel.text = [NSString stringWithFormat:@"%@ minutes", subtitle];
    }
    return cell;
}

// -----------------------------------------------------------------------
#pragma mark - CELL HEIGHT
// -----------------------------------------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


// ---------------------------------------------------
#pragma mark - PUSH TO POST DETAILS CELL
// ---------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cellData = [data objectAtIndex:indexPath.row];
    
    DetailViewController * dvc = [[DetailViewController alloc] init];
    [dvc setDetail:cellData]; // 'detail' is a NSDictionary in DetailViewController
    [self.navigationController pushViewController:dvc animated:YES];
}

// -----------------------------------------------------------------------
#pragma mark - LONG PRESS GESTURE
// -----------------------------------------------------------------------

- (BOOL)longPressGesture:(UILongPressGestureRecognizer *)longPressRecognizer
{
    // -----------------------------------------------------------------------
    // began
    // -----------------------------------------------------------------------
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint tp = [longPressRecognizer locationInView:self.tableView];
        sourceIndex = [self.tableView indexPathForRowAtPoint:tp];
        
        MainTableViewCell * cell = (MainTableViewCell*)[self.tableView cellForRowAtIndexPath:sourceIndex];
        if(cell) {
            shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds];
            cell.layer.masksToBounds = NO;
            cell.layer.shadowColor = [UIColor greenColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            cell.layer.shadowRadius = 10.0;
            cell.layer.shadowOpacity = 0.8;
            cell.layer.shadowPath = shadowPath.CGPath;
            
            #pragma mark - bring the selected cell to the front
            [self.tableView bringSubviewToFront:[cell superview]];
            [[cell superview] bringSubviewToFront:cell];
        }
        
    }
    
    // -----------------------------------------------------------------------
    // changed
    // -----------------------------------------------------------------------
    if (longPressRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint tp = [longPressRecognizer locationInView:self.tableView];
        NSIndexPath * destIndex = [self.tableView indexPathForRowAtPoint:tp];
        
        if (tp.y > self.tableView.contentSize.height) {
            // this makes it exit the function - does nothing after it if it's true
            return YES;
        }
        
        if([destIndex isEqual:sourceIndex] == NO) {
            // get/remove/insert the object, then move it
            [data exchangeObjectAtIndex:sourceIndex.row withObjectAtIndex:destIndex.row];
            //[self.tableView.superview bringSubviewToFront:self];
            [self.tableView moveRowAtIndexPath:sourceIndex toIndexPath:destIndex];
            sourceIndex = destIndex;
        }
    }
    
    // -----------------------------------------------------------------------
    // ended
    // -----------------------------------------------------------------------
    if (longPressRecognizer.state == UIGestureRecognizerStateEnded || longPressRecognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"ended");
        MainTableViewCell * cell = (MainTableViewCell*)[self.tableView cellForRowAtIndexPath:sourceIndex];
        if(cell) {
            shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds];
            cell.layer.masksToBounds = NO;

            cell.layer.shadowOpacity = 0;
            cell.layer.shadowPath = shadowPath.CGPath;
        }
        [self saveData];
    }
    return YES;
}

// -----------------------------------------------------------------------
#pragma mark - DATA SAVING STUFF
// -----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary * draggedData = [data objectAtIndex:sourceIndexPath.row];
    [data removeObject:draggedData];
    [data insertObject:draggedData atIndex:destinationIndexPath.row];
    [self saveData];
}

// -----------------------------------------------------------------------
#pragma mark - PANNING GESTURE
// -----------------------------------------------------------------------

- (BOOL)panHandler:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.tableView]; // location where the user has fist touched
    float cellOpening = round(self.view.frame.size.width/3);
    float openTrigger = 0.75;
    
    // -----------------------------------------------------------------------
    // Began
    // -----------------------------------------------------------------------
    if(recognizer.state == UIGestureRecognizerStateBegan) {
    
        if(cellRef == nil) {
            NSIndexPath * pannedIndexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
            MainTableViewCell * cell = (MainTableViewCell *)[self.tableView cellForRowAtIndexPath:pannedIndexPath];
            if(cell) {
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
    
    // -----------------------------------------------------------------------
    // changed ( and we have a cellRef )
    // -----------------------------------------------------------------------
    if(recognizer.state == UIGestureRecognizerStateChanged && cellRef != nil) {
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
    
    // -----------------------------------------------------------------------
    // ended
    // -----------------------------------------------------------------------
    if(recognizer.state == UIGestureRecognizerStateEnded && cellRef != nil) {
        
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
                    
                    NSDictionary * draggedData = [data objectAtIndex:pannedIndexPath.row];
                    [data removeObject:draggedData];
                    [data insertObject:draggedData atIndex:destinationIndexPath.row];
                    
                    [self saveData];
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
- (void)closeCell:(MainTableViewCell *)cell onComplete:(BasicBlock)callback
{
    [MainTableViewCell animateWithDuration:0.25
                          delay:0
                        options:(UIViewAnimationCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         cell.cover.frame = CGRectMake(0, 0, self.view.frame.size.width, CELL_HEIGHT);
                     }
                                completion:^(BOOL finished){
                                    if (callback) {
                                        // now it's C++
                                        callback();
                                    }
                     }];
}

@end
