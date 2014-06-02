//
//  BaseViewController.m
//  Recettes
//
//  Created by Pierre-Alexandre Poirier on 5/30/14.
//  Copyright (c) 2014 Pierre-Alexandre Poirier. All rights reserved.
//

#import "UIViewController+NavBarAppearance.h"

@implementation UIViewController (UIViewControllerExtension)

- (void)removeHairlineFromNavigationBar
{
    UIImageView  * navBarHairlineImageView;
    self.navigationController.toolbar.hidden = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    if(navBarHairlineImageView) navBarHairlineImageView.hidden = YES;
}

// removing the hairline below the nav bar
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


@end
