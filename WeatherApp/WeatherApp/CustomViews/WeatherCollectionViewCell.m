//
//  WeatherCollectionViewCell.m
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "WeatherCollectionViewCell.h"

@implementation WeatherCollectionViewCell

-(void)setDataOnCell:(NSDictionary *)dictionary{
    
    for (NSString *key in dictionary) {
        id value = dictionary[key];
        self.lblHeader.text = [NSString stringWithFormat:@"%@",key];
        self.lblValue.text = [NSString stringWithFormat:@"%@",value];
    }
}

@end
