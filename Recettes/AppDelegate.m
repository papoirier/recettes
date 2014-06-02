//
//  AppDelegate.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/5/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "AppDelegate.h"
#import "Fonts.h"

@implementation AppDelegate

@synthesize allRecipesData;

+ (AppDelegate *)getAppInstance
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // -----------------------------------------------------------------------
    #pragma mark - NAVIGATION BAR
    // -----------------------------------------------------------------------
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]]; // color of all elements in nav bar
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSFontAttributeName: BROWN_BOLD_18,
                                                             NSForegroundColorAttributeName: [UIColor blackColor] }];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:1.0 forBarMetrics:UIBarMetricsDefault]; // shifting the title's baseline by 1px
    
    // right button
    NSDictionary * textAttributes = @{ NSFontAttributeName : BROWN_18,
                                       NSForegroundColorAttributeName: [UIColor greenColor] };
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationController class],nil] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];

    // ---------------------------------------------------
    #pragma mark - LOADING THE DATA
    // ---------------------------------------------------
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:NSLocalizedString(@"json_data", nil) withExtension:@"json"];
    NSData * URLData = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:URLData options:kNilOptions error:nil];
    
    if (dic) {
        //allRecipesData = [[NSArray alloc] initWithArray:[dic objectForKey:@"recipes"] copyItems:YES];
        NSArray * recipesData = [[NSArray alloc] initWithArray:[dic objectForKey:@"recipes"]];
        allRecipesData = [(NSArray *)recipesData mutableCopy];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
