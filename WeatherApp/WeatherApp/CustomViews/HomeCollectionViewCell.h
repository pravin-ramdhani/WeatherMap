//
//  HomeCollectionViewCell.h
//  WeatherApp
//
//  Created by Swapnali on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthBtnDelete;

- (IBAction)btnDeleteCityPressed:(id)sender;

@end
