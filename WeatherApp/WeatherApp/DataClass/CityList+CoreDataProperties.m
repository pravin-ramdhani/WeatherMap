//
//  CityList+CoreDataProperties.m
//  WeatherApp
//
//  Created by Swapnali on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "CityList+CoreDataProperties.h"

@implementation CityList (CoreDataProperties)

+ (NSFetchRequest<CityList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CityList"];
}

@dynamic cityname;
@dynamic country;

@end
