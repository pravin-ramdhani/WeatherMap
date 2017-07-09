//
//  CityViewController.h
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityList+CoreDataClass.h"

@interface CityViewController : UIViewController

@property(strong,nonatomic) CityList *cityObj;

@end
