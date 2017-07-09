//
//  WeatherCollectionViewCell.h
//  WeatherApp
//
//  Created by Pravin on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

-(void)setDataOnCell:(NSDictionary *)dictionary;
@end
