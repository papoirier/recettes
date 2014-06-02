//
//  DetailViewController.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/6/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsTableViewController.h"

@interface DetailViewController : UIViewController
{
    NSDictionary * regFont;
    NSDictionary * boldFont;
    UITextView   * prepTimeTextView;
    UITextView   * totalTimeTextView;
}

@property (nonatomic, weak) NSDictionary    * detail;
@property (nonatomic, retain) UIScrollView  * scrollView;

@end
