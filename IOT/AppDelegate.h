//
//  AppDelegate.h
//  IOT
//
//  Created by Georgios Stylianou on 30/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class dbAccess;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain)dbAccess*q;
@end

