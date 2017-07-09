//
//  ServiceManager.m
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "ServiceManager.h"

static NSString *strApiKey = @"c6e381d8c7ff98f0fee43775817cf6ad";

@implementation ServiceManager

static ServiceManager *serviceManager = nil;

+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[ServiceManager alloc] init];
    });
    return serviceManager;
}

-(void)getTodaysForcastForCityWithCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(void(^)(NSError *error,id responce))completionBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric",coordinate.latitude,coordinate.longitude,strApiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id responce;
        if (data) {
            responce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        completionBlock (error,responce);
    } ];
    [datatask resume];
}

-(void)getForcastForCityForFiveDaysWithCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(void(^)(NSError *error,id responce))completionBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%@&units=metric",coordinate.latitude,coordinate.longitude,strApiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id responce;
        if (data) {
            responce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        completionBlock (error,responce);
    } ];
    [datatask resume];
}

@end
