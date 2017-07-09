//
//  DataBaseManager.h
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataBaseManager : NSObject

+ (id)sharedManager;

- (void)addEntitytoDB:(NSString *)strCountry andcity:(NSString *)strCityName withCordinate:(CLLocationCoordinate2D)coordinate withCompletionBlock:(void(^)(NSError *error,BOOL success))completionBlock;

-(void)fetchDataFromDBForEntity:(NSString *)entity withCompletionBlock:(void(^)(NSError *error, NSArray *result))completionBlock;

-(void)deleteFromDB:(id)city withCompletionBlock:(void (^)(NSError *error, BOOL success))completionBlock;

-(BOOL)checkIfCityAlreadyAdded:(NSString *)cityName;

@end
