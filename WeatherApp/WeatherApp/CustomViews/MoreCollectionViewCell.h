//
//  MoreCollectionViewCell.h
//  WeatherApp
//
//  Created by Swapnali on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPressure;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblClouds;

-(void)setDataOnCell:(NSDictionary *)dictionary;

@end
