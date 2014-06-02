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

@interface IngredientsTableViewController ()

@end

@implementation IngredientsTableViewController

@synthesize data;

- (id)initWithIngredients:(NSArray *)ingredients
{
    // overriding the init function in MainTableViewController
    self = [super init];
    if (self) {
        data = ingredients;
        NSLog(@"%@", ingredients);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    [self removeHairlineFromNavigationBar];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
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
}

// -----------------------------------------------------------------------

- (void)dismissIngredientsList:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// -----------------------------------------------------------------------

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data ? 1 : 0;
}

// -----------------------------------------------------------------------

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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    //indexPath.row
    NSDictionary * theIngredient = [data objectAtIndex:indexPath.row];
    NSString * name     = [theIngredient objectForKey:NSLocalizedString(@"ingredient_name", nil)];
    NSString * quantity = [theIngredient objectForKey:NSLocalizedString(@"ingredient_qty", nil)];
    
    cell.ingredientNameLabel.text = name;
    cell.ingredientQuantityLabel.text = quantity;
    
    return cell;
}



@end
