//
//  AppDelegate.h
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/5/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow       * window;
//@property (strong, nonatomic) NSArray        * allRecipesData;
@property (strong, nonatomic) NSMutableArray * allRecipesData;

+ (AppDelegate *)getAppInstance;

@end
