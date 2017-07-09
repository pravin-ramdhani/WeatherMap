//
//  HomeCollectionViewCell.m
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setDataOnCell:(BOOL)isDelete{

    self.lblCityName.text = self.city.cityname;
    self.widthBtnDelete.constant = isDelete?50:0;
}

- (IBAction)btnDeleteCityPressed:(id)sender {
    
    NSLog(@"btnDeleteCityPressed");
    [self.delegate deleteCell:self];
    
}
@end
