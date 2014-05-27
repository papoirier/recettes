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
#import "UIImage+ImageEffects.h"
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
    
    self.title = @"Recettes";
    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:50.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // hide navigation bar
    [self.navigationController.navigationBar.topItem setTitle:@""];     // hide back button text
    
    // hide the gray hairline below the nav bar
    self.navigationController.toolbar.hidden = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    if(navBarHairlineImageView) navBarHairlineImageView.hidden = YES;
    
    // remove the extra cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // initializing gestures
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.view addGestureRecognizer:longPress];

    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.view addGestureRecognizer:pan];
    
    cellRef = nil;
    
}

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
    NSData * savedData = [defs objectForKey:@"data"];
    
    if(savedData == nil) {
        data = [AppDelegate getAppInstance].allRecipesData; // loading the data from the AppDelegate
        NSData * saveThisData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [defs setObject:saveThisData forKey:@"data"];
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
    [defs setObject:saveThisData forKey:@"data"];
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

// getting rid of the hailine below the nav bar, on the pushed view
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
        
    }
    
    // load the data in the cell, from the data loaded from the AppDelegate
    NSDictionary * recipesData = [data objectAtIndex:indexPath.row];
    
    // image
    NSString * image = [recipesData objectForKey:@"image"];
    cell.recipeImageView.image = [UIImage imageNamed:image];
    UIImage *effectImage = nil;
    effectImage = [cell.recipeImageView.image applyLightEffectWithBlurRadius:10];
    cell.recipeImageView.image = effectImage;
    
    // title
    NSString * title = [recipesData objectForKey:@"title"];
    cell.recipeTitleLabel.text = title;
    
    // subtitle
    NSString * subtitle = [recipesData objectForKey:@"totalTime"];
    cell.recipeTotalTimeLabel.text = [NSString stringWithFormat:@"%@ minutes", subtitle];


    return cell;
}

// -----------------------------------------------------------------------
#pragma mark - CELL HEIGHT
// -----------------------------------------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}


// ---------------------------------------------------
#pragma mark - PUSH TO POST DETAILS CELL
// ---------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * dvc = [[DetailViewController alloc] init];
    NSDictionary * cellData = [data objectAtIndex:indexPath.row];
    [dvc setDetail:cellData];  // 'detail' is a NSDictionary in DetailScrollView
    
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
            cell.layer.shadowColor = [UIColor blueColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            cell.layer.shadowRadius = 20.0;
            cell.layer.shadowOpacity = 0.8;
            cell.layer.shadowPath = shadowPath.CGPath;
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// -----------------------------------------------------------------------

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// -----------------------------------------------------------------------

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

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
                
                cellRef.underCoverLabel.textColor = [UIColor blackColor];
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
        openCellAlpha = (translation.x * w) / cellOpening;
        
        cellRef.underCover.alpha = openCellAlpha/w;
        cellRef.underCoverLabel.alpha = openCellAlpha/w;
        NSLog(@"cell alpha: %f", cellRef.underCover.alpha);
        
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
        if ((translation.x > cellOpening/2) || (percentage > 0.5 && vel.x > 0)) {
            
            // animation to bring the cell cover's x position back to 0
            [self closeCell:cellRef onComplete:^(void){
                
                CGPoint location= [recognizer locationInView:self.tableView];
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
    [MainTableViewCell animateKeyframesWithDuration:0.3
                                              delay:0
                                            options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                                         animations:^{
                                             cell.cover.frame = CGRectMake(0, 0, self.view.frame.size.width, CELL_HEIGHT);
                                         }
                                         completion:^(BOOL finished) {
                                             if (callback) {
                                                 // now it's C++
                                                 callback();
                                             }
                                         }];
}

@end
