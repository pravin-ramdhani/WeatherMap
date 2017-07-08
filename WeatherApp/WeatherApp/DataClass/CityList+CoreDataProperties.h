//
//  CityList+CoreDataProperties.h
//  WeatherApp
//
//  Created by Swapnali on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "CityList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CityList (CoreDataProperties)

+ (NSFetchRequest<CityList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cityname;
@property (nullable, nonatomic, copy) NSString *country;

@end

NS_ASSUME_NONNULL_END
