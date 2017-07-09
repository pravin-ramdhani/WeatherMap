//
//  MoreCollectionViewCell.m
//  WeatherApp
//
//  Created by Swapnali on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "MoreCollectionViewCell.h"

@implementation MoreCollectionViewCell

-(void)setDataOnCell:(NSDictionary *)dictionary{
    
    self.lblDate.text = [dictionary valueForKey:@"Date"];
    self.lblTemp.text = [dictionary valueForKey:@"Temperature"];
    self.lblClouds.text = [dictionary valueForKey:@"Clouds"];
    self.lblHumidity.text = [dictionary valueForKey:@"Humidity"];
    self.lblPressure.text = [dictionary valueForKey:@"Pressure"];
    self.lblWindSpeed.text = [dictionary valueForKey:@"Wind"];
    self.lblDescription.text = [dictionary valueForKey:@"Description"];
}

@end
