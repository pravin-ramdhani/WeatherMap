//
//  CityList+CoreDataProperties.h
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "CityList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CityList (CoreDataProperties)

+ (NSFetchRequest<CityList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cityname;
@property (nullable, nonatomic, copy) NSString *country;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end

NS_ASSUME_NONNULL_END
