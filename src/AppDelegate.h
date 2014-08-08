//
//  AppDelegate.h
//  Multic
//
//  Created by Ayman Mahfouz on 5/13/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController* navController;
    GameViewController* gameViewController;
}
//@property (strong, nonatomic) IBOutlet UIView *windowOutlet;

@property (strong, nonatomic) IBOutlet UIWindow *window;


@end
