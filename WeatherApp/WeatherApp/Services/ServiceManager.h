//
//  ServiceManager.h
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ServiceManager : NSObject

+ (id)sharedManager;

-(void)getTodaysForcastForCityWithCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(void(^)(NSError *error,id responce))completionBlock;

-(void)getForcastForCityForFiveDaysWithCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(void(^)(NSError *error,id responce))completionBlock;

@end


