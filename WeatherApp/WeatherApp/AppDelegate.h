//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

