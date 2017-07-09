//
//  DataBaseManager.m
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "DataBaseManager.h"
#import "CityList+CoreDataClass.h"
#import "AppDelegate.h"


@implementation DataBaseManager

static DataBaseManager *databaseManager = nil;

+ (id)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[DataBaseManager alloc] init];
    });
    return databaseManager;
}


- (void)addEntitytoDB:(NSString *)strCountry andcity:(NSString *)strCityName withCordinate:(CLLocationCoordinate2D)coordinate withCompletionBlock:(void(^)(NSError *error,BOOL success))completionBlock{

    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    CityList *city = [NSEntityDescription insertNewObjectForEntityForName:@"CityList" inManagedObjectContext:context];
    city.country = strCountry;
    city.cityname = strCityName;
    city.latitude = coordinate.latitude;
    city.longitude = coordinate.longitude;
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    
    completionBlock(nil,YES);
}

-(void)fetchDataFromDBForEntity:(NSString *)entity withCompletionBlock:(void(^)(NSError *error, NSArray *result))completionBlock{
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [CityList fetchRequest];
    NSError *error = nil;
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    completionBlock(error,results);

}

-(void)deleteFromDB:(id)city withCompletionBlock:(void (^)(NSError *error, BOOL success))completionBlock{

    CityList *cityObj = (CityList *)city;
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    [context deleteObject:cityObj];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    completionBlock(nil,YES);

}

-(BOOL)checkIfCityAlreadyAdded:(NSString *)cityName{
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;    
    NSFetchRequest *fetchRequest = [CityList fetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"cityname == %@", cityName]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
    
    if (count)
    {
        return YES;
    }
    else
    {
        return NO;
    }

}
@end
